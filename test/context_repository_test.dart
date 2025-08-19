import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:punto_venta_front/features/context/data/context_repository.dart';

class MockDio extends Mock implements Dio {}

void main() {
  test('fetchTenancyContext parses locales', () async {
    final dio = MockDio();
    when(() => dio.get('/v1/tenancy/context')).thenAnswer((_) async => Response(
          requestOptions: RequestOptions(path: '/v1/tenancy/context'),
          statusCode: 200,
          data: {
            'empresa_id': 1,
            'empresa_nombre': 'ACME',
            'suscripcion_estado': 'active',
            'locales': [
              {'id': 10, 'nombre': 'Matriz'}
            ],
          },
        ));
    final repo = ContextRepository(dio);
    final ctx = await repo.fetchTenancyContext();
    expect(ctx!.locales.first.id, 10);
    expect(ctx.locales.first.empresaId, 1);
  });

  test('checkSubscription interprets extended format', () async {
    final dio = MockDio();
    when(() => dio.get('/v1/estado-suscripcion',
            queryParameters: {'local_id': 10})).thenAnswer((_) async => Response(
          requestOptions: RequestOptions(path: '/v1/estado-suscripcion'),
          statusCode: 200,
          data: {
            'estado': 'active',
            'plan': {'codigo': 'pro'},
            'next_renewal_at': '2025-09-18'
          },
        ));
    final repo = ContextRepository(dio);
    final status = await repo.checkSubscription(localId: 10);
    expect(status.vigente, true);
    expect(status.fechaFin, '2025-09-18');
  });

  test('checkSubscription interprets direct format', () async {
    final dio = MockDio();
    when(() => dio.get('/v1/estado-suscripcion',
            queryParameters: {'local_id': 10})).thenAnswer((_) async => Response(
          requestOptions: RequestOptions(path: '/v1/estado-suscripcion'),
          statusCode: 200,
          data: {
            'estado': 'active',
            'vigente': true,
            'fecha_fin': '2025-09-18'
          },
        ));
    final repo = ContextRepository(dio);
    final status = await repo.checkSubscription(localId: 10);
    expect(status.vigente, true);
    expect(status.fechaFin, '2025-09-18');
  });
}
