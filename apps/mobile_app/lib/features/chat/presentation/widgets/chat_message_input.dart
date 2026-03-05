import 'package:flutter/material.dart';
import 'package:kora_chat/theme/kora_design_system.dart';
import 'package:kora_chat/l10n/generated/translations.g.dart';

class ChatMessageInput extends StatefulWidget {
  final Function(String) onSend;
  final bool isSending;

  const ChatMessageInput({
    super.key,
    required this.onSend,
    required this.isSending,
  });

  @override
  State<ChatMessageInput> createState() => _ChatMessageInputState();
}

class _ChatMessageInputState extends State<ChatMessageInput> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleSend() {
    if (_controller.text.trim().isNotEmpty) {
      widget.onSend(_controller.text.trim());
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);

    return Container(
      padding: const EdgeInsets.all(KoraSpacing.md),
      decoration: const BoxDecoration(
        color: KoraColors.surface,
        border: Border(top: BorderSide(color: Colors.white10)),
      ),
      child: SafeArea(
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.add, color: KoraColors.primaryLight),
              onPressed: () {},
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: KoraSpacing.md),
                decoration: BoxDecoration(
                  color: KoraColors.background,
                  borderRadius: BorderRadius.circular(KoraSpacing.xl),
                ),
                child: TextField(
                  key: const Key('chat_message_textfield'),
                  controller: _controller,
                  decoration: InputDecoration(
                    hintText: t.chat.typeMessage,
                    border: InputBorder.none,
                  ),
                  maxLines: null,
                  onSubmitted: (_) => _handleSend(),
                ),
              ),
            ),
            const SizedBox(width: KoraSpacing.sm),
            IconButton(
              key: const Key('chat_send_button'),
              icon: Icon(
                widget.isSending ? Icons.hourglass_empty : Icons.send_rounded,
                color: KoraColors.primary,
              ),
              onPressed: widget.isSending ? null : _handleSend,
            ),
          ],
        ),
      ),
    );
  }
}
