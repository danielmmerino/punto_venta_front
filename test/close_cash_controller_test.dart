import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocktail/mocktail.dart';

import 'package:punto_venta_front/features/cash/close/controllers/close_cash_controller.dart';
import 'package:punto_venta_front/features/cash/close/controllers/close_cash_state.dart';
import 'package:punto_venta_front/features/cash/common/cash_repository.dart';

class MockCashRepository extends Mock implements CashRepository {}

void main() {
  test('updateCount recalculates difference', () async {
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
    final container = ProviderContainer(overrides: [
      cashRepositoryProvider.overrideWithValue(repo),
    ]);
    final controller = container.read(closeCashControllerProvider.notifier);
    await controller.load(localId: 1);
    controller.updateCount(1, 120);
    final state = container.read(closeCashControllerProvider);
    expect(state.methods.first.diferencia, 20);
  });
}
