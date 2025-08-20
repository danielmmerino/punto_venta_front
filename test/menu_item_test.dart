import 'package:flutter_test/flutter_test.dart';

import 'package:punto_venta_front/features/orders/data/models/menu_item.dart';

void main() {
  test('parses menu item json with numeric strings', () {
    final item = MenuItem.fromJson({
      'id': 501,
      'codigo': 'BUR-CLAS',
      'nombre': 'Hamburguesa Clásica',
      'descripcion': '200g carne',
      'tipo': 'BIEN',
      'precio_venta': '5.50',
      'impuesto_id': 1,
      'categoria_nombre': 'Hamburguesas',
      'impuesto_codigo': 'IVA12',
      'impuesto_porcentaje': '15.000',
      'stock_local': '0.0000',
    });
    expect(item.id, 501);
    expect(item.precioVenta, 5.50);
    expect(item.impuestoPorcentaje, 15);
    expect(item.stockLocal, 0);
  });
}
