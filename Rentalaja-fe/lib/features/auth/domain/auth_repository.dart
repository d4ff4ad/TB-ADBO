import 'package:cross_file/cross_file.dart';
import '../domain/user.dart';

abstract class AuthRepository {
  Future<User> login(String email, String password);
  Future<User> register(
    String name,
    String email,
    String password,
    String phoneNumber,
    XFile? ktpImage,
  );
  Future<void> logout();
  Future<User> updateProfile({
    required String token,
    required String name,
    required String email,
    required String phoneNumber,
    String? address,
    XFile? ktpImage,
  });
}
