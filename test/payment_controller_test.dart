import 'package:flutter_test/flutter_test.dart';

import 'package:punto_venta_front/features/ap/cxp/controllers/payment_controller.dart';

void main() {
  group('PaymentController', () {
    test('rejects amount greater than balance', () {
      final controller = PaymentController();
      expect(controller.canPay(saldo: 100, monto: 150), isFalse);
    });

    test('rejects amount less than 0.01', () {
      final controller = PaymentController();
      expect(controller.canPay(saldo: 100, monto: 0), isFalse);
    });

    test('accepts valid amount', () {
      final controller = PaymentController();
      expect(controller.canPay(saldo: 100, monto: 50), isTrue);
    });
  });
}
