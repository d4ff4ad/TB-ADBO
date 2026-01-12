import 'package:flutter/foundation.dart';
import 'package:cross_file/cross_file.dart';
import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../domain/user.dart';

part 'auth_remote_source.g.dart';

@riverpod
AuthRemoteSource authRemoteSource(AuthRemoteSourceRef ref) {
  return AuthRemoteSource(
    Dio(
      BaseOptions(
        baseUrl: 'http://127.0.0.1:8000/api', // Localhost for Windows/Web
        // Use 'http://10.0.2.2:8000/api' if you switch to Android Emulator
        headers: {'Accept': 'application/json'},
      ),
    ),
  );
}

class AuthRemoteSource {
  final Dio _dio;

  AuthRemoteSource(this._dio);

  Future<User> login(String email, String password) async {
    try {
      final response = await _dio.post(
        '/login',
        data: {'email': email, 'password': password},
      );

      debugPrint('Login Success Response: ${response.data}');

      if (response.data['data'] == null) {
        throw Exception('User data is null in response');
      }

      // Map snake_case from backend to camelCase for Dart model
      final userData = Map<String, dynamic>.from(response.data['data']);
      userData['phoneNumber'] = userData['phone_number'];

      // Check for token in various common places
      String? token = response.data['token'] ?? response.data['access_token'];
      if (token == null && response.data['data'] is Map) {
        token = response.data['data']['token'];
      }
      userData['token'] = token;

      return User.fromJson(userData);
    } on DioException catch (e) {
      debugPrint(
        'Login Error: ${e.response?.statusCode} - ${e.response?.data}',
      );
      throw Exception(e.response?.data['message'] ?? 'Login Failed');
    }
  }

  Future<User> register(
    String name,
    String email,
    String password,
    String phoneNumber,
    XFile? ktpImage,
  ) async {
    try {
      final formData = FormData.fromMap({
        'name': name,
        'email': email,
        'password': password,
        'password_confirmation': password, // Satisfy Laravel 'confirmed' rule
        'phone_number': phoneNumber,
        'role': 'member',
      });

      if (ktpImage != null) {
        final bytes = await ktpImage.readAsBytes();
        formData.files.add(
          MapEntry(
            'ktp_image',
            MultipartFile.fromBytes(bytes, filename: ktpImage.name),
          ),
        );
      }

      final response = await _dio.post('/register', data: formData);

      debugPrint(
        'Register Success Response: ${response.data}',
      ); // Debugging line

      // Map snake_case from backend to camelCase for Dart model
      final userData = Map<String, dynamic>.from(response.data['data']);
      userData['phoneNumber'] = userData['phone_number'];
      // userData['ktpUrl'] = userData['ktp_url']; // If backend sends this later

      return User.fromJson(userData);
    } on DioException catch (e) {
      debugPrint(
        'Register Error: ${e.response?.statusCode} - ${e.response?.data}',
      );
      debugPrint('Dio Message: ${e.message}');

      String errorMessage = 'Register Failed';
      if (e.response?.data != null && e.response!.data is Map) {
        errorMessage = e.response!.data['message'] ?? errorMessage;
        // Check for validation errors
        if (e.response!.data['errors'] != null) {
          errorMessage += ': ${e.response!.data['errors'].toString()}';
        }
      } else if (e.message != null) {
        errorMessage = e.message!;
      }

      throw Exception(errorMessage);
    }
  }

  Future<User> updateProfile({
    required String token,
    required String name,
    required String email,
    required String phoneNumber,
    String? address,
    XFile? ktpImage,
  }) async {
    try {
      final map = {
        'name': name,
        'email': email,
        'phone_number': phoneNumber,
        if (address != null) 'address': address,
      };

      final formData = FormData.fromMap(map);

      if (ktpImage != null) {
        final bytes = await ktpImage.readAsBytes();
        formData.files.add(
          MapEntry(
            'ktp_image',
            MultipartFile.fromBytes(bytes, filename: ktpImage.name),
          ),
        );
      }

      final response = await _dio.post(
        '/update-profile',
        data: formData,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      debugPrint('Update Profile Response: ${response.data}');

      if (response.data['data'] == null) {
        throw Exception("Failed to update profile: No data returned");
      }

      final userData = Map<String, dynamic>.from(response.data['data']);

      // Manually map fields to match User model
      userData['phoneNumber'] = userData['phone_number'];
      if (userData['ktp_image_url'] != null) {
        userData['ktpUrl'] = userData['ktp_image_url'];
      }
      if (userData['address'] != null) {
        userData['address'] = userData['address'];
      }

      // Inject token back so state persists properly
      userData['token'] = token;

      return User.fromJson(userData);
    } on DioException catch (e) {
      debugPrint('Update Profile Error: ${e.response?.data}');
      throw Exception(
        e.response?.data['message'] ?? 'Failed to update profile',
      );
    }
  }
}
