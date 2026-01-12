import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cross_file/cross_file.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../domain/user.dart';
import '../data/auth_repository_impl.dart';

part 'auth_controller.g.dart';

@Riverpod(keepAlive: true)
class AuthController extends _$AuthController {
  @override
  Future<User?> build() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userJson = prefs.getString('user_data');
      if (userJson != null) {
        return User.fromJson(jsonDecode(userJson));
      }
    } catch (e) {
      // Ignore error, just start as guest
    }
    return null;
  }

  Future<void> login(String email, String password) async {
    state = const AsyncValue.loading();
    try {
      final user = await ref
          .read(authRepositoryProvider)
          .login(email, password);

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_data', jsonEncode(user.toJson()));

      state = AsyncValue.data(user);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> register(
    String name,
    String email,
    String password,
    String phoneNumber,
    XFile? ktpImage,
  ) async {
    state = const AsyncValue.loading();
    try {
      final user = await ref
          .read(authRepositoryProvider)
          .register(name, email, password, phoneNumber, ktpImage);

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_data', jsonEncode(user.toJson()));

      state = AsyncValue.data(user);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_data');
    state = const AsyncValue.data(null);
  }

  Future<void> updateProfile({
    required String name,
    required String email,
    required String phoneNumber,
    String? address,
    XFile? ktpImage,
  }) async {
    final currentState = state.value;
    if (currentState == null || currentState.token == null) return;

    final token = currentState.token!;
    // Keep loading state but don't clear user yet?
    // Or set loading.
    // Setting state to loading might clear UI. Better to use a separate provider for loading status of update?
    // For simplicity, we can let the UI handle loading state locally or use this state.
    // If we set state = loading, the user becomes null in UI.
    // Let's just await.

    try {
      final updatedUser = await ref
          .read(authRepositoryProvider)
          .updateProfile(
            token: token,
            name: name,
            email: email,
            phoneNumber: phoneNumber,
            address: address,
            ktpImage: ktpImage,
          );
      state = AsyncValue.data(updatedUser);
    } catch (e, st) {
      // Ideally show error toast, but here we update state to error?
      // If we update state to error, user is null.
      // Better to re-throw or handle in UI.
      // For now, let's keep old state and throw.
      // or use AsyncValue.data(currentState) + side effect.
      // Let's just throw for UI to catch.
      throw e;
    }
  }
}
