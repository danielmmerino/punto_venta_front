import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocktail/mocktail.dart';

import 'package:punto_venta_front/features/inventory/stock/controllers/stock_controller.dart';
import 'package:punto_venta_front/features/inventory/stock/data/stock_repository.dart';
import 'package:punto_venta_front/features/inventory/stock/data/models/stock_item.dart';

class MockStockRepository extends Mock implements StockRepository {}

void main() {
  group('StockController', () {
    test('passes filters to repository', () async {
      final repo = MockStockRepository();
      when(() => repo.list(any())).thenAnswer((_) async => [
            const StockItem(
              productoId: 1,
              codigo: 'A',
              nombre: 'Prod',
              unidadCodigo: 'u',
              stock: 1,
            )
          ]);
      final container = ProviderContainer(overrides: [
        stockRepositoryProvider.overrideWithValue(repo),
      ]);
      final controller = container.read(stockControllerProvider.notifier);
      await controller.load(bodegaId: 1, productoId: 2, soloConStock: true);
      verify(() => repo.list({
            'bodega_id': 1,
            'producto_id': 2,
            'stock_gt': 0,
          })).called(1);
    });
  });
}
