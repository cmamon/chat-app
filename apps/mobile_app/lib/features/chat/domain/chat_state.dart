import 'package:freezed_annotation/freezed_annotation.dart';
import 'chat_models.dart';

part 'chat_state.freezed.dart';

@freezed
abstract class ChatState with _$ChatState {
  const factory ChatState({
    @Default([]) List<Chat> chats,
    @Default(false) bool isLoading,
    @Default('') String searchQuery,
    String? error,
  }) = _ChatState;
}
