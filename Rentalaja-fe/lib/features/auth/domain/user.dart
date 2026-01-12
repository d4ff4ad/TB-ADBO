import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';
part 'user.g.dart';

enum UserRole { guest, member, admin }

@freezed
class User with _$User {
  const factory User({
    required int id,
    required String name,
    required String email,
    @JsonKey(name: 'phone_number') required String phoneNumber,
    @Default(UserRole.guest) UserRole role,
    @JsonKey(name: 'ktp_image_url') String? ktpUrl,
    String? address, // Added address field
    String? token, // Added token for authentication (Force Rebuild)
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
