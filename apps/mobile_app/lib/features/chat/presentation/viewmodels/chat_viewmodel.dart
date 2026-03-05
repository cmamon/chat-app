import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:kora_chat/features/chat/domain/chat_state.dart';
import 'package:kora_chat/features/chat/domain/chat_models.dart' as domain;
import 'package:kora_chat/services/socket_service.dart';
import 'package:kora_chat/core/database/app_database.dart';
import 'package:kora_chat/features/chat/data/chat_sync_service.dart';

part 'chat_viewmodel.g.dart';

@riverpod
class ChatViewModel extends _$ChatViewModel {
  StreamSubscription? _socketSubscription;
  StreamSubscription? _dbSubscription;

  @override
  ChatState build() {
    // 1. Initial sync in background
    Future.microtask(
      () => ref.read(chatSyncServiceProvider.notifier).syncChats(),
    );

    // 2. Watch database for local changes
    _dbSubscription = ref
        .watch(appDatabaseProvider)
        .watchChatsWithParticipants()
        .listen((chats) {
          state = state.copyWith(chats: chats, isLoading: false);

          // Join rooms for all chats loaded from DB
          final socket = ref.read(socketServiceProvider);
          for (final chat in chats) {
            socket.joinRoom(chat.id);
          }
        });

    // 3. Listen for global real-time updates
    _initSocketListener();

    ref.onDispose(() {
      _socketSubscription?.cancel();
      _dbSubscription?.cancel();
    });

    return const ChatState(isLoading: true);
  }

  void _initSocketListener() {
    final socketService = ref.read(socketServiceProvider);
    socketService.connect();

    _socketSubscription = socketService.messageStream.listen((data) async {
      final String? chatId = data['chatId'] ?? data['roomId'];
      if (chatId == null) return;

      final newMessage = domain.Message(
        id: data['id'] ?? DateTime.now().toString(),
        chatId: chatId,
        senderId: data['senderId'] ?? data['userId'] ?? '',
        content: data['content'] ?? '',
        createdAt: data['createdAt'] != null
            ? DateTime.parse(data['createdAt'].toString())
            : DateTime.now(),
        isRead: false,
      );

      // Save to DB (UI will update automatically via stream)
      final db = ref.read(appDatabaseProvider);
      await db.saveMessage(_domainMessageToDb(newMessage));
    });
  }

  Future<void> loadChats() async {
    state = state.copyWith(isLoading: true);
    await ref.read(chatSyncServiceProvider.notifier).syncChats();
    state = state.copyWith(isLoading: false);
  }

  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  // Helper converter
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

@riverpod
List<domain.Chat> filteredChats(Ref ref) {
  final chatState = ref.watch(chatViewModelProvider);
  final query = chatState.searchQuery.toLowerCase();

  if (query.isEmpty) {
    return chatState.chats;
  }

  return chatState.chats.where((chat) {
    final nameMatch = chat.name?.toLowerCase().contains(query) ?? false;
    final participantMatch = chat.participants.any(
      (p) =>
          p.username.toLowerCase().contains(query) ||
          (p.firstName?.toLowerCase().contains(query) ?? false) ||
          (p.lastName?.toLowerCase().contains(query) ?? false),
    );
    final lastMessageMatch =
        chat.lastMessage?.content.toLowerCase().contains(query) ?? false;

    return nameMatch || participantMatch || lastMessageMatch;
  }).toList();
}
