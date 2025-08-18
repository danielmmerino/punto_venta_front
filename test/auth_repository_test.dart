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
  test('login stores token and calculates expiration', () async {
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
}
