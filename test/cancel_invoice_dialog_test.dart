import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:punto_venta_front/features/invoicing/ui/cancel_invoice_dialog.dart';
import 'package:punto_venta_front/features/invoicing/controllers/cancel_invoice_controller.dart';
import 'package:punto_venta_front/features/invoices/data/models/cancel_result.dart';
import 'package:punto_venta_front/core/theme/app_spacing.dart';
import 'package:punto_venta_front/core/theme/app_radius.dart';

class FakeController extends CancelInvoiceController {
  FakeController(Ref ref) : super(ref);

  @override
  Future<void> submit(int facturaId, String motivo) async {
    state = state.copyWith(
      result: CancelInvoiceResult(
        facturaId: facturaId,
        notaCreditoId: 2,
        ncNumero: '001-001-0001',
        estadoSri: 'enviada',
      ),
    );
  }
}

void main() {
  final theme = ThemeData(
    extensions: const [
      AppSpacing(xs: 4, sm: 8, md: 16, lg: 24, xl: 32, xxl: 40),
      AppRadius(sm: 4, md: 8, lg: 16, pill: 50),
    ],
  );

  testWidgets('shows result after submit', (tester) async {
    final container = ProviderContainer(overrides: [
      cancelInvoiceControllerProvider.overrideWith((ref) => FakeController(ref)),
    ]);
    await tester.pumpWidget(ProviderScope(
      parent: container,
      child: MaterialApp(
        theme: theme,
        home: MediaQuery(
          data: const MediaQueryData(size: Size(800, 600)),
          child: CancelInvoiceDialog(invoiceId: 1),
        ),
      ),
    ));
    await tester.enterText(find.byType(TextFormField), 'motivo valido 123');
    await tester.tap(find.text('Confirmar anulación'));
    await tester.pump();
    expect(find.text('NC generada'), findsOneWidget);
  });

  testWidgets('uses fullscreen dialog on narrow screens', (tester) async {
    final container = ProviderContainer(overrides: [
      cancelInvoiceControllerProvider.overrideWith((ref) => FakeController(ref)),
    ]);
    await tester.pumpWidget(ProviderScope(
      parent: container,
      child: MaterialApp(
        theme: theme,
        home: MediaQuery(
          data: const MediaQueryData(size: Size(400, 800)),
          child: CancelInvoiceDialog(invoiceId: 1),
        ),
      ),
    ));
    expect(find.byType(AppBar), findsOneWidget);
  });
}
