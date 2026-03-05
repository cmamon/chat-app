import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kora_chat/core/providers/error_provider.dart';
import 'package:kora_chat/core/exceptions/app_exception.dart';
import 'package:kora_chat/core/providers/connection_provider.dart';
import 'package:kora_chat/l10n/generated/translations.g.dart';
import 'package:kora_chat/theme/kora_design_system.dart';

class KoraErrorHandler extends ConsumerWidget {
  final Widget child;

  const KoraErrorHandler({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = Translations.of(context);

    // Listen to global errors
    ref.listen<AppException?>(globalErrorProvider, (previous, next) {
      if (next != null) {
        final message = next.getLocalizedMessage(t);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error_outline, color: Colors.white),
                const SizedBox(width: KoraSpacing.md),
                Expanded(
                  child: Text(
                    message,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
            backgroundColor: KoraColors.error,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(KoraSpacing.md),
            ),
            action: SnackBarAction(
              label: "OK",
              textColor: Colors.white,
              onPressed: () =>
                  ref.read(globalErrorProvider.notifier).clearError(),
            ),
          ),
        );

        // Auto-clear after showing
        Future.delayed(const Duration(seconds: 4), () {
          ref.read(globalErrorProvider.notifier).clearError();
        });
      }
    });

    // Optionnal: Listen to connectivity changes to show a "No Connection" bar
    ref.listen(isConnectedProvider, (previous, isConnected) {
      if (previous == true && isConnected == false) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(t.error.offlineMessage),
            backgroundColor: Colors.orange,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(days: 1), // Stay until connected back
          ),
        );
      } else if (previous == false && isConnected == true) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(t.error.connectionRestored),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    });

    return child;
  }
}
