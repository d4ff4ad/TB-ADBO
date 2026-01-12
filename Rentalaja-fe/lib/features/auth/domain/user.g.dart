// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserImpl _$$UserImplFromJson(Map<String, dynamic> json) => _$UserImpl(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  email: json['email'] as String,
  phoneNumber: json['phone_number'] as String,
  role: $enumDecodeNullable(_$UserRoleEnumMap, json['role']) ?? UserRole.guest,
  ktpUrl: json['ktp_image_url'] as String?,
  address: json['address'] as String?,
  token: json['token'] as String?,
);

Map<String, dynamic> _$$UserImplToJson(_$UserImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'phone_number': instance.phoneNumber,
      'role': _$UserRoleEnumMap[instance.role]!,
      'ktp_image_url': instance.ktpUrl,
      'address': instance.address,
      'token': instance.token,
    };

const _$UserRoleEnumMap = {
  UserRole.guest: 'guest',
  UserRole.member: 'member',
  UserRole.admin: 'admin',
};
