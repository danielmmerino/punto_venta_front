import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:punto_venta_front/features/invoices/data/invoices_repository.dart';

class MockDio extends Mock implements Dio {}

void main() {
  setUpAll(() {
    registerFallbackValue(Options());
  });

  test('getInvoice falls back to legacy path on 404', () async {
    final dio = MockDio();
    when(() => dio.request('/v1/facturas/1',
            data: null, options: any(named: 'options')))
        .thenThrow(DioException(
            requestOptions: RequestOptions(path: '/v1/facturas/1'),
            response: Response(
                requestOptions: RequestOptions(path: '/v1/facturas/1'),
                statusCode: 404)));
    when(() => dio.request('/v1/ventas/facturas/1',
            data: null, options: any(named: 'options')))
        .thenAnswer((_) async => Response(
              requestOptions: RequestOptions(path: '/v1/ventas/facturas/1'),
              statusCode: 200,
              data: {
                'id': 1,
                'numero': '001',
                'estado_sri': 'pendiente',
                'totales': {
                  'subtotal': 0,
                  'descuento': 0,
                  'iva': 0,
                  'total': 0,
                }
              },
            ));
    final repo = InvoicesRepository(dio);
    final invoice = await repo.getInvoice(1);
    expect(invoice.id, 1);
    final primaryVerification = verify(() => dio.request('/v1/facturas/1',
        data: null, options: captureAny(named: 'options')));
    primaryVerification.called(1);
    final primaryOptions = primaryVerification.captured.first as Options;
    expect(primaryOptions.method, 'GET');
    final fallbackVerification = verify(() => dio.request('/v1/ventas/facturas/1',
        data: null, options: captureAny(named: 'options')));
    fallbackVerification.called(1);
    final fallbackOptions = fallbackVerification.captured.first as Options;
    expect(fallbackOptions.method, 'GET');
  });

  test('emit adds Idempotency-Key header', () async {
    final dio = MockDio();
    when(() => dio.request('/v1/facturas/1/emitir',
            data: null, options: any(named: 'options')))
        .thenAnswer((invocation) async {
      return Response(
        requestOptions: RequestOptions(path: '/v1/facturas/1/emitir'),
        statusCode: 200,
        data: {'estado_sri': 'enviada'},
      );
    });
    final repo = InvoicesRepository(dio);
    final status = await repo.emit(1);
    expect(status, 'enviada');
    final verification = verify(() => dio.request('/v1/facturas/1/emitir',
            data: null, options: captureAny(named: 'options')));
    verification.called(1);
    final captured = verification.captured.first as Options;
    final key = captured.headers?['Idempotency-Key'] as String?;
    expect(key, isNotNull);
    expect(key, startsWith('EMIT-1-'));
    expect(captured.method, 'POST');
  });

  test('cancel adds Idempotency-Key header', () async {
    final dio = MockDio();
    when(() => dio.request('/v1/facturas/1/anular',
            data: any(named: 'data'),
            options: any(named: 'options')))
        .thenAnswer((_) async => Response(
              requestOptions: RequestOptions(path: '/v1/facturas/1/anular'),
              statusCode: 200,
              data: {
                'factura_id': 1,
                'nota_credito_id': 2,
                'estado_sri': 'enviada',
              },
            ));
    final repo = InvoicesRepository(dio);
    await repo.cancel(1, 'motivo valido 123');
    final verification = verify(() => dio.request('/v1/facturas/1/anular',
            data: any(named: 'data'),
            options: captureAny(named: 'options')));
    verification.called(1);
    final captured = verification.captured.first as Options;
    final key = captured.headers?['Idempotency-Key'] as String?;
    expect(key, isNotNull);
    expect(key, startsWith('NC-1-'));
    expect(captured.method, 'POST');
  });
}
