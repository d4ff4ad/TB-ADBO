import 'package:flutter/material.dart';
import 'package:cross_file/cross_file.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../catalogue/domain/electronic_item.dart';
import '../../catalogue/domain/catalogue_repository.dart';
import '../../catalogue/domain/transaction.dart';
import 'catalogue_remote_source.dart';

part 'catalogue_repository_impl.g.dart';

@riverpod
CatalogueRepository catalogueRepository(CatalogueRepositoryRef ref) {
  return CatalogueRepositoryImpl(ref.read(catalogueRemoteSourceProvider));
}

class CatalogueRepositoryImpl implements CatalogueRepository {
  final CatalogueRemoteSource _remoteSource;

  CatalogueRepositoryImpl(this._remoteSource);

  @override
  Future<List<ElectronicItem>> getProducts() {
    return _remoteSource.getProducts();
  }

  @override
  Future<ElectronicItem> getProductDetail(int id) {
    return _remoteSource.getProductDetail(id);
  }

  @override
  Future<void> createTransaction({
    required String token,
    required int productId,
    required DateTime startDate,
    required DateTime endDate,
    required TimeOfDay pickupTime,
    required TimeOfDay returnTime,
    required String paymentMethod,
    required XFile paymentProof,
  }) {
    return _remoteSource.createTransaction(
      token: token,
      productId: productId,
      startDate: startDate,
      endDate: endDate,
      pickupTime: pickupTime,
      returnTime: returnTime,
      paymentMethod: paymentMethod,
      paymentProof: paymentProof,
    );
  }

  @override
  Future<List<Transaction>> getHistory(String token) {
    return _remoteSource.getHistory(token);
  }

  @override
  Future<ElectronicItem> createProduct({
    required String token,
    required String name,
    required String description,
    required double pricePerDay,
    required int stock,
    required XFile image,
  }) {
    return _remoteSource.createProduct(
      token: token,
      name: name,
      description: description,
      pricePerDay: pricePerDay,
      stock: stock,
      image: image,
    );
  }

  @override
  Future<ElectronicItem> updateProduct({
    required String token,
    required int id,
    required String name,
    required String description,
    required double pricePerDay,
    required int stock,
    XFile? image,
  }) {
    return _remoteSource.updateProduct(
      token: token,
      id: id,
      name: name,
      description: description,
      pricePerDay: pricePerDay,
      stock: stock,
      image: image,
    );
  }

  @override
  Future<void> deleteProduct(String token, int id) {
    return _remoteSource.deleteProduct(token, id);
  }

  @override
  Future<List<Transaction>> getAllTransactions(String token) {
    return _remoteSource.getAllTransactions(token);
  }

  @override
  Future<Transaction> updateTransactionStatus({
    required String token,
    required int id,
    required String status,
  }) {
    return _remoteSource.updateTransactionStatus(
      token: token,
      id: id,
      status: status,
    );
  }

  @override
  Future<void> submitReview({
    required String token,
    required int transactionId,
    required int productId,
    required int rating,
    String? comment,
  }) {
    return _remoteSource.submitReview(
      token: token,
      transactionId: transactionId,
      productId: productId,
      rating: rating,
      comment: comment,
    );
  }
}
