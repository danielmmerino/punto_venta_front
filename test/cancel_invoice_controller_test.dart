import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocktail/mocktail.dart';

import 'package:punto_venta_front/features/invoicing/controllers/cancel_invoice_controller.dart';
import 'package:punto_venta_front/features/invoices/data/invoices_repository.dart';

class MockInvoicesRepository extends Mock implements InvoicesRepository {}

void main() {
  test('validateMotivo works', () {
    expect(validateMotivo(''), isNotNull);
    expect(validateMotivo('short'), isNotNull);
    expect(validateMotivo('a' * 205), isNotNull);
    expect(validateMotivo('motivo valido 123'), isNull);
  });

  test('handles 409 and 422 errors', () async {
    final repo = MockInvoicesRepository();
    when(() => repo.cancel(1, any())).thenThrow(DioException(
      requestOptions: RequestOptions(path: ''),
      response:
          Response(requestOptions: RequestOptions(path: ''), statusCode: 409),
    ));
    final container = ProviderContainer(overrides: [
      invoicesRepositoryProvider.overrideWithValue(repo),
    ]);
    final controller =
        container.read(cancelInvoiceControllerProvider.notifier);
    await controller.submit(1, 'motivo valido 123');
    expect(container.read(cancelInvoiceControllerProvider).error,
        'Factura ya anulada');

    when(() => repo.cancel(1, any())).thenThrow(DioException(
      requestOptions: RequestOptions(path: ''),
      response: Response(
          requestOptions: RequestOptions(path: ''),
          statusCode: 422,
          data: {'message': 'no permitido'}),
    ));
    await controller.submit(1, 'motivo valido 123');
    expect(container.read(cancelInvoiceControllerProvider).error,
        'no permitido');
  });
}
