import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:cross_file/cross_file.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../auth/data/auth_remote_source.dart';
import '../../catalogue/domain/electronic_item.dart';
import '../../catalogue/domain/transaction.dart';

part 'catalogue_remote_source.g.dart';

@riverpod
CatalogueRemoteSource catalogueRemoteSource(CatalogueRemoteSourceRef ref) {
  // Reuse the Dio instance from AuthRemoteSource (or create a separate provider for Dio)
  // For simplicity, we'll creating a new one with same config or we could abstract Dio provider.
  // Ideally, use the same Dio instance to share cookies/headers if needed.
  // For now, let's just create a new one to keep it simple, or better yet, depend on a Dio provider.
  // Actually, AuthRemoteSource creates its own Dio. Let's do the same here for consistency or Refactor later.

  final host = !kIsWeb && defaultTargetPlatform == TargetPlatform.android
      ? '10.0.2.2'
      : '127.0.0.1';

  return CatalogueRemoteSource(
    Dio(
      BaseOptions(
        baseUrl: 'http://$host:8000/api',
        headers: {'Accept': 'application/json'},
      ),
    ),
  );
}

class CatalogueRemoteSource {
  final Dio _dio;

  CatalogueRemoteSource(this._dio);

  Future<List<ElectronicItem>> getProducts() async {
    try {
      final response = await _dio.get('/products');

      debugPrint('Products Response: ${response.data}');

      if (response.data['data'] == null) {
        return [];
      }

      final List<dynamic> data = response.data['data'];
      debugPrint('Fetched ${data.length} products from API');
      if (data.isNotEmpty) {
        debugPrint('Sample Product Data: ${data.first}');
      }

      return data.map((json) {
        // Map snake_case to camelCase manually if needed, or rely on Model
        final itemJson = Map<String, dynamic>.from(json);

        itemJson['pricePerDay'] =
            double.tryParse(json['price_per_day'].toString()) ?? 0.0;

        // Fix Image URL
        String? imageUrl = json['image_url'];
        if (imageUrl != null) {
          // Debug the raw URL
          debugPrint('Raw Image URL from API: $imageUrl');

          // Handle relative paths
          if (!imageUrl.startsWith('http')) {
            String path = imageUrl;
            if (!path.startsWith('/')) {
              path = '/$path';
            }

            // If path doesn't start with /storage, prepend it
            if (!path.startsWith('/storage')) {
              path = '/storage$path';
            }

            // Determine host based on platform
            // If Web: localhost (127.0.0.1)
            // If Android (Emulator): 10.0.2.2
            // Else (iOS/Desktop): localhost (127.0.0.1)
            final host =
                !kIsWeb && defaultTargetPlatform == TargetPlatform.android
                ? '10.0.2.2'
                : '127.0.0.1';

            imageUrl = 'http://$host:8000$path';
          } else {
            // Fix localhost for Android Emulator
            if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
              imageUrl = imageUrl.replaceFirst('localhost', '10.0.2.2');
              imageUrl = imageUrl.replaceFirst('127.0.0.1', '10.0.2.2');
            }
          }
        }
        itemJson['imageUrl'] = imageUrl ?? 'https://via.placeholder.com/300';
        // Ensure manual map matches what ElectronicItem.fromJson expects
        itemJson['image_url'] = itemJson['imageUrl'];
        itemJson['averageRating'] =
            double.tryParse(json['average_rating'].toString()) ?? 0.0;

        return ElectronicItem.fromJson(itemJson);
      }).toList();
    } on DioException catch (e) {
      debugPrint(
        'Get Products Error: ${e.response?.statusCode} - ${e.response?.data}',
      );
      throw Exception(e.response?.data['message'] ?? 'Failed to load products');
    }
  }

  Future<ElectronicItem> getProductDetail(int id) async {
    try {
      final response = await _dio.get('/products/$id');
      final data = Map<String, dynamic>.from(response.data['data']);

      data['pricePerDay'] =
          double.tryParse(data['price_per_day'].toString()) ?? 0.0;
      data['imageUrl'] = data['image_url'] ?? 'https://via.placeholder.com/300';
      data['averageRating'] =
          double.tryParse(data['average_rating'].toString()) ?? 0.0;

      return ElectronicItem.fromJson(data);
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message'] ?? 'Failed to load product detail',
      );
    }
  }

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
    try {
      final startStr = startDate.toIso8601String().split('T')[0];
      final endStr = endDate.toIso8601String().split('T')[0];

      // Format TimeOfDay to HH:mm
      final pickupStr =
          '${pickupTime.hour.toString().padLeft(2, '0')}:${pickupTime.minute.toString().padLeft(2, '0')}';
      final returnStr =
          '${returnTime.hour.toString().padLeft(2, '0')}:${returnTime.minute.toString().padLeft(2, '0')}';

      final formData = FormData.fromMap({
        'product_id': productId,
        'start_date': startStr,
        'end_date': endStr,
        'pickup_time': pickupStr,
        'return_time': returnStr,
        'payment_method': paymentMethod,
      });

      // Add Payment Proof Image
      final bytes = await paymentProof.readAsBytes();
      formData.files.add(
        MapEntry(
          'payment_proof',
          MultipartFile.fromBytes(bytes, filename: paymentProof.name),
        ),
      );

      await _dio.post(
        '/transactions',
        data: formData,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
    } on DioException catch (e) {
      debugPrint('Create Transaction Error: ${e.response?.data}');
      throw Exception(
        e.response?.data['message'] ?? 'Failed to create transaction',
      );
    }
  }

  Future<List<Transaction>> getHistory(String token) async {
    try {
      final response = await _dio.get(
        '/transactions',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      debugPrint('History Response: ${response.data}');

      if (response.data['data'] == null) {
        return [];
      }

      final List<dynamic> data = response.data['data'];

      return data.map((json) {
        final transactionJson = Map<String, dynamic>.from(json);

        // Fix total_price type (String -> Double)
        if (transactionJson['total_price'] is String) {
          transactionJson['total_price'] =
              double.tryParse(transactionJson['total_price']) ?? 0.0;
        }

        // Fix is_rated type (int/string -> bool)
        final rawIsRated = transactionJson['is_rated'];
        debugPrint(
          'Transaction ID: ${transactionJson['id']}, Raw is_rated: $rawIsRated (${rawIsRated.runtimeType})',
        );

        if (rawIsRated is int) {
          transactionJson['is_rated'] = rawIsRated == 1;
        } else if (rawIsRated is String) {
          transactionJson['is_rated'] =
              rawIsRated == '1' || rawIsRated.toLowerCase() == 'true';
        }
        // If null or already bool, leave it equal.
        // Note: If null, model expects nullable bool? so it is fine.

        // Fix nested product price if it exists
        if (transactionJson['product'] != null) {
          final productJson = Map<String, dynamic>.from(
            transactionJson['product'],
          );
          if (productJson['price_per_day'] is String) {
            productJson['price_per_day'] =
                double.tryParse(productJson['price_per_day']) ?? 0.0;
          }
          // Ensure imageUrl is set in nested product
          productJson['imageUrl'] =
              productJson['image_url'] ?? 'https://via.placeholder.com/300';
          // Map pricePerDay for internal consistency if needed by ElectronicItem.fromJson
          productJson['pricePerDay'] = productJson['price_per_day'];

          transactionJson['product'] = productJson;
        }

        return Transaction.fromJson(transactionJson);
      }).toList();
    } on DioException catch (e) {
      debugPrint('Get History Error: ${e.response?.data}');
      throw Exception(e.response?.data['message'] ?? 'Failed to load history');
    }
  }

  Future<ElectronicItem> createProduct({
    required String token,
    required String name,
    required String description,
    required double pricePerDay,
    required int stock,
    required XFile image,
  }) async {
    try {
      final formData = FormData.fromMap({
        'name': name,
        'description': description,
        'price_per_day': pricePerDay,
        'stock': stock,
        'status': 'available',
      });

      final bytes = await image.readAsBytes();
      formData.files.add(
        MapEntry('image', MultipartFile.fromBytes(bytes, filename: image.name)),
      );

      final response = await _dio.post(
        '/products',
        data: formData,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      debugPrint('Create Product Response: ${response.data}');

      if (response.data['data'] == null) {
        throw Exception("Failed to create product: No data returned");
      }

      final json = Map<String, dynamic>.from(response.data['data']);

      // Parse fields manually to safe-guard against type issues
      json['pricePerDay'] =
          double.tryParse(json['price_per_day'].toString()) ?? 0.0;
      json['stock'] = int.tryParse(json['stock'].toString()) ?? 0;

      json['imageUrl'] = json['image_url'] ?? 'https://via.placeholder.com/300';

      return ElectronicItem.fromJson(json);
    } on DioException catch (e) {
      debugPrint('Create Product Error: ${e.response?.data}');
      throw Exception(
        e.response?.data['message'] ?? 'Failed to create product',
      );
    }
  }

  Future<ElectronicItem> updateProduct({
    required String token,
    required int id,
    required String name,
    required String description,
    required double pricePerDay,
    required int stock,
    XFile? image,
  }) async {
    try {
      final dataMap = {
        'name': name,
        'description': description,
        'price_per_day': pricePerDay,
        'stock': stock,
        'status': 'available',
      };

      final formData = FormData.fromMap(dataMap);

      if (image != null) {
        final bytes = await image.readAsBytes();
        formData.files.add(
          MapEntry(
            'image',
            MultipartFile.fromBytes(bytes, filename: image.name),
          ),
        );
      }

      final response = await _dio.post(
        '/products/$id',
        data: formData,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      debugPrint('Update Product Response: ${response.data}');

      if (response.data['data'] == null) {
        throw Exception("Failed to update product: No data returned");
      }

      final json = Map<String, dynamic>.from(response.data['data']);

      // Parse fields manually
      json['pricePerDay'] =
          double.tryParse(json['price_per_day'].toString()) ?? 0.0;
      json['stock'] = int.tryParse(json['stock'].toString()) ?? 0;

      // Fix Image URL logic
      String? imageUrl = json['image_url'];
      if (imageUrl != null) {
        if (!imageUrl.startsWith('http')) {
          String path = imageUrl;
          if (!path.startsWith('/')) path = '/$path';
          if (!path.startsWith('/storage')) path = '/storage$path';

          final host =
              !kIsWeb && defaultTargetPlatform == TargetPlatform.android
              ? '10.0.2.2'
              : '127.0.0.1';
          imageUrl = 'http://$host:8000$path';
        } else {
          if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
            imageUrl = imageUrl.replaceFirst('localhost', '10.0.2.2');
            imageUrl = imageUrl.replaceFirst('127.0.0.1', '10.0.2.2');
          }
        }
      }
      json['imageUrl'] = imageUrl ?? 'https://via.placeholder.com/300';
      json['image_url'] = json['imageUrl'];

      return ElectronicItem.fromJson(json);
    } on DioException catch (e) {
      debugPrint('Update Product Error: ${e.response?.data}');
      throw Exception(
        e.response?.data['message'] ?? 'Failed to update product',
      );
    }
  }

  Future<void> deleteProduct(String token, int id) async {
    try {
      await _dio.delete(
        '/products/$id',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
    } on DioException catch (e) {
      debugPrint('Delete Product Error: ${e.response?.data}');
      throw Exception(
        e.response?.data['message'] ?? 'Failed to delete product',
      );
    }
  }

  Future<List<Transaction>> getAllTransactions(String token) async {
    try {
      final response = await _dio.get(
        '/admin/transactions',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      debugPrint('Admin Transactions Response: ${response.data}');

      if (response.data['data'] == null) {
        return [];
      }

      final List<dynamic> data = response.data['data'];

      return data.map((json) {
        final transactionJson = Map<String, dynamic>.from(json);

        if (transactionJson['total_price'] is String) {
          transactionJson['total_price'] =
              double.tryParse(transactionJson['total_price']) ?? 0.0;
        }

        // Fix is_rated type (int/string -> bool)
        final rawIsRated = transactionJson['is_rated'];
        if (rawIsRated is int) {
          transactionJson['is_rated'] = rawIsRated == 1;
        } else if (rawIsRated is String) {
          transactionJson['is_rated'] =
              rawIsRated == '1' || rawIsRated.toLowerCase() == 'true';
        }

        if (transactionJson['product'] != null) {
          final productJson = Map<String, dynamic>.from(
            transactionJson['product'],
          );
          if (productJson['price_per_day'] is String) {
            productJson['price_per_day'] =
                double.tryParse(productJson['price_per_day']) ?? 0.0;
          }
          productJson['imageUrl'] =
              productJson['image_url'] ?? 'https://via.placeholder.com/300';
          productJson['pricePerDay'] = productJson['price_per_day'];
          transactionJson['product'] = productJson;
        }

        // Process Payment Proof URL
        String? paymentProofUrl = transactionJson['payment_proof'];
        if (paymentProofUrl != null) {
          if (!paymentProofUrl.startsWith('http')) {
            String path = paymentProofUrl;
            if (!path.startsWith('/')) path = '/$path';
            if (!path.startsWith('/storage')) path = '/storage$path';

            final host =
                !kIsWeb && defaultTargetPlatform == TargetPlatform.android
                ? '10.0.2.2'
                : '127.0.0.1';
            paymentProofUrl = 'http://$host:8000$path';
          } else {
            // Force fix for Android Emulator if URL is localhost/127.0.0.1
            if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
              paymentProofUrl = paymentProofUrl!.replaceFirst(
                'localhost',
                '10.0.2.2',
              );
              paymentProofUrl = paymentProofUrl!.replaceFirst(
                '127.0.0.1',
                '10.0.2.2',
              );
            }
          }
          transactionJson['paymentProof'] = paymentProofUrl;
          transactionJson['payment_proof'] = paymentProofUrl; // Sync back
        }

        return Transaction.fromJson(transactionJson);
      }).toList();
    } on DioException catch (e) {
      debugPrint('Get All Transactions Error: ${e.response?.data}');
      throw Exception(
        e.response?.data['message'] ?? 'Failed to load all transactions',
      );
    }
  }

  Future<Transaction> updateTransactionStatus({
    required String token,
    required int id,
    required String status,
  }) async {
    try {
      final response = await _dio.post(
        '/transactions/$id/status',
        data: {'status': status},
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      debugPrint('Update Status Response: ${response.data}');

      final data = Map<String, dynamic>.from(response.data['data']);
      if (data['total_price'] is String) {
        data['total_price'] = double.tryParse(data['total_price']) ?? 0.0;
      }
      if (data['product'] != null) {
        final productJson = Map<String, dynamic>.from(data['product']);
        if (productJson['price_per_day'] is String) {
          productJson['price_per_day'] =
              double.tryParse(productJson['price_per_day']) ?? 0.0;
        }
        productJson['imageUrl'] =
            productJson['image_url'] ?? 'https://via.placeholder.com/300';
        productJson['pricePerDay'] = productJson['price_per_day'];
        data['product'] = productJson;
      }

      return Transaction.fromJson(data);
    } on DioException catch (e) {
      debugPrint('Update Status Error: ${e.response?.data}');
      throw Exception(e.response?.data['message'] ?? 'Failed to update status');
    }
  }

  Future<void> submitReview({
    required String token,
    required int transactionId,
    required int productId,
    required int rating,
    String? comment,
  }) async {
    try {
      final response = await _dio.post(
        '/reviews',
        data: {
          'transaction_id': transactionId,
          'product_id': productId,
          'rating': rating,
          'comment': comment,
        },
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      debugPrint('Submit Review Response: ${response.data}');
    } on DioException catch (e) {
      debugPrint('Submit Review Error: ${e.response?.data}');
      throw Exception(e.response?.data['message'] ?? 'Failed to submit review');
    }
  }
}
