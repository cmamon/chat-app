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

class RegisterView extends ConsumerWidget {
  const RegisterView({super.key});

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
        AuthHeader(
          title: t.auth.createNewAccount,
          subtitle: t.auth.joinKoraToday,
        ),
        const SizedBox(height: KoraSpacing.xxl),
        KoraTextField(
          label: t.auth.usernameLabel,
          hintText: t.auth.usernameHint,
          prefixIcon: const Icon(
            Icons.person_outline,
            color: KoraColors.textMuted,
          ),
          onChanged: (value) => viewModel.onUsernameChanged(value),
        ),
        const SizedBox(height: KoraSpacing.lg),
        KoraTextField(
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
          text: t.auth.signUp,
          isLoading: state.isLoading,
          onTap: () => viewModel.register(t),
        ),
        const SizedBox(height: KoraSpacing.lg),
        TextButton(
          onPressed: () => context.go(AppRoutes.login.path),
          child: Text(
            t.auth.backToLogin,
            style: const TextStyle(color: KoraColors.primaryLight),
          ),
        ),
      ],
    );
  }
}
