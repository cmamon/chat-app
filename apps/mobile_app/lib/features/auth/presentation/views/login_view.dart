import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kora_chat/l10n/generated/translations.g.dart';
import 'package:kora_chat/theme/kora_design_system.dart';
import 'package:kora_chat/theme/kora_components.dart';
import 'package:kora_chat/features/auth/presentation/viewmodels/auth_viewmodel.dart';
import 'package:kora_chat/features/auth/presentation/widgets/auth_header.dart';
import 'package:kora_chat/features/auth/presentation/widgets/auth_view_layout.dart';
import 'package:kora_chat/config/routes.dart';
import 'package:go_router/go_router.dart';

class LoginView extends ConsumerWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(authViewModelProvider);
    final viewModel = ref.read(authViewModelProvider.notifier);
    final t = Translations.of(context);

    return AuthViewLayout(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: IconButton(
            onPressed: () => context.pop(),
            icon: const Icon(Icons.arrow_back, color: Colors.white),
          ),
        ),
        const SizedBox(height: KoraSpacing.lg),
        AuthHeader(title: t.auth.welcomeBack, subtitle: t.auth.signInToAccount),
        const SizedBox(height: KoraSpacing.xxl),
        KoraTextField(
          key: const Key('login_email_field'),
          label: t.auth.emailLabel,
          hintText: t.auth.emailHint,
          prefixIcon: const Icon(
            Icons.email_outlined,
            color: KoraColors.textMuted,
          ),
          keyboardType: TextInputType.emailAddress,
          onChanged: (value) => viewModel.onEmailChanged(value),
        ),
        const SizedBox(height: KoraSpacing.lg),
        KoraTextField(
          key: const Key('login_password_field'),
          label: t.auth.passwordLabel,
          hintText: t.auth.passwordHint,
          isPassword: true,
          prefixIcon: const Icon(
            Icons.lock_outline,
            color: KoraColors.textMuted,
          ),
          onChanged: (value) => viewModel.onPasswordChanged(value),
        ),
        if (state.error != null) ...[
          const SizedBox(height: KoraSpacing.md),
          Text(
            state.error!,
            style: const TextStyle(color: KoraColors.error, fontSize: 14),
          ),
        ],
        const SizedBox(height: KoraSpacing.xl),
        KoraButton(
          key: const Key('login_submit_button'),
          text: t.auth.signIn,
          isLoading: state.isLoading,
          onTap: () => viewModel.login(t),
        ),
        const SizedBox(height: KoraSpacing.lg),
        TextButton(
          onPressed: () => context.push(AppRoutes.register.path),
          child: Text(
            t.auth.createNewAccount,
            style: const TextStyle(color: KoraColors.primaryLight),
          ),
        ),
        TextButton(
          onPressed: () {},
          child: Text(
            t.auth.forgotPassword,
            style: const TextStyle(color: KoraColors.textMuted, fontSize: 12),
          ),
        ),
      ],
    );
  }
}
