import 'package:flutter/material.dart';
import 'package:cross_file/cross_file.dart';
import '../domain/electronic_item.dart';
import '../domain/transaction.dart';

abstract class CatalogueRepository {
  Future<List<ElectronicItem>> getProducts();
  Future<ElectronicItem> getProductDetail(int id);
  Future<void> createTransaction({
    required String token,
    required int productId,
    required DateTime startDate,
    required DateTime endDate,
    required TimeOfDay pickupTime,
    required TimeOfDay returnTime,
    required String paymentMethod,
    required XFile paymentProof,
  });
  Future<List<Transaction>> getHistory(String token);
  Future<ElectronicItem> createProduct({
    required String token,
    required String name,
    required String description,
    required double pricePerDay,
    required int stock,
    required XFile image,
  });
  Future<ElectronicItem> updateProduct({
    required String token,
    required int id,
    required String name,
    required String description,
    required double pricePerDay,
    required int stock,
    XFile? image,
  });
  Future<void> deleteProduct(String token, int id);
  Future<List<Transaction>> getAllTransactions(String token);
  Future<Transaction> updateTransactionStatus({
    required String token,
    required int id,
    required String status,
  });

  Future<void> submitReview({
    required String token,
    required int transactionId,
    required int productId,
    required int rating,
    String? comment,
  });
}
