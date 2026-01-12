// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'electronic_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ElectronicItem _$ElectronicItemFromJson(Map<String, dynamic> json) {
  return _ElectronicItem.fromJson(json);
}

/// @nodoc
mixin _$ElectronicItem {
  int get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  double get pricePerDay => throw _privateConstructorUsedError;
  int get stock => throw _privateConstructorUsedError;
  String get imageUrl => throw _privateConstructorUsedError;
  @JsonKey(name: 'average_rating')
  double? get averageRating => throw _privateConstructorUsedError;
  ItemStatus get status => throw _privateConstructorUsedError;

  /// Serializes this ElectronicItem to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ElectronicItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ElectronicItemCopyWith<ElectronicItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ElectronicItemCopyWith<$Res> {
  factory $ElectronicItemCopyWith(
    ElectronicItem value,
    $Res Function(ElectronicItem) then,
  ) = _$ElectronicItemCopyWithImpl<$Res, ElectronicItem>;
  @useResult
  $Res call({
    int id,
    String name,
    String description,
    double pricePerDay,
    int stock,
    String imageUrl,
    @JsonKey(name: 'average_rating') double? averageRating,
    ItemStatus status,
  });
}

/// @nodoc
class _$ElectronicItemCopyWithImpl<$Res, $Val extends ElectronicItem>
    implements $ElectronicItemCopyWith<$Res> {
  _$ElectronicItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ElectronicItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = null,
    Object? pricePerDay = null,
    Object? stock = null,
    Object? imageUrl = null,
    Object? averageRating = freezed,
    Object? status = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            description: null == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String,
            pricePerDay: null == pricePerDay
                ? _value.pricePerDay
                : pricePerDay // ignore: cast_nullable_to_non_nullable
                      as double,
            stock: null == stock
                ? _value.stock
                : stock // ignore: cast_nullable_to_non_nullable
                      as int,
            imageUrl: null == imageUrl
                ? _value.imageUrl
                : imageUrl // ignore: cast_nullable_to_non_nullable
                      as String,
            averageRating: freezed == averageRating
                ? _value.averageRating
                : averageRating // ignore: cast_nullable_to_non_nullable
                      as double?,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as ItemStatus,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ElectronicItemImplCopyWith<$Res>
    implements $ElectronicItemCopyWith<$Res> {
  factory _$$ElectronicItemImplCopyWith(
    _$ElectronicItemImpl value,
    $Res Function(_$ElectronicItemImpl) then,
  ) = __$$ElectronicItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int id,
    String name,
    String description,
    double pricePerDay,
    int stock,
    String imageUrl,
    @JsonKey(name: 'average_rating') double? averageRating,
    ItemStatus status,
  });
}

/// @nodoc
class __$$ElectronicItemImplCopyWithImpl<$Res>
    extends _$ElectronicItemCopyWithImpl<$Res, _$ElectronicItemImpl>
    implements _$$ElectronicItemImplCopyWith<$Res> {
  __$$ElectronicItemImplCopyWithImpl(
    _$ElectronicItemImpl _value,
    $Res Function(_$ElectronicItemImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ElectronicItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = null,
    Object? pricePerDay = null,
    Object? stock = null,
    Object? imageUrl = null,
    Object? averageRating = freezed,
    Object? status = null,
  }) {
    return _then(
      _$ElectronicItemImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        description: null == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String,
        pricePerDay: null == pricePerDay
            ? _value.pricePerDay
            : pricePerDay // ignore: cast_nullable_to_non_nullable
                  as double,
        stock: null == stock
            ? _value.stock
            : stock // ignore: cast_nullable_to_non_nullable
                  as int,
        imageUrl: null == imageUrl
            ? _value.imageUrl
            : imageUrl // ignore: cast_nullable_to_non_nullable
                  as String,
        averageRating: freezed == averageRating
            ? _value.averageRating
            : averageRating // ignore: cast_nullable_to_non_nullable
                  as double?,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as ItemStatus,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ElectronicItemImpl implements _ElectronicItem {
  const _$ElectronicItemImpl({
    required this.id,
    required this.name,
    required this.description,
    required this.pricePerDay,
    required this.stock,
    required this.imageUrl,
    @JsonKey(name: 'average_rating') this.averageRating,
    this.status = ItemStatus.available,
  });

  factory _$ElectronicItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$ElectronicItemImplFromJson(json);

  @override
  final int id;
  @override
  final String name;
  @override
  final String description;
  @override
  final double pricePerDay;
  @override
  final int stock;
  @override
  final String imageUrl;
  @override
  @JsonKey(name: 'average_rating')
  final double? averageRating;
  @override
  @JsonKey()
  final ItemStatus status;

  @override
  String toString() {
    return 'ElectronicItem(id: $id, name: $name, description: $description, pricePerDay: $pricePerDay, stock: $stock, imageUrl: $imageUrl, averageRating: $averageRating, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ElectronicItemImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.pricePerDay, pricePerDay) ||
                other.pricePerDay == pricePerDay) &&
            (identical(other.stock, stock) || other.stock == stock) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.averageRating, averageRating) ||
                other.averageRating == averageRating) &&
            (identical(other.status, status) || other.status == status));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    name,
    description,
    pricePerDay,
    stock,
    imageUrl,
    averageRating,
    status,
  );

  /// Create a copy of ElectronicItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ElectronicItemImplCopyWith<_$ElectronicItemImpl> get copyWith =>
      __$$ElectronicItemImplCopyWithImpl<_$ElectronicItemImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ElectronicItemImplToJson(this);
  }
}

abstract class _ElectronicItem implements ElectronicItem {
  const factory _ElectronicItem({
    required final int id,
    required final String name,
    required final String description,
    required final double pricePerDay,
    required final int stock,
    required final String imageUrl,
    @JsonKey(name: 'average_rating') final double? averageRating,
    final ItemStatus status,
  }) = _$ElectronicItemImpl;

  factory _ElectronicItem.fromJson(Map<String, dynamic> json) =
      _$ElectronicItemImpl.fromJson;

  @override
  int get id;
  @override
  String get name;
  @override
  String get description;
  @override
  double get pricePerDay;
  @override
  int get stock;
  @override
  String get imageUrl;
  @override
  @JsonKey(name: 'average_rating')
  double? get averageRating;
  @override
  ItemStatus get status;

  /// Create a copy of ElectronicItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ElectronicItemImplCopyWith<_$ElectronicItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
