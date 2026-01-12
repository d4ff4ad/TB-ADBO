import 'package:freezed_annotation/freezed_annotation.dart';

part 'transaction.freezed.dart';
part 'transaction.g.dart';

enum TransactionStatus { pending, active, completed, cancelled, late, damaged }

@freezed
class Transaction with _$Transaction {
  const factory Transaction({
    required int id,
    required int userId,
    required int itemId,
    required DateTime startDate,
    required DateTime endDate,
    required double totalPrice,
    required double dpAmount,
    @Default(TransactionStatus.pending) TransactionStatus status,
    DateTime? actualReturnDate,
    @Default(0) double fineAmount,
    String? damageNote,
  }) = _Transaction;

  factory Transaction.fromJson(Map<String, dynamic> json) =>
      _$TransactionFromJson(json);
}
