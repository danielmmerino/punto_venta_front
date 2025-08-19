import 'package:flutter_test/flutter_test.dart';

import 'package:punto_venta_front/features/purchase/controllers/purchase_controller.dart';
import 'package:punto_venta_front/features/purchase/data/models/purchase.dart';

void main() {
  group('Purchase totals', () {
    test('calculates subtotal, iva and total', () {
      final purchase = Purchase(
        proveedorId: 1,
        bodegaId: 1,
        fecha: DateTime(2025, 8, 18),
        items: [
          PurchaseItem(
            productoId: 1,
            cantidad: 10,
            costo: 3.20,
            impuesto: 0.12,
          ),
        ],
      );
      expect(purchase.subtotal, 32.0);
      expect(purchase.iva, 3.84);
      expect(purchase.total, 35.84);
    });
  });

  group('PurchaseController', () {
    test('cannot approve without lines', () {
      final controller = PurchaseController();
      expect(controller.canApprove, isFalse);
      expect(controller.approve, throwsStateError);
    });

    test('can approve with at least one line', () {
      final controller = PurchaseController(
        items: [
          PurchaseItem(
            productoId: 1,
            cantidad: 1,
            costo: 1,
          ),
        ],
      );
      expect(controller.canApprove, isTrue);
      expect(controller.approve, isNot(throwsStateError));
    });
  });
}
