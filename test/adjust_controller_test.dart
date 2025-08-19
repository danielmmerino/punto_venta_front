import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:punto_venta_front/features/inventory/adjust/controllers/adjust_controller.dart';
import 'package:punto_venta_front/features/inventory/adjust/data/adjust_repository.dart';
import 'package:punto_venta_front/features/products/data/models/product.dart';

class FakeAdjustRepository implements AdjustRepository {
  Map<String, dynamic>? lastDto;

  @override
  Future<Map<String, dynamic>> create(Map<String, dynamic> dto,
      {required int bodegaId}) async {
    lastDto = dto;
    return {'ajuste_id': 1};
  }
}

void main() {
  test('payload por línea y validaciones', () async {
    final fakeRepo = FakeAdjustRepository();
    final container = ProviderContainer(overrides: [
      adjustRepositoryProvider.overrideWithValue(fakeRepo),
    ]);
    final controller = container.read(adjustControllerProvider.notifier);
    controller.addLine();
    controller.updateProduct(
      0,
      Product(
        id: 1,
        codigo: 'P1',
        nombre: 'Prod',
        descripcion: null,
        categoriaId: 1,
        categoriaNombre: null,
        unidadId: 1,
        unidadCodigo: null,
        impuestoId: 1,
        impuestoCodigo: null,
        precio: 0,
        activo: true,
      ),
    );
    controller.updateQuantity(0, -2);
    controller.updateCost(0, 5);
    final ok = await controller.submit(bodegaId: 1, motivo: 'Test');
    expect(ok, true);
    expect(fakeRepo.lastDto?['items'], [
      {'producto_id': 1, 'cantidad': -2, 'costo': 5}
    ]);
  });

  test('reglas de validacion', () async {
    final fakeRepo = FakeAdjustRepository();
    final container = ProviderContainer(overrides: [
      adjustRepositoryProvider.overrideWithValue(fakeRepo),
    ]);
    final controller = container.read(adjustControllerProvider.notifier);
    final ok = await controller.submit(bodegaId: 1, motivo: '');
    expect(ok, false);
    expect(controller.state.fieldErrors.containsKey('motivo'), true);
  });
}
