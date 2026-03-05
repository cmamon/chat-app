import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kora_chat/theme/kora_design_system.dart';
import 'package:kora_chat/features/chat/presentation/viewmodels/message_viewmodel.dart';
import 'package:kora_chat/features/auth/presentation/viewmodels/auth_viewmodel.dart';
import 'package:kora_chat/features/chat/presentation/widgets/chat_message_bubble.dart';
import 'package:kora_chat/features/chat/presentation/widgets/chat_message_input.dart';
import 'package:kora_chat/features/chat/presentation/widgets/chat_app_bar_title.dart';
import 'package:kora_chat/l10n/generated/translations.g.dart';

class ChatDetailView extends ConsumerStatefulWidget {
  final String chatId;

  const ChatDetailView({super.key, required this.chatId});

  @override
  ConsumerState<ChatDetailView> createState() => _ChatDetailViewState();
}

class _ChatDetailViewState extends ConsumerState<ChatDetailView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(messageViewModelProvider(widget.chatId));
    final viewModel = ref.read(
      messageViewModelProvider(widget.chatId).notifier,
    );
    final t = Translations.of(context);

    // Scroll to bottom when new messages arrives
    ref.listen(messageViewModelProvider(widget.chatId), (previous, next) {
      if (previous?.messages.length != next.messages.length) {
        WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
      }
    });

    final currentUserId = ref.watch(authViewModelProvider).currentUser?.id;
    final chat = state.currentChat;

    String chatName = 'Chat';
    String? avatarUrl;

    if (chat != null) {
      chatName = chat.name ?? '';
      avatarUrl = chat.avatarUrl;

      if (chatName.isEmpty) {
        try {
          final otherParticipant = chat.participants.firstWhere(
            (p) => p.id != currentUserId,
            orElse: () => chat.participants.first,
          );
          chatName = otherParticipant.username;
          avatarUrl ??= otherParticipant.avatarUrl;
        } catch (e) {
          chatName = 'Chat';
        }
      }
    }

    return Scaffold(
      backgroundColor: KoraColors.background,
      appBar: AppBar(
        title: ChatAppBarTitle(
          name: chatName,
          status: t.chat.onlineStatus,
          avatarUrl: avatarUrl,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.videocam_outlined),
            onPressed: () {},
          ),
          IconButton(icon: const Icon(Icons.info_outline), onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: state.isLoading && state.messages.isEmpty
                ? const Center(
                    child: CircularProgressIndicator(
                      color: KoraColors.primaryLight,
                    ),
                  )
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(KoraSpacing.lg),
                    itemCount: state.messages.length,
                    itemBuilder: (context, index) {
                      final message = state.messages[index];
                      final currentUserId = ref
                          .watch(authViewModelProvider)
                          .currentUser
                          ?.id;
                      return ChatMessageBubble(
                        message: message,
                        isMe: message.senderId == currentUserId,
                      );
                    },
                  ),
          ),
          ChatMessageInput(
            isSending: state.isSending,
            onSend: (text) => viewModel.sendMessage(text),
          ),
        ],
      ),
    );
  }
}
