import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kora_chat/features/chat/presentation/viewmodels/search_viewmodel.dart';
import 'package:kora_chat/features/auth/domain/auth_models.dart';
import 'package:kora_chat/theme/kora_design_system.dart';
import 'package:kora_chat/theme/kora_components.dart';
import 'package:kora_chat/config/routes.dart';
import 'package:kora_chat/l10n/generated/translations.g.dart';

class UserSearchView extends ConsumerStatefulWidget {
  const UserSearchView({super.key});

  @override
  ConsumerState<UserSearchView> createState() => _UserSearchViewState();
}

class _UserSearchViewState extends ConsumerState<UserSearchView> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final searchState = ref.watch(searchViewModelProvider);
    final t = Translations.of(context);

    return Scaffold(
      backgroundColor: KoraColors.background,
      appBar: AppBar(
        leading: searchState.isMultiSelectMode
            ? IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => ref
                    .read(searchViewModelProvider.notifier)
                    .toggleMultiSelectMode(),
              )
            : null,
        title: Text(
          searchState.isMultiSelectMode ? t.chat.newGroup : t.chat.newMessage,
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: [
          if (!searchState.isMultiSelectMode)
            TextButton(
              onPressed: () => ref
                  .read(searchViewModelProvider.notifier)
                  .toggleMultiSelectMode(),
              child: Text(
                t
                    .chat
                    .createGroup, // Using creedGroupe from fr or generated key
                style: const TextStyle(color: KoraColors.primaryLight),
              ),
            ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              autofocus: true,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: t.chat.searchUsersPlaceholder,
                hintStyle: const TextStyle(color: KoraColors.textSecondary),
                prefixIcon: const Icon(
                  Icons.search,
                  color: KoraColors.primaryLight,
                ),
                filled: true,
                fillColor: KoraColors.surface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (value) {
                ref.read(searchViewModelProvider.notifier).search(value);
              },
            ),
          ),
          if (searchState.isLoading)
            const LinearProgressIndicator(color: KoraColors.primaryLight),
          Expanded(
            child: searchState.users.isEmpty
                ? _buildEmptyState(context, searchState.error)
                : _buildUserList(searchState.users),
          ),
        ],
      ),
      floatingActionButton:
          searchState.isMultiSelectMode &&
              searchState.selectedUserIds.isNotEmpty
          ? FloatingActionButton.extended(
              onPressed: () => _showGroupNameDialog(context),
              backgroundColor: KoraColors.primary,
              label: Text(t.chat.createGroup),
              icon: const Icon(Icons.check),
            )
          : null,
    );
  }

  Widget _buildEmptyState(BuildContext context, String? error) {
    if (error != null) {
      return Center(
        child: Text(error, style: const TextStyle(color: Colors.red)),
      );
    }
    final t = Translations.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.search, size: 64, color: KoraColors.surface),
          const SizedBox(height: 16),
          Text(
            t.chat.searchEmptyState,
            style: const TextStyle(color: KoraColors.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildUserList(List<UserProfile> users) {
    final searchState = ref.read(searchViewModelProvider);

    return ListView.builder(
      itemCount: users.length,
      itemBuilder: (context, index) {
        final user = users[index];
        final isSelected = searchState.selectedUserIds.contains(user.id);

        return ListTile(
          leading: _buildAvatar(user),
          title: Text(
            user.username,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(
            user.email,
            style: const TextStyle(color: KoraColors.textSecondary),
          ),
          trailing: searchState.isMultiSelectMode
              ? Checkbox(
                  value: isSelected,
                  activeColor: KoraColors.primaryLight,
                  onChanged: (_) {
                    ref
                        .read(searchViewModelProvider.notifier)
                        .toggleUserSelection(user.id);
                    setState(() {}); // Force local UI update for checkbox
                  },
                )
              : null,
          onTap: () async {
            if (searchState.isMultiSelectMode) {
              ref
                  .read(searchViewModelProvider.notifier)
                  .toggleUserSelection(user.id);
              setState(() {});
            } else {
              final chatId = await ref
                  .read(searchViewModelProvider.notifier)
                  .createDirectChat(user.id);
              if (chatId != null && context.mounted) {
                context.go(AppRoutes.chatPath(chatId));
              }
            }
          },
        );
      },
    );
  }

  Widget _buildAvatar(UserProfile user) {
    return KoraAvatar(
      imageUrl: user.avatarUrl,
      size: 40,
      placeholder: user.username,
    );
  }

  void _showGroupNameDialog(BuildContext context) {
    final t = Translations.of(context);
    final nameController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: KoraColors.surface,
        title: Text(
          t.chat.createGroup,
          style: const TextStyle(color: Colors.white),
        ),
        content: TextField(
          controller: nameController,
          autofocus: true,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: t.chat.groupName,
            hintStyle: const TextStyle(color: KoraColors.textSecondary),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              t.chat.cancel,
              style: const TextStyle(color: KoraColors.textSecondary),
            ),
          ),
          TextButton(
            onPressed: () async {
              final name = nameController.text.trim();
              if (name.isNotEmpty) {
                Navigator.pop(context);
                final chatId = await ref
                    .read(searchViewModelProvider.notifier)
                    .createGroupChat(name);
                if (chatId != null && context.mounted) {
                  context.go(AppRoutes.chatPath(chatId));
                }
              }
            },
            child: Text(
              t.chat.createGroup,
              style: const TextStyle(color: KoraColors.primaryLight),
            ),
          ),
        ],
      ),
    );
  }
}
