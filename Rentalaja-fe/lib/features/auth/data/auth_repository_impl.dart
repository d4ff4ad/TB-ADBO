import 'dart:io';
import 'package:cross_file/cross_file.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../domain/auth_repository.dart';
import '../domain/user.dart';
import 'auth_remote_source.dart';

part 'auth_repository_impl.g.dart';

@riverpod
AuthRepository authRepository(AuthRepositoryRef ref) {
  final remoteSource = ref.watch(authRemoteSourceProvider);
  return AuthRepositoryImpl(remoteSource);
}

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteSource _remoteSource;

  AuthRepositoryImpl(this._remoteSource);

  @override
  Future<User> login(String email, String password) {
    return _remoteSource.login(email, password);
  }

  @override
  Future<User> register(
    String name,
    String email,
    String password,
    String phoneNumber,
    XFile? ktpImage,
  ) {
    return _remoteSource.register(name, email, password, phoneNumber, ktpImage);
  }

  @override
  Future<void> logout() async {
    // TODO: Call API logout if needed
  }

  @override
  Future<User> updateProfile({
    required String token,
    required String name,
    required String email,
    required String phoneNumber,
    String? address,
    XFile? ktpImage,
  }) {
    return _remoteSource.updateProfile(
      token: token,
      name: name,
      email: email,
      phoneNumber: phoneNumber,
      address: address,
      ktpImage: ktpImage,
    );
  }
}
