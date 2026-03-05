import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:kora_chat/features/auth/domain/auth_state.dart';
import 'package:kora_chat/features/auth/domain/auth_models.dart';
import 'package:kora_chat/providers/api_providers.dart';
import 'package:kora_chat/services/token_service.dart';
import 'package:kora_chat/l10n/generated/translations.g.dart';

part 'auth_viewmodel.g.dart';

@Riverpod(keepAlive: true)
class AuthViewModel extends _$AuthViewModel {
  @override
  AuthState build() {
    Future.microtask(() => checkInitialAuth());
    return const AuthState();
  }

  bool _isValidEmail(String email) {
    return RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
    ).hasMatch(email);
  }

  Future<void> checkInitialAuth() async {
    final tokenService = ref.read(tokenServiceProvider);
    final hasToken = await tokenService.hasToken();

    if (!ref.mounted) return;

    if (hasToken) {
      try {
        final repository = ref.read(authRepositoryProvider);
        final user = await repository.getProfile();

        if (!ref.mounted) return;

        state = state.copyWith(
          isAuthenticated: true,
          isAppInitializing: false,
          currentUser: user,
        );
      } catch (e) {
        // If profile fetch fails (e.g. invalid/expired token), log out
        await logout();
      }
    } else {
      state = state.copyWith(isAppInitializing: false);
    }
  }

  void onEmailChanged(String email) {
    state = state.copyWith(email: email, error: null);
  }

  void onPasswordChanged(String password) {
    state = state.copyWith(password: password, error: null);
  }

  void onUsernameChanged(String username) {
    state = state.copyWith(username: username, error: null);
  }

  Future<void> login(Translations t) async {
    if (state.email.isEmpty) {
      state = state.copyWith(error: t.auth.emailRequired);
      return;
    }
    if (!_isValidEmail(state.email)) {
      state = state.copyWith(error: t.auth.invalidEmail);
      return;
    }
    if (state.password.isEmpty) {
      state = state.copyWith(error: t.auth.passwordRequired);
      return;
    }

    state = state.copyWith(isLoading: true, error: null);

    try {
      final repository = ref.read(authRepositoryProvider);
      final tokenService = ref.read(tokenServiceProvider);

      final request = LoginRequest(
        email: state.email,
        password: state.password,
      );

      final response = await repository.login(request);
      await tokenService.saveToken(response.accessToken);

      state = state.copyWith(
        isLoading: false,
        isAuthenticated: true,
        currentUser: response.user,
      );
    } on DioException catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.response?.data?['message'] ?? 'Login failed',
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'An unexpected error occurred',
      );
    }
  }

  Future<void> register(Translations t) async {
    if (state.username.isEmpty) {
      state = state.copyWith(error: "Le nom d'utilisateur est requis");
      return;
    }
    if (state.email.isEmpty) {
      state = state.copyWith(error: t.auth.emailRequired);
      return;
    }
    if (!_isValidEmail(state.email)) {
      state = state.copyWith(error: t.auth.invalidEmail);
      return;
    }
    if (state.password.isEmpty) {
      state = state.copyWith(error: t.auth.passwordRequired);
      return;
    }
    if (state.password.length < 12) {
      state = state.copyWith(
        error: "Le mot de passe doit faire au moins 12 caractères",
      );
      return;
    }
    if (!RegExp(r'[A-Z]').hasMatch(state.password)) {
      state = state.copyWith(
        error: "Le mot de passe doit contenir au moins une majuscule",
      );
      return;
    }
    if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(state.password)) {
      state = state.copyWith(
        error: "Le mot de passe doit contenir au moins un caractère spécial",
      );
      return;
    }

    state = state.copyWith(isLoading: true, error: null);

    try {
      final repository = ref.read(authRepositoryProvider);
      final tokenService = ref.read(tokenServiceProvider);

      final request = RegisterRequest(
        email: state.email,
        password: state.password,
        username: state.username,
      );

      final response = await repository.register(request);
      await tokenService.saveToken(response.accessToken);

      state = state.copyWith(
        isLoading: false,
        isAuthenticated: true,
        currentUser: response.user,
      );
    } on DioException catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.response?.data?['message'] ?? 'Registration failed',
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'An unexpected error occurred',
      );
    }
  }

  Future<void> logout() async {
    final tokenService = ref.read(tokenServiceProvider);
    await tokenService.deleteToken();
    state = const AuthState(isAppInitializing: false);
  }

  Future<void> uploadAvatar(XFile xFile) async {
    state = state.copyWith(isLoading: true);
    try {
      final repository = ref.read(authRepositoryProvider);
      final bytes = await xFile.readAsBytes();

      final multipartFile = MultipartFile.fromBytes(
        bytes,
        filename: xFile.name,
      );

      final response = await repository.uploadAvatar(multipartFile);
      final avatarUrl = response.avatarUrl;

      if (state.currentUser != null) {
        state = state.copyWith(
          isLoading: false,
          currentUser: state.currentUser!.copyWith(avatarUrl: avatarUrl),
        );
      } else {
        state = state.copyWith(isLoading: false);
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Chécher l\'image a échoué',
      );
    }
  }
}
