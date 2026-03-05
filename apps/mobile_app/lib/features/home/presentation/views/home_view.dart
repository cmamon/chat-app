import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kora_chat/l10n/generated/translations.g.dart';
import 'package:kora_chat/theme/kora_design_system.dart';
import 'package:kora_chat/features/auth/presentation/viewmodels/auth_viewmodel.dart';
import 'package:kora_chat/features/chat/presentation/viewmodels/chat_viewmodel.dart';
import 'package:kora_chat/features/chat/presentation/views/chat_list_item.dart';
import 'package:kora_chat/features/home/presentation/widgets/home_search_header.dart';
import 'package:kora_chat/features/home/presentation/widgets/home_empty_state.dart';
import 'package:kora_chat/features/chat/data/chat_sync_service.dart';
import 'package:kora_chat/config/routes.dart';
import 'package:go_router/go_router.dart';

class HomeView extends ConsumerWidget {
  final bool isEmbedded;
  const HomeView({super.key, this.isEmbedded = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chatState = ref.watch(chatViewModelProvider);
    final filteredChats = ref.watch(filteredChatsProvider);
    final t = Translations.of(context);

    final content = Column(
      children: [
        const HomeSearchHeader(),
        Expanded(
          child: chatState.isLoading && chatState.chats.isEmpty
              ? const Center(
                  child: CircularProgressIndicator(
                    color: KoraColors.primaryLight,
                  ),
                )
              : filteredChats.isEmpty
              ? const HomeEmptyState()
              : _buildChatList(context, ref, filteredChats),
        ),
      ],
    );

    if (isEmbedded) return content;

    return Scaffold(
      backgroundColor: KoraColors.background,
      appBar: AppBar(
        title: Text(
          t.home.homeTitle,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.person_outline),
          onPressed: () => context.push(AppRoutes.profile.path),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_outlined),
            onPressed: () => ref.read(authViewModelProvider.notifier).logout(),
          ),
        ],
      ),
      body: content,
      floatingActionButton: isEmbedded
          ? null
          : FloatingActionButton(
              onPressed: () => context.pushNamed(AppRoutes.search.name),
              backgroundColor: KoraColors.primary,
              tooltip: t.chat.newMessage,
              child: const Icon(Icons.add_comment_rounded, color: Colors.white),
            ),
    );
  }

  Widget _buildChatList(BuildContext context, WidgetRef ref, List chats) {
    return RefreshIndicator(
      color: KoraColors.primaryLight,
      onRefresh: () => ref.read(chatSyncServiceProvider.notifier).syncChats(),
      child: ListView.separated(
        itemCount: chats.length,
        separatorBuilder: (context, index) =>
            const Divider(color: KoraColors.surface, height: 1, indent: 80),
        itemBuilder: (context, index) {
          final chat = chats[index];
          return ChatListItem(
            chat: chat,
            onTap: () => context.go(AppRoutes.chatPath(chat.id)),
          );
        },
      ),
    );
  }
}
