import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:kora_chat/features/chat/domain/message_state.dart';
import 'package:kora_chat/features/chat/domain/chat_models.dart' as domain;
import 'package:kora_chat/services/socket_service.dart';
import 'package:kora_chat/core/database/app_database.dart';
import 'package:kora_chat/features/chat/data/chat_sync_service.dart';
import 'package:kora_chat/features/auth/presentation/viewmodels/auth_viewmodel.dart';

part 'message_viewmodel.g.dart';

@riverpod
class MessageViewModel extends _$MessageViewModel {
  StreamSubscription? _socketSubscription;
  StreamSubscription? _dbMessagesSubscription;
  StreamSubscription? _dbChatSubscription;

  @override
  MessageState build(String chatId) {
    // 1. Initial sync in background
    Future.microtask(() async {
      if (!ref.mounted) return;
      await ref.read(chatSyncServiceProvider.notifier).syncChat(chatId);
      if (!ref.mounted) return;
      await ref.read(chatSyncServiceProvider.notifier).syncMessages(chatId);
    });

    // 2. Watch database for local changes
    final db = ref.watch(appDatabaseProvider);

    _dbMessagesSubscription = db.watchMessages(chatId).listen((messages) {
      final domainMessages = messages
          .map((m) => _dbToDomainMessage(m))
          .toList();
      state = state.copyWith(messages: domainMessages, isLoading: false);
    });

    _dbChatSubscription = db.watchChat(chatId).listen((chat) {
      if (chat != null) {
        state = state.copyWith(currentChat: chat);
      }
    });

    _initSocket();

    ref.onDispose(() {
      _socketSubscription?.cancel();
      _dbMessagesSubscription?.cancel();
      _dbChatSubscription?.cancel();
    });

    return const MessageState(isLoading: true);
  }

  void _initSocket() {
    final socketService = ref.read(socketServiceProvider);
    socketService.connect();
    socketService.joinRoom(chatId);

    _socketSubscription = socketService.messageStream.listen((data) async {
      if (data['roomId'] == chatId || data['chatId'] == chatId) {
        final optimisticId = data['clientMsgId']?.toString();

        final newMessage = domain.Message(
          id: data['id']?.toString() ?? DateTime.now().toString(),
          chatId: chatId,
          senderId:
              data['senderId']?.toString() ?? data['userId']?.toString() ?? '',
          content: data['content']?.toString() ?? '',
          createdAt: data['createdAt'] != null
              ? DateTime.parse(data['createdAt'].toString())
              : DateTime.now(),
          isRead: false,
        );

        // Save to DB (UI will update via stream), replacing optimistic message if it exists
        await ref
            .read(appDatabaseProvider)
            .saveMessage(
              _domainToDbMessage(newMessage),
              optimisticId: optimisticId,
            );
      }
    });
  }

  Future<void> sendMessage(String content) async {
    final trimmed = content.trim();
    if (trimmed.isEmpty) return;

    final authState = ref.read(authViewModelProvider);
    final currentUserId = authState.currentUser?.id ?? '';

    // 1. Generate local optimistic message
    final clientMsgId = 'opt_${DateTime.now().millisecondsSinceEpoch}';
    final optimisticMessage = domain.Message(
      id: clientMsgId,
      chatId: chatId,
      senderId: currentUserId,
      content: trimmed,
      createdAt: DateTime.now(),
      isRead: false,
      status: domain.MessageStatus.sending,
    );

    // 2. Save instantly to local DB (it will appear in UI via the watch query)
    await ref
        .read(appDatabaseProvider)
        .saveMessage(_domainToDbMessage(optimisticMessage));

    try {
      // 3. Send over socket with the optimistic ID for matching back
      ref
          .read(socketServiceProvider)
          .sendMessage(chatId, trimmed, clientMsgId: clientMsgId);
    } catch (e) {
      // On failure, we mark the message as error in DB
      final errorMessage = optimisticMessage.copyWith(
        status: domain.MessageStatus.error,
      );
      await ref
          .read(appDatabaseProvider)
          .saveMessage(_domainToDbMessage(errorMessage));

      state = state.copyWith(error: 'Failed to send message over socket');
    }
  }

  // Converters
  domain.Message _dbToDomainMessage(MessageData m) {
    return domain.Message(
      id: m.id,
      chatId: m.chatId,
      senderId: m.senderId,
      content: m.content,
      createdAt: m.createdAt,
      isRead: m.isRead,
      status: domain.MessageStatus.values.firstWhere(
        (e) => e.name == m.status,
        orElse: () => domain.MessageStatus.sent,
      ),
      type: m.type,
    );
  }

  MessageData _domainToDbMessage(domain.Message m) {
    return MessageData(
      id: m.id,
      chatId: m.chatId,
      senderId: m.senderId,
      content: m.content,
      createdAt: m.createdAt,
      isRead: m.isRead,
      status: m.status.name,
      type: m.type,
    );
  }
}
