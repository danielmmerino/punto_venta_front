import 'package:flutter_test/flutter_test.dart';

import 'package:punto_venta_front/features/inventory/stock/data/models/stock_item.dart';

void main() {
  test('parses stock item json', () {
    final item = StockItem.fromJson({
      'producto_id': 1,
      'codigo': 'P1',
      'nombre': 'Producto',
      'unidad_codigo': 'UND',
      'stock': 5,
      'reservado': 2,
      'disponible': 3,
    });
    expect(item.productoId, 1);
    expect(item.codigo, 'P1');
    expect(item.nombre, 'Producto');
    expect(item.unidadCodigo, 'UND');
    expect(item.stock, 5);
    expect(item.reservado, 2);
    expect(item.disponible, 3);
  });
}
