import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:punto_venta_front/data/auth/auth_repository.dart';
import 'package:punto_venta_front/data/auth/user.dart';

class MockDio extends Mock implements Dio {}

class MemoryStorage implements SecureStorage {
  final Map<String, String?> _store = {};
  @override
  Future<String?> read({required String key}) async => _store[key];

  @override
  Future<void> write({required String key, String? value}) async {
    _store[key] = value;
  }

  @override
  Future<void> delete({required String key}) async {
    _store.remove(key);
  }
}

void main() {
  test('login stores token and calculates expiration with expires_in', () async {
    final dio = MockDio();
    final storage = MemoryStorage();
    final repo = AuthRepository(dio, storage);

    when(() => dio.post('/v1/auth/login', data: any(named: 'data'))).thenAnswer(
      (_) async => Response(
        requestOptions: RequestOptions(path: '/v1/auth/login'),
        statusCode: 200,
        data: {
          'token': 'abc',
          'expires_in': 86400,
          'user': {'id': 1, 'nombre': 'Demo', 'email': 'd@e.com'},
        },
      ),
    );

    await repo.login('demo', 'pw');

    expect(await storage.read(key: 'token'), 'abc');
    final exp = await repo.getExpiresAt();
    expect(exp!.difference(DateTime.now()).inHours, closeTo(24, 1));
  });

  test('login handles exp field', () async {
    final dio = MockDio();
    final storage = MemoryStorage();
    final repo = AuthRepository(dio, storage);

    when(() => dio.post('/v1/auth/login', data: any(named: 'data'))).thenAnswer(
      (_) async => Response(
        requestOptions: RequestOptions(path: '/v1/auth/login'),
        statusCode: 200,
        data: {
          'token': 'abc',
          'exp': DateTime.now().add(const Duration(hours: 10)).millisecondsSinceEpoch ~/ 1000,
          'user': {'id': 1, 'nombre': 'Demo', 'email': 'd@e.com'},
        },
      ),
    );

    await repo.login('demo', 'pw');

    final exp = await repo.getExpiresAt();
    expect(exp!.difference(DateTime.now()).inHours, closeTo(10, 1));
  });

  test('login fetches user from me when response lacks user', () async {
    final dio = MockDio();
    final storage = MemoryStorage();
    final repo = AuthRepository(dio, storage);

    when(() => dio.post('/v1/auth/login', data: any(named: 'data'))).thenAnswer(
      (_) async => Response(
        requestOptions: RequestOptions(path: '/v1/auth/login'),
        statusCode: 200,
        data: {
          'token': 'abc',
          'expires_in': 86400,
          // no user field
        },
      ),
    );

    when(() => dio.get('/v1/auth/me', options: any(named: 'options'))).thenAnswer(
      (_) async => Response(
        requestOptions: RequestOptions(path: '/v1/auth/me'),
        statusCode: 200,
        data: {'id': 1, 'nombre': 'Demo', 'email': 'd@e.com'},
      ),
    );

    final resp = await repo.login('demo', 'pw');
    expect(resp.user, isA<User>());
    expect(resp.user.email, 'd@e.com');
  });
}
