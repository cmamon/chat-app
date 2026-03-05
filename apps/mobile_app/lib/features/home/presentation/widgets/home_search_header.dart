import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kora_chat/theme/kora_design_system.dart';
import 'package:kora_chat/l10n/generated/translations.g.dart';
import 'package:kora_chat/features/chat/presentation/viewmodels/chat_viewmodel.dart';

class HomeSearchHeader extends ConsumerWidget {
  const HomeSearchHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = Translations.of(context);
    return Padding(
      padding: const EdgeInsets.all(KoraSpacing.lg),
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: KoraColors.surface,
          borderRadius: BorderRadius.circular(KoraSpacing.md),
        ),
        child: TextField(
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: t.chat.searchConversations,
            hintStyle: const TextStyle(color: KoraColors.textMuted),
            prefixIcon: const Icon(Icons.search, color: KoraColors.textMuted),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 12),
          ),
          onChanged: (value) {
            ref.read(chatViewModelProvider.notifier).setSearchQuery(value);
          },
        ),
      ),
    );
  }
}
