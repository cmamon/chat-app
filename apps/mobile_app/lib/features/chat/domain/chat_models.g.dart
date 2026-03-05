// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Chat _$ChatFromJson(Map<String, dynamic> json) => _Chat(
  id: json['id'] as String,
  participants: (json['participants'] as List<dynamic>)
      .map((e) => UserProfile.fromJson(e as Map<String, dynamic>))
      .toList(),
  lastMessage: json['lastMessage'] == null
      ? null
      : Message.fromJson(json['lastMessage'] as Map<String, dynamic>),
  unreadCount: (json['unreadCount'] as num?)?.toInt() ?? 0,
  isGroup: json['isGroup'] as bool? ?? false,
  name: json['name'] as String?,
  avatarUrl: json['avatarUrl'] as String?,
);

Map<String, dynamic> _$ChatToJson(_Chat instance) => <String, dynamic>{
  'id': instance.id,
  'participants': instance.participants,
  'lastMessage': instance.lastMessage,
  'unreadCount': instance.unreadCount,
  'isGroup': instance.isGroup,
  'name': instance.name,
  'avatarUrl': instance.avatarUrl,
};

_Message _$MessageFromJson(Map<String, dynamic> json) => _Message(
  id: json['id'] as String,
  chatId: json['chatId'] as String,
  senderId: json['senderId'] as String,
  content: json['content'] as String,
  createdAt: DateTime.parse(json['createdAt'] as String),
  isRead: json['isRead'] as bool? ?? false,
  status:
      $enumDecodeNullable(_$MessageStatusEnumMap, json['status']) ??
      MessageStatus.sent,
  type: json['type'] as String?,
);

Map<String, dynamic> _$MessageToJson(_Message instance) => <String, dynamic>{
  'id': instance.id,
  'chatId': instance.chatId,
  'senderId': instance.senderId,
  'content': instance.content,
  'createdAt': instance.createdAt.toIso8601String(),
  'isRead': instance.isRead,
  'status': _$MessageStatusEnumMap[instance.status]!,
  'type': instance.type,
};

const _$MessageStatusEnumMap = {
  MessageStatus.sending: 'sending',
  MessageStatus.sent: 'sent',
  MessageStatus.error: 'error',
};
