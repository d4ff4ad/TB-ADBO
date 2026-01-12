// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transaction.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Transaction _$TransactionFromJson(Map<String, dynamic> json) {
  return _Transaction.fromJson(json);
}

/// @nodoc
mixin _$Transaction {
  int get id => throw _privateConstructorUsedError;
  int get userId => throw _privateConstructorUsedError;
  int get itemId => throw _privateConstructorUsedError;
  DateTime get startDate => throw _privateConstructorUsedError;
  DateTime get endDate => throw _privateConstructorUsedError;
  double get totalPrice => throw _privateConstructorUsedError;
  double get dpAmount => throw _privateConstructorUsedError;
  TransactionStatus get status => throw _privateConstructorUsedError;
  DateTime? get actualReturnDate => throw _privateConstructorUsedError;
  double get fineAmount => throw _privateConstructorUsedError;
  String? get damageNote => throw _privateConstructorUsedError;

  /// Serializes this Transaction to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Transaction
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TransactionCopyWith<Transaction> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TransactionCopyWith<$Res> {
  factory $TransactionCopyWith(
    Transaction value,
    $Res Function(Transaction) then,
  ) = _$TransactionCopyWithImpl<$Res, Transaction>;
  @useResult
  $Res call({
    int id,
    int userId,
    int itemId,
    DateTime startDate,
    DateTime endDate,
    double totalPrice,
    double dpAmount,
    TransactionStatus status,
    DateTime? actualReturnDate,
    double fineAmount,
    String? damageNote,
  });
}

/// @nodoc
class _$TransactionCopyWithImpl<$Res, $Val extends Transaction>
    implements $TransactionCopyWith<$Res> {
  _$TransactionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Transaction
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? itemId = null,
    Object? startDate = null,
    Object? endDate = null,
    Object? totalPrice = null,
    Object? dpAmount = null,
    Object? status = null,
    Object? actualReturnDate = freezed,
    Object? fineAmount = null,
    Object? damageNote = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int,
            userId: null == userId
                ? _value.userId
                : userId // ignore: cast_nullable_to_non_nullable
                      as int,
            itemId: null == itemId
                ? _value.itemId
                : itemId // ignore: cast_nullable_to_non_nullable
                      as int,
            startDate: null == startDate
                ? _value.startDate
                : startDate // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            endDate: null == endDate
                ? _value.endDate
                : endDate // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            totalPrice: null == totalPrice
                ? _value.totalPrice
                : totalPrice // ignore: cast_nullable_to_non_nullable
                      as double,
            dpAmount: null == dpAmount
                ? _value.dpAmount
                : dpAmount // ignore: cast_nullable_to_non_nullable
                      as double,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as TransactionStatus,
            actualReturnDate: freezed == actualReturnDate
                ? _value.actualReturnDate
                : actualReturnDate // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            fineAmount: null == fineAmount
                ? _value.fineAmount
                : fineAmount // ignore: cast_nullable_to_non_nullable
                      as double,
            damageNote: freezed == damageNote
                ? _value.damageNote
                : damageNote // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TransactionImplCopyWith<$Res>
    implements $TransactionCopyWith<$Res> {
  factory _$$TransactionImplCopyWith(
    _$TransactionImpl value,
    $Res Function(_$TransactionImpl) then,
  ) = __$$TransactionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int id,
    int userId,
    int itemId,
    DateTime startDate,
    DateTime endDate,
    double totalPrice,
    double dpAmount,
    TransactionStatus status,
    DateTime? actualReturnDate,
    double fineAmount,
    String? damageNote,
  });
}

