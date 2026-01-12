// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'electronic_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ElectronicItemImpl _$$ElectronicItemImplFromJson(Map<String, dynamic> json) =>
    _$ElectronicItemImpl(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      description: json['description'] as String,
      pricePerDay: (json['pricePerDay'] as num).toDouble(),
      stock: (json['stock'] as num).toInt(),
      imageUrl: json['imageUrl'] as String,
      averageRating: (json['average_rating'] as num?)?.toDouble(),
      status:
          $enumDecodeNullable(_$ItemStatusEnumMap, json['status']) ??
          ItemStatus.available,
    );

Map<String, dynamic> _$$ElectronicItemImplToJson(
  _$ElectronicItemImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'description': instance.description,
  'pricePerDay': instance.pricePerDay,
  'stock': instance.stock,
  'imageUrl': instance.imageUrl,
  'average_rating': instance.averageRating,
  'status': _$ItemStatusEnumMap[instance.status]!,
};

const _$ItemStatusEnumMap = {
  ItemStatus.available: 'available',
  ItemStatus.maintenance: 'maintenance',
  ItemStatus.rented: 'rented',
};
