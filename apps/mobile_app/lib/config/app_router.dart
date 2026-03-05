import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:kora_chat/main.dart';
import 'package:kora_chat/features/auth/presentation/views/login_view.dart';
import 'package:kora_chat/features/auth/presentation/views/register_view.dart';
import 'package:kora_chat/features/home/presentation/views/home_view.dart';
import 'package:kora_chat/features/chat/presentation/views/chat_detail_view.dart';
import 'package:kora_chat/features/auth/presentation/viewmodels/auth_viewmodel.dart';
import 'package:kora_chat/config/routes.dart';

import 'package:kora_chat/features/auth/presentation/views/profile_view.dart';
import 'package:kora_chat/features/chat/presentation/views/user_search_view.dart';
import 'package:kora_chat/core/widgets/main_shell_view.dart';
import 'package:kora_chat/theme/kora_design_system.dart';

part 'app_router.g.dart';

@riverpod
GoRouter router(Ref ref) {
  return GoRouter(
    initialLocation: AppRoutes.landing.path,
    refreshListenable: AuthRefreshListenable(ref),

    redirect: (context, state) {
      final authState = ref.read(authViewModelProvider);
      final isLoggingIn = state.matchedLocation == AppRoutes.login.path;
      final isRegistering = state.matchedLocation == AppRoutes.register.path;
      final isAtLanding = state.matchedLocation == AppRoutes.landing.path;

      if (authState.isAppInitializing) return null;

      if (!authState.isAuthenticated) {
        if (!isLoggingIn && !isRegistering && !isAtLanding) {
          return AppRoutes.landing.path;
        }
        return null;
      }

      if (isLoggingIn || isRegistering || isAtLanding) {
        return AppRoutes.home.path;
      }

      return null;
    },

    routes: [
      GoRoute(
        path: AppRoutes.landing.path,
        name: AppRoutes.landing.name,
        builder: (context, state) => const LandingPage(),
      ),
      GoRoute(
        path: AppRoutes.login.path,
        name: AppRoutes.login.name,
        builder: (context, state) => const LoginView(),
      ),
      GoRoute(
        path: AppRoutes.register.path,
        name: AppRoutes.register.name,
        builder: (context, state) => const RegisterView(),
      ),
      ShellRoute(
        builder: (context, state, child) => MainShellView(child: child),
        routes: [
          GoRoute(
            path: AppRoutes.home.path,
            name: AppRoutes.home.name,
            builder: (context, state) {
              // Check for wide screen using MediaQuery to match Shell's detection
              final isWide = MediaQuery.of(context).size.width > 900;

              if (isWide) {
                return const Scaffold(
                  backgroundColor: KoraColors.background,
                  body: Center(
                    child: Text(
                      'Select a chat to start messaging',
                      style: TextStyle(color: KoraColors.textSecondary),
                    ),
                  ),
                );
              }
              return const HomeView();
            },
          ),
          GoRoute(
            path: AppRoutes.profile.path,
            name: AppRoutes.profile.name,
            builder: (context, state) => const ProfileView(),
          ),
          GoRoute(
            path: AppRoutes.search.path,
            name: AppRoutes.search.name,
            builder: (context, state) => const UserSearchView(),
          ),
          GoRoute(
            path: AppRoutes.chat.path,
            name: AppRoutes.chat.name,
            builder: (context, state) {
              final chatId = state.pathParameters['id']!;
              return ChatDetailView(chatId: chatId);
            },
          ),
        ],
      ),
    ],
  );
}

class AuthRefreshListenable extends ChangeNotifier {
  AuthRefreshListenable(Ref ref) {
    ref.listen(authViewModelProvider, (_, _) {
      notifyListeners();
    });
  }
}
