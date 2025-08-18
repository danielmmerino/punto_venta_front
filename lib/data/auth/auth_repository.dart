import 'package:dio/dio.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../core/env/env.dart';
import 'auth_state.dart';
import 'user.dart';

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

class AuthRepository {
  AuthRepository(this._dio, this._storage);

  final Dio _dio;
  final SecureStorage _storage;
  static const _tokenKey = 'token';
  static const _expiresKey = 'expires_at';

  Future<User> login(String email, String password) async {
    final resp = await _dio.post('/v1/auth/login',
        data: {'email': email, 'password': password});
    final token = resp.data['token'] as String;
    final expiresIn = resp.data['expires_in'] as int;
    final user = User.fromJson(Map<String, dynamic>.from(resp.data['user']));
    final expiresAt = DateTime.now().add(Duration(seconds: expiresIn));
    await _storage.write(key: _tokenKey, value: token);
    await _storage.write(key: _expiresKey, value: expiresAt.toIso8601String());
    return user;
  }

  Future<void> refresh() async {
    final resp = await _dio.post('/v1/auth/refresh');
    final token = resp.data['token'] as String;
    final expiresIn = resp.data['expires_in'] as int;
    final expiresAt = DateTime.now().add(Duration(seconds: expiresIn));
    await _storage.write(key: _tokenKey, value: token);
    await _storage.write(key: _expiresKey, value: expiresAt.toIso8601String());
  }

  Future<void> logout() async {
    await _storage.delete(key: _tokenKey);
    await _storage.delete(key: _expiresKey);
  }

  Future<User> me() async {
    final token = await getToken();
    final resp = await _dio.get('/v1/auth/me',
        options: Options(headers: {'Authorization': 'Bearer $token'}));
    return User.fromJson(Map<String, dynamic>.from(resp.data));
  }

  Future<String?> getToken() => _storage.read(key: _tokenKey);

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

  Future<void> login(String email, String password) async {
    state = const Authenticating();
    final user = await _repo.login(email, password);
    final exp = await _repo.getExpiresAt();
    state = Authenticated(user: user, expiresAt: exp!);
  }

  Future<void> logout() async {
    await _repo.logout();
    state = const Unauthenticated();
  }
}
