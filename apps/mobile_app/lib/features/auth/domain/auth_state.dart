import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kora_chat/features/auth/domain/auth_models.dart';

part 'auth_state.freezed.dart';

@freezed
abstract class AuthState with _$AuthState {
  const factory AuthState({
    @Default('') String email,
    @Default('') String password,
    @Default('') String username,
    @Default(false) bool isLoading,
    @Default(true) bool isAppInitializing,
    @Default(null) String? error,
    @Default(false) bool isAuthenticated,
    UserProfile? currentUser,
  }) = _AuthState;
}
