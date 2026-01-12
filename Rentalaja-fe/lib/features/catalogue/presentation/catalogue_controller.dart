import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter/material.dart';
import 'package:cross_file/cross_file.dart';
import '../../catalogue/domain/electronic_item.dart';
import '../../catalogue/domain/transaction.dart';
import '../../catalogue/data/catalogue_repository_impl.dart';

part 'catalogue_controller.g.dart';

@riverpod
class Products extends _$Products {
  @override
  FutureOr<List<ElectronicItem>> build() async {
    final repository = ref.watch(catalogueRepositoryProvider);
    return repository.getProducts();
  }

  void decrementStock(int productId) {
    if (!state.hasValue) return;
    final currentList = state.value!;

    final updatedList = currentList.map((item) {
      if (item.id == productId) {
        final newStock = item.stock > 0 ? item.stock - 1 : 0;
        return item.copyWith(stock: newStock);
      }
      return item;
    }).toList();

    state = AsyncValue.data(updatedList);
  }
}

@riverpod
class ProductDetail extends _$ProductDetail {
  @override
  FutureOr<ElectronicItem> build(int id) {
    final repository = ref.watch(catalogueRepositoryProvider);
    return repository.getProductDetail(id);
  }

  void decrementStock() {
    if (!state.hasValue) return;
    final item = state.value!;
    if (item.stock > 0) {
      state = AsyncValue.data(item.copyWith(stock: item.stock - 1));
    }
  }
}

@riverpod
class TransactionHistory extends _$TransactionHistory {
  @override
  FutureOr<List<Transaction>> build(String token) {
    return ref.watch(catalogueRepositoryProvider).getHistory(token);
  }

  void markAsRated(int transactionId) {
    final currentState = state.value;
    if (currentState == null) return;

    final updatedList = currentState.map((t) {
      if (t.id == transactionId) {
        return t.copyWith(isRated: true);
      }
      return t;
    }).toList();

    state = AsyncValue.data(updatedList);
  }
}

@riverpod
Future<List<Transaction>> adminTransactions(
  AdminTransactionsRef ref,
  String token,
) {
  return ref.watch(catalogueRepositoryProvider).getAllTransactions(token);
}

@riverpod
class TransactionController extends _$TransactionController {
  @override
  FutureOr<void> build() {}

  Future<void> createTransaction({
    required String token,
    required int productId,
    required DateTime startDate,
    required DateTime endDate,
    required TimeOfDay pickupTime,
    required TimeOfDay returnTime,
    required String paymentMethod,
    required XFile paymentProof,
  }) async {
    state = const AsyncValue.loading();
    try {
      await ref
          .read(catalogueRepositoryProvider)
          .createTransaction(
            token: token,
            productId: productId,
            startDate: startDate,
            endDate: endDate,
            pickupTime: pickupTime,
            returnTime: returnTime,
            paymentMethod: paymentMethod,
            paymentProof: paymentProof,
          );

      // Optimistically update stock count
      ref.read(productsProvider.notifier).decrementStock(productId);
      ref.read(productDetailProvider(productId).notifier).decrementStock();

      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> editProduct({
    required String token,
    required int id,
    required String name,
    required String description,
    required double pricePerDay,
    required int stock,
    XFile? image,
  }) async {
    state = const AsyncValue.loading();
    try {
      await ref
          .read(catalogueRepositoryProvider)
          .updateProduct(
            token: token,
            id: id,
            name: name,
            description: description,
            pricePerDay: pricePerDay,
            stock: stock,
            image: image,
          );
      ref.invalidate(productsProvider);
      ref.invalidate(productDetailProvider(id));
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      // Optional: rethrow if we want UI to catch it too
      rethrow;
    }
  }

  Future<void> deleteProduct(String token, int id) async {
    state = const AsyncValue.loading();
    try {
      await ref.read(catalogueRepositoryProvider).deleteProduct(token, id);
      ref.invalidate(productsProvider);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  Future<void> addProduct({
    required String token,
    required String name,
    required String description,
    required double pricePerDay,
    required int stock,
    required XFile image,
  }) async {
    state = const AsyncValue.loading();
    try {
      await ref
          .read(catalogueRepositoryProvider)
          .createProduct(
            token: token,
            name: name,
            description: description,
            pricePerDay: pricePerDay,
            stock: stock,
            image: image,
          );
      // Invalidate products provider to refresh list
      ref.invalidate(productsProvider);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow; // Rethrow so UI can show SnackBar
    }
  }

  Future<void> submitReview({
    required String token,
    required int transactionId,
    required int productId,
    required int rating,
    String? comment,
  }) async {
    state = const AsyncValue.loading();
    try {
      await ref
          .read(catalogueRepositoryProvider)
          .submitReview(
            token: token,
            transactionId: transactionId,
            productId: productId,
            rating: rating,
            comment: comment,
          );

      // Optimistic update: Mark as rated locally immediately
      ref
          .read(transactionHistoryProvider(token).notifier)
          .markAsRated(transactionId);

      // Invalidate products to refresh average rating, but NOT history to avoid old data flicker
      ref.invalidate(productsProvider);

      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  Future<void> updateStatus({
    required String token,
    required int id,
    required String status,
  }) async {
    state = const AsyncValue.loading();
    try {
      await ref
          .read(catalogueRepositoryProvider)
          .updateTransactionStatus(token: token, id: id, status: status);
      // Invalidate admin transactions to refresh list
      ref.invalidate(adminTransactionsProvider);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }
}
