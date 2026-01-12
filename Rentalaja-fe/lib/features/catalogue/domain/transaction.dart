import 'package:freezed_annotation/freezed_annotation.dart';
import 'electronic_item.dart';

part 'transaction.freezed.dart';
part 'transaction.g.dart';

@freezed
class Transaction with _$Transaction {
  const factory Transaction({
    required int id,
    @JsonKey(name: 'user_id') required int userId,
    @JsonKey(name: 'product_id') required int productId,
    @JsonKey(name: 'start_date') required DateTime startDate,
    @JsonKey(name: 'end_date') required DateTime endDate,
    @JsonKey(name: 'pickup_time') required String pickupTime,
    @JsonKey(name: 'return_time') required String returnTime,
    @JsonKey(name: 'total_price') required double totalPrice,
    required String status,
    @JsonKey(name: 'payment_method') required String paymentMethod,
    @JsonKey(name: 'payment_proof') String? paymentProof,
    // Product relationship (loaded via with('product'))
    ElectronicItem? product,
    @JsonKey(name: 'is_rated') bool? isRated,
  }) = _Transaction;

  factory Transaction.fromJson(Map<String, dynamic> json) =>
      _$TransactionFromJson(json);
}
