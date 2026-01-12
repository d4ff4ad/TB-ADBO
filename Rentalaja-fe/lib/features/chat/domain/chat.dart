import 'package:freezed_annotation/freezed_annotation.dart';
import '../../auth/domain/user.dart';

part 'chat.freezed.dart';
part 'chat.g.dart';

@freezed
class Chat with _$Chat {
  const factory Chat({
    required int id,
    required User user, // The member in the chat
    @JsonKey(name: 'last_message') Message? lastMessage,
    @JsonKey(name: 'unread_count') @Default(0) int unreadCount,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
  }) = _Chat;

  factory Chat.fromJson(Map<String, dynamic> json) => _$ChatFromJson(json);
}

@freezed
class Message with _$Message {
  const factory Message({
    required int id,
    @JsonKey(name: 'chat_id') required int chatId,
    @JsonKey(name: 'sender_id') required int senderId,
    required String content,
    @JsonKey(name: 'is_read') @Default(false) @BoolIntConverter() bool isRead,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    User? sender, // Optional, if backend includes it
  }) = _Message;

  factory Message.fromJson(Map<String, dynamic> json) =>
      _$MessageFromJson(json);
}

class BoolIntConverter implements JsonConverter<bool, dynamic> {
  const BoolIntConverter();

  @override
  bool fromJson(dynamic json) {
    if (json is int) {
      return json == 1;
    } else if (json is bool) {
      return json;
    }
    return false; // Default fallback
  }

  @override
  int toJson(bool object) => object ? 1 : 0;
}
