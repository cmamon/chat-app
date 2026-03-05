import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:kora_chat/features/chat/domain/chat_models.dart';
import 'package:kora_chat/theme/kora_design_system.dart';
import 'package:kora_chat/config/app_config.dart';

class ChatMessageBubble extends StatelessWidget {
  final Message message;
  final bool isMe;

  const ChatMessageBubble({
    super.key,
    required this.message,
    required this.isMe,
  });

  @override
  Widget build(BuildContext context) {
    final isImage = message.type == 'image';

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: KoraSpacing.md),
        padding: isImage
            ? EdgeInsets.zero
            : const EdgeInsets.all(KoraSpacing.md),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        decoration: BoxDecoration(
          color: isMe ? KoraColors.primary : KoraColors.surface,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(isMe ? 16 : 0),
            bottomRight: Radius.circular(isMe ? 0 : 16),
          ),
        ),
        child: Opacity(
          opacity: message.status == MessageStatus.sending ? 0.7 : 1.0,
          child: ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(16),
              topRight: const Radius.circular(16),
              bottomLeft: Radius.circular(isMe ? 16 : 0),
              bottomRight: Radius.circular(isMe ? 0 : 16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (isImage)
                  _buildImageMessage(message.content)
                else
                  Padding(
                    padding: const EdgeInsets.all(KoraSpacing.md),
                    child: Text(
                      message.content,
                      style: TextStyle(
                        color: isMe ? Colors.white : KoraColors.textPrimary,
                        fontSize: 15,
                      ),
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.only(right: 8, bottom: 4),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '${message.createdAt.hour}:${message.createdAt.minute.toString().padLeft(2, '0')}',
                        style: TextStyle(
                          color: isMe ? Colors.white70 : KoraColors.textMuted,
                          fontSize: 10,
                        ),
                      ),
                      const SizedBox(width: 4),
                      if (message.status == MessageStatus.sending)
                        const Icon(
                          Icons.access_time,
                          size: 10,
                          color: Colors.white70,
                        )
                      else if (message.status == MessageStatus.error)
                        const Icon(
                          Icons.error_outline,
                          size: 10,
                          color: Colors.redAccent,
                        )
                      else if (isMe)
                        const Icon(
                          Icons.check,
                          size: 10,
                          color: Colors.white70,
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImageMessage(String url) {
    final fullUrl = url.startsWith('/') ? '${AppConfig.apiBaseUrl}$url' : url;

    return CachedNetworkImage(
      imageUrl: fullUrl,
      fit: BoxFit.cover,
      placeholder: (context, url) => Container(
        height: 200,
        color: KoraColors.surface,
        child: const Center(child: CircularProgressIndicator()),
      ),
      errorWidget: (context, url, error) => const Icon(Icons.error),
    );
  }
}
