import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:punto_venta_front/features/cash/common/cash_repository.dart';

class MockDio extends Mock implements Dio {}

void main() {
  setUpAll(() {
    registerFallbackValue(Options());
  });

  test('closeCash adds Idempotency-Key header', () async {
    final dio = MockDio();
    when(() => dio.post('/v1/caja/cierre',
            data: any(named: 'data'), options: any(named: 'options')))
        .thenAnswer((_) async => Response(
              requestOptions: RequestOptions(path: '/v1/caja/cierre'),
              statusCode: 201,
              data: {'cierre_id': 1},
            ));
    final repo = CashRepository(dio);
    await repo.closeCash(aperturaId: 1, conteos: []);
    final captured = verify(() => dio.post('/v1/caja/cierre',
            data: any(named: 'data'), options: captureAny(named: 'options')))
        .captured
        .first as Options;
    final key = captured.headers?['Idempotency-Key'] as String?;
    expect(key, isNotNull);
    expect(key, startsWith('CLOSE-1-'));
  });

  test('closeCash throws CashAlreadyClosedException on 409', () async {
    final dio = MockDio();
    when(() => dio.post('/v1/caja/cierre',
            data: any(named: 'data'), options: any(named: 'options')))
        .thenThrow(DioException(
            requestOptions: RequestOptions(path: '/v1/caja/cierre'),
            response: Response(
                requestOptions: RequestOptions(path: '/v1/caja/cierre'),
                statusCode: 409)));
    final repo = CashRepository(dio);
    expect(
        () => repo.closeCash(aperturaId: 1, conteos: []),
        throwsA(isA<CashAlreadyClosedException>()));
  });
}
