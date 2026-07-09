import 'package:freezed_annotation/freezed_annotation.dart';
import 'enums.dart';

part 'chat_models.freezed.dart';
part 'chat_models.g.dart';

@freezed
abstract class ChatConversation with _$ChatConversation {
  const factory ChatConversation({
    required String id,
    required String otherUserId,
    required String otherUserName,
    String? otherUserAvatar,
    @Default(false) bool isOnline,
    required String lastMessage,
    required DateTime lastMessageTime,
    @Default(0) int unreadCount,
    @Default(false) bool isAgent,
  }) = _ChatConversation;

  factory ChatConversation.fromJson(Map<String, dynamic> json) => _$ChatConversationFromJson(json);
}

@freezed
abstract class ChatMessage with _$ChatMessage {
  const factory ChatMessage({
    required String id,
    required String senderId,
    required String content,
    required DateTime timestamp,
    required MessageType type,
    @Default(false) bool isRead,
    String? imageUrl,
  }) = _ChatMessage;

  factory ChatMessage.fromJson(Map<String, dynamic> json) => _$ChatMessageFromJson(json);
}
