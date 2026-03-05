import 'package:flutter/material.dart';
import 'package:kora_chat/theme/kora_design_system.dart';
import 'package:kora_chat/theme/kora_components.dart';
import 'package:kora_chat/l10n/generated/translations.g.dart';

class KoraErrorView extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback? onRetry;
  final IconData icon;

  const KoraErrorView({
    super.key,
    required this.title,
    required this.message,
    this.onRetry,
    this.icon = Icons.error_outline_rounded,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(KoraSpacing.xxl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(KoraSpacing.xl),
              decoration: BoxDecoration(
                color: KoraColors.error.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 64, color: KoraColors.error),
            ),
            const SizedBox(height: KoraSpacing.xl),
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: KoraSpacing.md),
            Text(
              message,
              style: const TextStyle(
                color: KoraColors.textSecondary,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: KoraSpacing.xxl),
              SizedBox(
                width: 200,
                child: KoraButton(
                  text: Translations.of(context).error.retry,
                  onTap: onRetry!,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
