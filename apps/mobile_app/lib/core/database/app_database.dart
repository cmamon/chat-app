import 'package:drift/drift.dart';
import 'package:kora_chat/features/auth/domain/auth_models.dart' as domain;
import 'package:kora_chat/features/chat/domain/chat_models.dart' as domain;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'connection/connection.dart';

part 'app_database.g.dart';

@DataClassName('UserData')
class Users extends Table {
  TextColumn get id => text()();
  TextColumn get username => text()();
  TextColumn get email => text()();
  TextColumn get firstName => text().nullable()();
  TextColumn get lastName => text().nullable()();
  TextColumn get avatarUrl => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('ChatData')
class Chats extends Table {
  TextColumn get id => text()();
  TextColumn get name => text().nullable()();
  TextColumn get avatarUrl => text().nullable()();
  BoolColumn get isGroup => boolean().withDefault(const Constant(false))();
  IntColumn get unreadCount => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('MessageData')
@TableIndex(name: 'msg_chat_date', columns: {#chatId, #createdAt})
class Messages extends Table {
  TextColumn get id => text()();
  TextColumn get chatId => text().references(Chats, #id)();
  TextColumn get senderId => text().references(Users, #id)();
  TextColumn get content => text()();
  DateTimeColumn get createdAt => dateTime()();
  BoolColumn get isRead => boolean().withDefault(const Constant(false))();
  TextColumn get type => text().nullable()();
  TextColumn get status => text().withDefault(const Constant('sent'))();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('ChatParticipantData')
class ChatParticipants extends Table {
  TextColumn get chatId => text().references(Chats, #id)();
  TextColumn get userId => text().references(Users, #id)();

  @override
  Set<Column> get primaryKey => {chatId, userId};
}

@DriftDatabase(tables: [Users, Chats, Messages, ChatParticipants])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? openConnection());

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onUpgrade: (m, from, to) async {
      if (from < 3) {
        // Simplest for development: recreate tables.
        await m.deleteTable('chat_participants');
        await m.deleteTable('messages');
        await m.deleteTable('chats');
        await m.deleteTable('users');
        await m.createAll();
      }
    },
  );

  // Users
  Future<void> saveUser(UserData user) =>
      into(users).insertOnConflictUpdate(user);
  Stream<UserData> watchUser(String id) =>
      (select(users)..where((u) => u.id.equals(id))).watchSingle();

  // Chats
  Future<void> saveChat(ChatData chat, List<UserData> participants) async {
    await batch((batch) {
      batch.insertAll(users, participants, mode: InsertMode.insertOrReplace);
      batch.insert(chats, chat, mode: InsertMode.insertOrReplace);

      final participantEntries = participants
          .map((u) => ChatParticipantData(chatId: chat.id, userId: u.id))
          .toList();
      batch.insertAll(
        chatParticipants,
        participantEntries,
        mode: InsertMode.insertOrReplace,
      );
    });
  }

  Stream<List<ChatData>> watchChats() => select(chats).watch();

  Future<List<ChatData>> getChats() => select(chats).get();

  Stream<domain.Chat?> watchChat(String chatId) {
    return _chatsWithMetadataQuery(chatId: chatId).watch().map((rows) {
      final chatsList = _groupRowsIntoChats(rows);
      return chatsList.isEmpty ? null : chatsList.first;
    });
  }

  Future<domain.Chat?> getChat(String chatId) async {
    final rows = await _chatsWithMetadataQuery(chatId: chatId).get();
    final chatsList = _groupRowsIntoChats(rows);
    return chatsList.isEmpty ? null : chatsList.first;
  }

  Stream<List<domain.Chat>> watchChatsWithParticipants() {
    return _chatsWithMetadataQuery().watch().map(_groupRowsIntoChats);
  }

  /// Specialized query that joins chats, participants, and their last message.
  /// Solves N+1 problem and maintains full reactivity.
  JoinedSelectStatement _chatsWithMetadataQuery({String? chatId}) {
    final query = select(chats).join([
      leftOuterJoin(
        chatParticipants,
        chatParticipants.chatId.equalsExp(chats.id),
      ),
      leftOuterJoin(users, users.id.equalsExp(chatParticipants.userId)),
      leftOuterJoin(
        messages,
        messages.chatId.equalsExp(chats.id) &
            messages.createdAt.equalsExp(
              subqueryExpression(
                selectOnly(messages)
                  ..addColumns([messages.createdAt.max()])
                  ..where(messages.chatId.equalsExp(chats.id)),
              ),
            ),
      ),
    ]);

    if (chatId != null) {
      query.where(chats.id.equals(chatId));
    }

    return query;
  }

  /// Groups JOIN results back into domain.Chat objects
  List<domain.Chat> _groupRowsIntoChats(List<TypedResult> rows) {
    final groupedChats = <String, domain.Chat>{};
    final participantsPerChat = <String, List<domain.UserProfile>>{};

    for (final row in rows) {
      final chatData = row.readTable(chats);
      final userData = row.readTableOrNull(users);
      final msgData = row.readTableOrNull(messages);

      if (userData != null) {
        final participant = domain.UserProfile(
          id: userData.id,
          username: userData.username,
          email: userData.email,
          firstName: userData.firstName,
          lastName: userData.lastName,
          avatarUrl: userData.avatarUrl,
        );
        final list = participantsPerChat.putIfAbsent(chatData.id, () => []);
        if (!list.any((p) => p.id == participant.id)) {
          list.add(participant);
        }
      }

      if (!groupedChats.containsKey(chatData.id)) {
        final lastMsg = msgData != null
            ? domain.Message(
                id: msgData.id,
                chatId: msgData.chatId,
                senderId: msgData.senderId,
                content: msgData.content,
                createdAt: msgData.createdAt,
                isRead: msgData.isRead,
                status: domain.MessageStatus.values.firstWhere(
                  (e) => e.name == msgData.status,
                  orElse: () => domain.MessageStatus.sent,
                ),
                type: msgData.type,
              )
            : null;

        groupedChats[chatData.id] = domain.Chat(
          id: chatData.id,
          name: chatData.name,
          avatarUrl: chatData.avatarUrl,
          isGroup: chatData.isGroup,
          unreadCount: chatData.unreadCount,
          participants: const [], // Will be populated in the next step
          lastMessage: lastMsg,
        );
      }
    }

    return groupedChats.entries.map((entry) {
      return entry.value.copyWith(
        participants: participantsPerChat[entry.key] ?? [],
      );
    }).toList();
  }

  // Messages
  Future<void> saveMessages(List<MessageData> messageList) async {
    await batch((batch) {
      batch.insertAll(messages, messageList, mode: InsertMode.insertOrReplace);
    });
  }

  Future<void> saveMessage(MessageData message, {String? optimisticId}) async {
    await batch((batch) {
      if (optimisticId != null) {
        batch.deleteWhere(messages, (m) => m.id.equals(optimisticId));
      }
      batch.insert(messages, message, mode: InsertMode.insertOrReplace);
    });
  }

  Stream<List<MessageData>> watchMessages(String chatId) =>
      (select(messages)
            ..where((m) => m.chatId.equals(chatId))
            ..orderBy([(m) => OrderingTerm.desc(m.createdAt)]))
          .watch();

  // --- Maintenance & Pruning ---

  /// Deletes messages older than the specified duration.
  Future<int> deleteOldMessages(Duration olderThan) {
    final date = DateTime.now().subtract(olderThan);
    return (delete(
      messages,
    )..where((m) => m.createdAt.isSmallerThanValue(date))).go();
  }

  /// Keeps only the last [limit] messages for a specific chat using an efficient subquery.
  Future<void> pruneChatMessages(String chatId, int limit) async {
    await customStatement(
      '''
      DELETE FROM messages 
      WHERE chat_id = ? AND id NOT IN (
        SELECT id FROM messages 
        WHERE chat_id = ? 
        ORDER BY created_at DESC 
        LIMIT ?
      )
    ''',
      [chatId, chatId, limit],
    );
  }

  /// Compacts the database and releases unused space to the OS.
  Future<void> vacuum() async {
    await customStatement('VACUUM');
  }
}

@Riverpod(keepAlive: true)
AppDatabase appDatabase(Ref ref) {
  return AppDatabase();
}
