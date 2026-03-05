import 'package:flutter/material.dart';
import 'package:kora_chat/theme/kora_design_system.dart';
import 'package:kora_chat/l10n/generated/translations.g.dart';

class HomeEmptyState extends StatelessWidget {
  const HomeEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.chat_bubble_outline_rounded,
            size: 80,
            color: KoraColors.surface,
          ),
          const SizedBox(height: KoraSpacing.xl),
          Text(
            t.home.welcomeToKora,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: KoraSpacing.sm),
          Text(
            t.home.secureSpaceReady,
            style: const TextStyle(color: KoraColors.textSecondary),
          ),
          const SizedBox(height: KoraSpacing.xxl),
        ],
      ),
    );
  }
}
