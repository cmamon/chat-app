import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kora_chat/features/auth/domain/auth_models.dart';

part 'chat_models.freezed.dart';
part 'chat_models.g.dart';

@freezed
abstract class Chat with _$Chat {
  const factory Chat({
    required String id,
    required List<UserProfile> participants,
    Message? lastMessage,
    @Default(0) int unreadCount,
    @Default(false) bool isGroup,
    String? name,
    String? avatarUrl,
  }) = _Chat;

  factory Chat.fromJson(Map<String, dynamic> json) => _$ChatFromJson(json);

  @override
  Map<String, dynamic> toJson();
}

enum MessageStatus { sending, sent, error }

@freezed
abstract class Message with _$Message {
  const Message._();

  const factory Message({
    required String id,
    required String chatId,
    required String senderId,
    required String content,
    required DateTime createdAt,
    @Default(false) bool isRead,
    @Default(MessageStatus.sent) MessageStatus status,
    String? type, // text, image, file, etc.
  }) = _Message;

  factory Message.fromJson(Map<String, dynamic> json) =>
      _$MessageFromJson(json);

  bool get isOptimistic =>
      id.startsWith('opt_') || status == MessageStatus.sending;

  @override
  Map<String, dynamic> toJson();
}
