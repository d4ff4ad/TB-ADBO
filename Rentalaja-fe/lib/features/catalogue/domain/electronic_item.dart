import 'package:freezed_annotation/freezed_annotation.dart';

part 'electronic_item.freezed.dart';
part 'electronic_item.g.dart';

enum ItemStatus { available, maintenance, rented }

@freezed
class ElectronicItem with _$ElectronicItem {
  const factory ElectronicItem({
    required int id,
    required String name,
    required String description,
    required double pricePerDay,
    required int stock,
    required String imageUrl,
    @JsonKey(name: 'average_rating') double? averageRating,
    @Default(ItemStatus.available) ItemStatus status,
  }) = _ElectronicItem;

  factory ElectronicItem.fromJson(Map<String, dynamic> json) =>
      _$ElectronicItemFromJson(json);
}
