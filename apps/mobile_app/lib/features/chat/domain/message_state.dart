import 'package:freezed_annotation/freezed_annotation.dart';
import 'chat_models.dart';

part 'message_state.freezed.dart';

@freezed
abstract class MessageState with _$MessageState {
  const factory MessageState({
    @Default([]) List<Message> messages,
    @Default(false) bool isLoading,
    @Default(false) bool isSending,
    String? error,
    Chat? currentChat,
  }) = _MessageState;
}
