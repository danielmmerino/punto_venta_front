import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:punto_venta_front/features/inventory/bodegas/data/bodegas_repository.dart';
import 'package:punto_venta_front/features/inventory/bodegas/data/models/bodega.dart';
import 'package:punto_venta_front/features/inventory/stock/data/stock_repository.dart';
import 'package:punto_venta_front/features/inventory/stock/data/models/stock_item.dart';
import 'package:punto_venta_front/features/inventory/stock/ui/stock_page.dart';
import 'package:punto_venta_front/features/products/data/models/product.dart';

class FakeBodegasRepository implements BodegasRepository {
  @override
  Future<Bodega> create(Map<String, dynamic> dto) async => throw UnimplementedError();

  @override
  Future<void> delete(int id) async => throw UnimplementedError();

  @override
  Future<List<Bodega>> list({Map<String, dynamic>? params}) async =>
      [const Bodega(id: 1, codigo: 'B1', nombre: 'Main', zona: null, activo: true)];

  @override
  Future<Bodega> update(int id, Map<String, dynamic> dto) async =>
      throw UnimplementedError();
}

class FakeStockRepository implements StockRepository {
  @override
  Future<List<StockItem>> list(Map<String, dynamic> params) async => [
        const StockItem(
          productoId: 1,
          codigo: 'P1',
          nombre: 'Producto',
          unidadCodigo: 'UND',
          stock: 5,
        )
      ];
}

void main() {
  testWidgets('consulta stock móvil/web', (tester) async {
    final overrides = [
      bodegasRepositoryProvider.overrideWithValue(FakeBodegasRepository()),
      stockRepositoryProvider.overrideWithValue(FakeStockRepository()),
      productsSearchProvider.overrideWith((ref, query) {
        return Future.value([
          Product(
            id: 1,
            codigo: 'P1',
            nombre: 'Producto',
            descripcion: null,
            categoriaId: 1,
            categoriaNombre: null,
            unidadId: 1,
            unidadCodigo: 'UND',
            impuestoId: 1,
            impuestoCodigo: null,
            precio: 1,
            activo: true,
          )
        ]);
      }),
    ];
    await tester.pumpWidget(
      ProviderScope(
        overrides: overrides,
        child: const MaterialApp(home: StockPage()),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byType(DropdownButton<Bodega>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Main').last);
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField).first, 'P1');
    await tester.pump();
    await tester.tap(find.text('P1 - Producto').first);
    await tester.pumpAndSettle();

    expect(find.text('Producto'), findsOneWidget);
  });
}
