import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../core/env/env.dart';
import 'auth_state.dart';
import 'user.dart';
import 'local.dart';

abstract class SecureStorage {
  Future<void> write({required String key, String? value});
  Future<String?> read({required String key});
  Future<void> delete({required String key});
}

class FlutterSecureStorageWrapper implements SecureStorage {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  @override
  Future<void> write({required String key, String? value}) =>
      _storage.write(key: key, value: value);

  @override
  Future<String?> read({required String key}) => _storage.read(key: key);

  @override
  Future<void> delete({required String key}) => _storage.delete(key: key);
}

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final dio = Dio(BaseOptions(baseUrl: Env.baseUrl));
  final storage = FlutterSecureStorageWrapper();
  return AuthRepository(dio, storage);
});

final authStateProvider =
    StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref.read(authRepositoryProvider));
});

class LoginResponse {
  LoginResponse({required this.user, required this.locales});

  final User user;
  final List<Local> locales;
}

class AuthRepository {
  AuthRepository(this._dio, this._storage);

  final Dio _dio;
  final SecureStorage _storage;
  static const _tokenKey = 'token';
  static const _expiresKey = 'expires_at';
  static const _localIdKey = 'local_id';

  Future<LoginResponse> login(String email, String password) async {
    final resp = await _dio.post('/v1/auth/login',
        data: {'email': email, 'password': password});
    final token = resp.data['token'] as String;
    await _storage.write(key: _tokenKey, value: token);
    final localId = resp.data['local_id'] as int?;
    if (localId != null) {
      await _storage.write(key: _localIdKey, value: localId.toString());
    }

    DateTime expiresAt;
    final exp = resp.data['exp'] as int?;
    final expiresIn = resp.data['expires_in'] as int?;
    if (exp != null) {
      expiresAt = DateTime.fromMillisecondsSinceEpoch(exp * 1000);
    } else if (expiresIn != null) {
      expiresAt = DateTime.now().add(Duration(seconds: expiresIn));
    } else {
      final parts = token.split('.');
      if (parts.length >= 2) {
        final payload = jsonDecode(utf8.decode(base64Url.decode(base64Url.normalize(parts[1]))));
        final claimExp = payload['exp'] as int?;
        if (claimExp != null) {
          expiresAt =
              DateTime.fromMillisecondsSinceEpoch(claimExp * 1000);
        } else {
          expiresAt = DateTime.now().add(const Duration(hours: 24));
        }
      } else {
        expiresAt = DateTime.now().add(const Duration(hours: 24));
      }
    }
    await _storage.write(
        key: _expiresKey, value: expiresAt.toIso8601String());

    // Some backends may omit user information on the login response.
    // If that happens, fetch the user from the `/v1/auth/me` endpoint
    // using the newly issued token so the app can continue without
    // throwing a cast error.
    User user;
    final userData = resp.data['user'];
    if (userData != null) {
      user = User.fromJson(Map<String, dynamic>.from(userData));
    } else {
      final meResp = await _dio.get('/v1/auth/me',
          options: Options(headers: {'Authorization': 'Bearer $token'}));
      user =
          User.fromJson(Map<String, dynamic>.from(meResp.data as Map<String, dynamic>));
    }

    final locales = (resp.data['locales'] as List?)
            ?.map((e) => Local.fromJson(Map<String, dynamic>.from(e)))
            .toList() ??
        [];
    return LoginResponse(user: user, locales: locales);
  }

  Future<void> refresh() async {
    final resp = await _dio.post('/v1/auth/refresh');
    final token = resp.data['token'] as String;
    final expiresIn = resp.data['expires_in'] as int;
    final expiresAt = DateTime.now().add(Duration(seconds: expiresIn));
    await _storage.write(key: _tokenKey, value: token);
    await _storage.write(key: _expiresKey, value: expiresAt.toIso8601String());
  }

  Future<void> changePassword(
      String currentPassword, String newPassword) async {
    final token = await getToken();
    await _dio.post('/v1/auth/change-password',
        data: {
          'current_password': currentPassword,
          'new_password': newPassword,
        },
        options: Options(headers: {'Authorization': 'Bearer $token'}));
  }

  Future<void> logout() async {
    await _storage.delete(key: _tokenKey);
    await _storage.delete(key: _expiresKey);
    await _storage.delete(key: _localIdKey);
  }

  Future<User> me() async {
    final token = await getToken();
    final resp = await _dio.get('/v1/auth/me',
        options: Options(headers: {'Authorization': 'Bearer $token'}));
    return User.fromJson(Map<String, dynamic>.from(resp.data));
  }

  Future<String?> getToken() => _storage.read(key: _tokenKey);

  Future<int?> getLocalId() async {
    final str = await _storage.read(key: _localIdKey);
    return str != null ? int.tryParse(str) : null;
  }

  Future<DateTime?> getExpiresAt() async {
    final str = await _storage.read(key: _expiresKey);
    if (str == null) return null;
    return DateTime.tryParse(str);
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier(this._repo) : super(const Unauthenticated()) {
    _init();
  }

  final AuthRepository _repo;

  Future<void> _init() async {
    final token = await _repo.getToken();
    final exp = await _repo.getExpiresAt();
    if (token != null && exp != null) {
      if (exp.isAfter(DateTime.now())) {
        final user = await _repo.me();
        state = Authenticated(user: user, expiresAt: exp);
      } else {
        state = const Expired();
      }
    }
  }

  Future<LoginResponse> login(String email, String password) async {
    state = const Authenticating();
    final resp = await _repo.login(email, password);
    final exp = await _repo.getExpiresAt();
    state = Authenticated(
      user: resp.user,
      expiresAt: exp!,
      locales: resp.locales,
    );
    return resp;
  }

  Future<void> logout() async {
    await _repo.logout();
    state = const Unauthenticated();
  }
}

/// Provider to check if current user has a specific permission.
final hasPermissionProvider = Provider.family<bool, String>((ref, perm) {
  final auth = ref.watch(authStateProvider);
  return auth is Authenticated && auth.user.permisos.contains(perm);
});
