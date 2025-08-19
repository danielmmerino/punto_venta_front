import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocktail/mocktail.dart';

import 'package:punto_venta_front/features/cash/close/ui/close_cash_page.dart';
import 'package:punto_venta_front/features/cash/close/controllers/close_cash_controller.dart';
import 'package:punto_venta_front/features/cash/close/ui/method_count_row.dart';
import 'package:punto_venta_front/features/cash/common/cash_repository.dart';

class MockCashRepository extends Mock implements CashRepository {}

void main() {
  testWidgets('close flow shows acta with PDF button', (tester) async {
    final repo = MockCashRepository();
    when(() => repo.getStatus(localId: any(named: 'localId'), fecha: any(named: 'fecha')))
        .thenAnswer((_) async => CashStatus(
              abierta: true,
              aperturaId: 1,
              operador: const Operator(id: 1, nombre: 'Isabel'),
              desde: DateTime.now(),
              fondoInicial: 0,
              totalesPorMetodo: [
                MethodExpected(
                    metodoId: 1,
                    codigo: 'efectivo',
                    nombre: 'Efectivo',
                    esperado: 100)
              ],
            ));
    when(() => repo.closeCash(aperturaId: any(named: 'aperturaId'), conteos: any(named: 'conteos'), observaciones: any(named: 'observaciones')))
        .thenAnswer((_) async => CloseCashResponse(cierreId: 1, pdfUrl: 'http://pdf')); 

    final container = ProviderContainer(overrides: [
      cashRepositoryProvider.overrideWithValue(repo),
    ]);
    final controller = container.read(closeCashControllerProvider.notifier);
    await controller.load(localId: 1);

    await tester.pumpWidget(UncontrolledProviderScope(
      container: container,
      child: const MaterialApp(home: CloseCashPage()),
    ));

    expect(find.byType(MethodCountRow), findsOneWidget);
    await tester.tap(find.text('Cerrar caja'));
    await tester.pumpAndSettle();
    expect(find.text('Imprimir'), findsOneWidget);
    expect(find.text('Descargar PDF'), findsOneWidget);
  });
}
