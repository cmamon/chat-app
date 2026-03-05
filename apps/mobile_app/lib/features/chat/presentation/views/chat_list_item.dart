import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kora_chat/features/auth/presentation/viewmodels/auth_viewmodel.dart';
import 'package:kora_chat/features/chat/domain/chat_models.dart';
import 'package:kora_chat/theme/kora_design_system.dart';
import 'package:kora_chat/theme/kora_components.dart';
import 'package:google_fonts/google_fonts.dart';

class ChatListItem extends ConsumerWidget {
  final Chat chat;
  final VoidCallback onTap;

  const ChatListItem({super.key, required this.chat, required this.onTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUserId = ref.watch(authViewModelProvider).currentUser?.id;

    // Determine the sender name/avatar for the chat
    // For 1-on-1 chats, it's the other person
    String chatName = chat.name ?? '';
    String? avatarUrl = chat.avatarUrl;

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

    final String lastMessage = chat.lastMessage?.content ?? 'No messages yet';
    final String time = chat.lastMessage != null
        ? '${chat.lastMessage!.createdAt.hour}:${chat.lastMessage!.createdAt.minute.toString().padLeft(2, '0')}'
        : '';

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: KoraSpacing.lg,
          vertical: KoraSpacing.md,
        ),
        child: Row(
          children: [
            KoraAvatar(imageUrl: avatarUrl, size: 56, placeholder: chatName),
            const SizedBox(width: KoraSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          chatName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.outfit(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: KoraColors.textPrimary,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        time,
                        style: GoogleFonts.outfit(
                          fontSize: 12,
                          color: KoraColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          lastMessage,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.outfit(
                            fontSize: 14,
                            color: KoraColors.textSecondary,
                          ),
                        ),
                      ),
                      if (chat.unreadCount > 0)
                        Container(
                          margin: const EdgeInsets.only(left: 8),
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(
                            color: KoraColors.primary,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            '${chat.unreadCount}',
                            style: const TextStyle(
                              fontSize: 10,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
