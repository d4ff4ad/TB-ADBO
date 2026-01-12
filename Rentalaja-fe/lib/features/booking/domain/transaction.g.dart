// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TransactionImpl _$$TransactionImplFromJson(Map<String, dynamic> json) =>
    _$TransactionImpl(
      id: (json['id'] as num).toInt(),
      userId: (json['userId'] as num).toInt(),
      itemId: (json['itemId'] as num).toInt(),
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      totalPrice: (json['totalPrice'] as num).toDouble(),
      dpAmount: (json['dpAmount'] as num).toDouble(),
      status:
          $enumDecodeNullable(_$TransactionStatusEnumMap, json['status']) ??
          TransactionStatus.pending,
      actualReturnDate: json['actualReturnDate'] == null
          ? null
          : DateTime.parse(json['actualReturnDate'] as String),
      fineAmount: (json['fineAmount'] as num?)?.toDouble() ?? 0,
      damageNote: json['damageNote'] as String?,
    );

Map<String, dynamic> _$$TransactionImplToJson(_$TransactionImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'itemId': instance.itemId,
      'startDate': instance.startDate.toIso8601String(),
      'endDate': instance.endDate.toIso8601String(),
      'totalPrice': instance.totalPrice,
      'dpAmount': instance.dpAmount,
      'status': _$TransactionStatusEnumMap[instance.status]!,
      'actualReturnDate': instance.actualReturnDate?.toIso8601String(),
      'fineAmount': instance.fineAmount,
      'damageNote': instance.damageNote,
    };

const _$TransactionStatusEnumMap = {
  TransactionStatus.pending: 'pending',
  TransactionStatus.active: 'active',
  TransactionStatus.completed: 'completed',
  TransactionStatus.cancelled: 'cancelled',
  TransactionStatus.late: 'late',
  TransactionStatus.damaged: 'damaged',
};
