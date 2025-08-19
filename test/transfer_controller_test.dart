import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:punto_venta_front/features/inventory/transfer/controllers/transfer_controller.dart';
import 'package:punto_venta_front/features/inventory/transfer/data/transfer_repository.dart';
import 'package:punto_venta_front/features/products/data/models/product.dart';

class FakeTransferRepository implements TransferRepository {
  Map<String, dynamic>? lastDto;

  @override
  Future<Map<String, dynamic>> create(Map<String, dynamic> dto,
      {required int origen, required int destino}) async {
    lastDto = dto;
    return {'traspaso_id': 1};
  }
}

void main() {
  test('origen distinto y cantidades > 0', () async {
    final repo = FakeTransferRepository();
    final container = ProviderContainer(overrides: [
      transferRepositoryProvider.overrideWithValue(repo),
    ]);
    final controller = container.read(transferControllerProvider.notifier);
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
            activo: true));
    controller.updateQuantity(0, 3);
    final ok = await controller.submit(origen: 1, destino: 2);
    expect(ok, true);
    expect(repo.lastDto?['items'], [
      {'producto_id': 1, 'cantidad': 3}
    ]);
  });

  test('valida bodegas distintas', () async {
    final repo = FakeTransferRepository();
    final container = ProviderContainer(overrides: [
      transferRepositoryProvider.overrideWithValue(repo),
    ]);
    final controller = container.read(transferControllerProvider.notifier);
    final ok = await controller.submit(origen: 1, destino: 1);
    expect(ok, false);
    expect(controller.state.fieldErrors.containsKey('bodegas'), true);
  });
}
