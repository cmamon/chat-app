import 'package:kora_chat/core/database/app_database.dart';
import 'package:kora_chat/features/chat/data/chat_repository.dart';
import 'package:kora_chat/features/chat/domain/chat_models.dart' as domain;
import 'package:kora_chat/features/auth/domain/auth_models.dart' as domain;
import 'package:kora_chat/providers/api_providers.dart';
import 'package:kora_chat/core/utils/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'chat_sync_service.g.dart';

@Riverpod(keepAlive: true)
class ChatSyncService extends _$ChatSyncService {
  @override
  void build() {
    // No initialization state needed, we just need access to ref
  }

  AppDatabase get _db => ref.read(appDatabaseProvider);
  ChatRepository get _remote => ref.read(chatRepositoryProvider);

  Future<void> syncChats() async {
    try {
      final remoteChats = await _remote.getChats();
      for (final chat in remoteChats) {
        await syncChat(chat.id);
      }
    } catch (e, stack) {
      Log.e('Sync: Failed to fetch chats', e, stack);
    }
  }

  Future<void> syncChat(String chatId) async {
    try {
      final chat = await _remote.getChat(chatId);
      await _db.saveChat(
        _domainChatToDb(chat),
        chat.participants.map((p) => _domainProfileToDb(p)).toList(),
      );

      // If the chat has a last message, save it too so it's visible in the list
      if (chat.lastMessage != null) {
        await _db.saveMessage(_domainMessageToDb(chat.lastMessage!));
      }
    } catch (e) {
      Log.e('Sync: Failed to fetch chat $chatId', e);
    }
  }

  Future<void> syncMessages(String chatId) async {
    try {
      final remoteMessages = await _remote.getMessages(chatId);
      await _db.saveMessages(
        remoteMessages.map((m) => _domainMessageToDb(m)).toList(),
      );
    } catch (e) {
      Log.e('Sync: Failed to fetch messages for $chatId', e);
    }
  }

  // Converters
  ChatData _domainChatToDb(domain.Chat chat) {
    return ChatData(
      id: chat.id,
      name: chat.name,
      avatarUrl: chat.avatarUrl,
      isGroup: chat.isGroup,
      unreadCount: chat.unreadCount,
    );
  }

  UserData _domainProfileToDb(domain.UserProfile profile) {
    return UserData(
      id: profile.id,
      username: profile.username,
      email: profile.email,
      firstName: profile.firstName,
      lastName: profile.lastName,
      avatarUrl: profile.avatarUrl,
    );
  }

  MessageData _domainMessageToDb(domain.Message message) {
    return MessageData(
      id: message.id,
      chatId: message.chatId,
      senderId: message.senderId,
      content: message.content,
      createdAt: message.createdAt,
      isRead: message.isRead,
      status: message.status.name,
      type: message.type,
    );
  }
}
