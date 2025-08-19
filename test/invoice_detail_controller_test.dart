import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:punto_venta_front/features/invoices/controllers/invoice_detail_controller.dart';
import 'package:punto_venta_front/features/invoices/controllers/invoice_detail_state.dart';
import 'package:punto_venta_front/features/invoices/data/invoices_repository.dart';
import 'package:punto_venta_front/features/invoices/data/models/invoice.dart';

class MockInvoicesRepository extends Mock implements InvoicesRepository {}

Invoice buildInvoice(String status) {
  return Invoice(
    id: 1,
    numero: '001',
    fechaEmision: DateTime.now(),
    cliente: const InvoiceCustomer(id: 1, identificacion: '123', nombre: 'A'),
    estadoSri: status,
    totales: const InvoiceTotals(
      subtotal: 0,
      descuento: 0,
      iva: 0,
      total: 0,
    ),
  );
}

void main() {
  test('polling stops when invoice becomes autorizada', () async {
    final repo = MockInvoicesRepository();
    when(() => repo.getInvoice(1))
        .thenAnswer((_) async => buildInvoice('enviada'))
        .thenAnswer((_) async => buildInvoice('autorizada'));
    final container = ProviderContainer(overrides: [
      invoicesRepositoryProvider.overrideWithValue(repo),
    ]);
    final controller =
        container.read(invoiceDetailControllerProvider.notifier);
    controller.startPolling(1,
        interval: const Duration(milliseconds: 10), maxAttempts: 5);
    await Future.delayed(const Duration(milliseconds: 50));
    final state = container.read(invoiceDetailControllerProvider);
    expect(state.isPolling, false);
    expect(state.invoice?.estadoSri, 'autorizada');
  });

  test('polling stops after maxAttempts', () async {
    final repo = MockInvoicesRepository();
    when(() => repo.getInvoice(1)).thenAnswer((_) async => buildInvoice('enviada'));
    final container = ProviderContainer(overrides: [
      invoicesRepositoryProvider.overrideWithValue(repo),
    ]);
    final controller =
        container.read(invoiceDetailControllerProvider.notifier);
    controller.startPolling(1,
        interval: const Duration(milliseconds: 10), maxAttempts: 3);
    await Future.delayed(const Duration(milliseconds: 50));
    final state = container.read(invoiceDetailControllerProvider);
    expect(state.isPolling, false);
  });
}
