// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TransactionImpl _$$TransactionImplFromJson(Map<String, dynamic> json) =>
    _$TransactionImpl(
      id: (json['id'] as num).toInt(),
      userId: (json['user_id'] as num).toInt(),
      productId: (json['product_id'] as num).toInt(),
      startDate: DateTime.parse(json['start_date'] as String),
      endDate: DateTime.parse(json['end_date'] as String),
      pickupTime: json['pickup_time'] as String,
      returnTime: json['return_time'] as String,
      totalPrice: (json['total_price'] as num).toDouble(),
      status: json['status'] as String,
      paymentMethod: json['payment_method'] as String,
      paymentProof: json['payment_proof'] as String?,
      product: json['product'] == null
          ? null
          : ElectronicItem.fromJson(json['product'] as Map<String, dynamic>),
      isRated: json['is_rated'] as bool?,
    );

Map<String, dynamic> _$$TransactionImplToJson(_$TransactionImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'product_id': instance.productId,
      'start_date': instance.startDate.toIso8601String(),
      'end_date': instance.endDate.toIso8601String(),
      'pickup_time': instance.pickupTime,
      'return_time': instance.returnTime,
      'total_price': instance.totalPrice,
      'status': instance.status,
      'payment_method': instance.paymentMethod,
      'payment_proof': instance.paymentProof,
      'product': instance.product,
      'is_rated': instance.isRated,
    };