/// @nodoc
class __$$TransactionImplCopyWithImpl<$Res>
    extends _$TransactionCopyWithImpl<$Res, _$TransactionImpl>
    implements _$$TransactionImplCopyWith<$Res> {
  __$$TransactionImplCopyWithImpl(
    _$TransactionImpl _value,
    $Res Function(_$TransactionImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Transaction
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? itemId = null,
    Object? startDate = null,
    Object? endDate = null,
    Object? totalPrice = null,
    Object? dpAmount = null,
    Object? status = null,
    Object? actualReturnDate = freezed,
    Object? fineAmount = null,
    Object? damageNote = freezed,
  }) {
    return _then(
      _$TransactionImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        userId: null == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as int,
        itemId: null == itemId
            ? _value.itemId
            : itemId // ignore: cast_nullable_to_non_nullable
                  as int,
        startDate: null == startDate
            ? _value.startDate
            : startDate // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        endDate: null == endDate
            ? _value.endDate
            : endDate // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        totalPrice: null == totalPrice
            ? _value.totalPrice
            : totalPrice // ignore: cast_nullable_to_non_nullable
                  as double,
        dpAmount: null == dpAmount
            ? _value.dpAmount
            : dpAmount // ignore: cast_nullable_to_non_nullable
                  as double,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as TransactionStatus,
        actualReturnDate: freezed == actualReturnDate
            ? _value.actualReturnDate
            : actualReturnDate // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        fineAmount: null == fineAmount
            ? _value.fineAmount
            : fineAmount // ignore: cast_nullable_to_non_nullable
                  as double,
        damageNote: freezed == damageNote
            ? _value.damageNote
            : damageNote // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TransactionImpl implements _Transaction {
  const _$TransactionImpl({
    required this.id,
    required this.userId,
    required this.itemId,
    required this.startDate,
    required this.endDate,
    required this.totalPrice,
    required this.dpAmount,
    this.status = TransactionStatus.pending,
    this.actualReturnDate,
    this.fineAmount = 0,
    this.damageNote,
  });

  factory _$TransactionImpl.fromJson(Map<String, dynamic> json) =>
      _$$TransactionImplFromJson(json);

  @override
  final int id;
  @override
  final int userId;
  @override
  final int itemId;
  @override
  final DateTime startDate;
  @override
  final DateTime endDate;
  @override
  final double totalPrice;
  @override
  final double dpAmount;
  @override
  @JsonKey()
  final TransactionStatus status;
  @override
  final DateTime? actualReturnDate;
  @override
  @JsonKey()
  final double fineAmount;
  @override
  final String? damageNote;

  @override
  String toString() {
    return 'Transaction(id: $id, userId: $userId, itemId: $itemId, startDate: $startDate, endDate: $endDate, totalPrice: $totalPrice, dpAmount: $dpAmount, status: $status, actualReturnDate: $actualReturnDate, fineAmount: $fineAmount, damageNote: $damageNote)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TransactionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.itemId, itemId) || other.itemId == itemId) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
            (identical(other.totalPrice, totalPrice) ||
                other.totalPrice == totalPrice) &&
            (identical(other.dpAmount, dpAmount) ||
                other.dpAmount == dpAmount) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.actualReturnDate, actualReturnDate) ||
                other.actualReturnDate == actualReturnDate) &&
            (identical(other.fineAmount, fineAmount) ||
                other.fineAmount == fineAmount) &&
            (identical(other.damageNote, damageNote) ||
                other.damageNote == damageNote));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    userId,
    itemId,
    startDate,
    endDate,
    totalPrice,
    dpAmount,
    status,
    actualReturnDate,
    fineAmount,
    damageNote,
  );

  /// Create a copy of Transaction
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TransactionImplCopyWith<_$TransactionImpl> get copyWith =>
      __$$TransactionImplCopyWithImpl<_$TransactionImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TransactionImplToJson(this);
  }
}

abstract class _Transaction implements Transaction {
  const factory _Transaction({
    required final int id,
    required final int userId,
    required final int itemId,
    required final DateTime startDate,
    required final DateTime endDate,
    required final double totalPrice,
    required final double dpAmount,
    final TransactionStatus status,
    final DateTime? actualReturnDate,
    final double fineAmount,
    final String? damageNote,
  }) = _$TransactionImpl;

  factory _Transaction.fromJson(Map<String, dynamic> json) =
      _$TransactionImpl.fromJson;

  @override
  int get id;
  @override
  int get userId;
  @override
  int get itemId;
  @override
  DateTime get startDate;
  @override
  DateTime get endDate;
  @override
  double get totalPrice;
  @override
  double get dpAmount;
  @override
  TransactionStatus get status;
  @override
  DateTime? get actualReturnDate;
  @override
  double get fineAmount;
  @override
  String? get damageNote;

  /// Create a copy of Transaction
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TransactionImplCopyWith<_$TransactionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
