import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kora_chat/features/auth/domain/auth_models.dart';

part 'search_state.freezed.dart';

@freezed
abstract class SearchState with _$SearchState {
  const factory SearchState({
    @Default([]) List<UserProfile> users,
    @Default(false) bool isLoading,
    @Default({}) Set<String> selectedUserIds,
    @Default(false) bool isMultiSelectMode,
    String? error,
  }) = _SearchState;
}
