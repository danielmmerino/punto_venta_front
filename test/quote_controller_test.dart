import 'package:flutter_test/flutter_test.dart';
import 'package:uuid/uuid.dart';

import 'package:punto_venta_front/features/quotes/controllers/quote_controller.dart';
import 'package:punto_venta_front/features/quotes/data/models/quote.dart';

void main() {
  group('Quote totals', () {
    test('calculates subtotal, discount and total', () {
      final quote = Quote(
        clienteId: 1,
        validezDias: 30,
        items: [
          QuoteItem(productoId: 1, cantidad: 2, precio: 10, descuento: 0.1),
          QuoteItem(productoId: 2, cantidad: 1, precio: 5),
        ],
      );
      expect(quote.subtotal, 25);
      expect(quote.descuento, 2);
      expect(quote.total, 23);
    });
  });

  group('Quote transitions', () {
    test('send -> accept -> invoice', () {
      final controller = QuoteController(
        Quote(clienteId: 1, validezDias: 30, items: [
          QuoteItem(productoId: 1, cantidad: 1, precio: 1),
        ]),
        uuid: const Uuid(),
      );
      controller.enviar();
      expect(controller.quote.estado, QuoteStatus.sent);
      controller.aceptar();
      expect(controller.quote.estado, QuoteStatus.accepted);
      final id = controller.facturar();
      expect(id, 'INV-1');
    });

    test('send -> reject', () {
      final controller = QuoteController(
        Quote(clienteId: 1, validezDias: 30, items: [
          QuoteItem(productoId: 1, cantidad: 1, precio: 1),
        ]),
      );
      controller.enviar();
      controller.rechazar();
      expect(controller.quote.estado, QuoteStatus.rejected);
    });
  });

  test('idempotency keys', () {
    final uuid = const Uuid();
    final controller = QuoteController(
      Quote(clienteId: 1, validezDias: 30),
      uuid: uuid,
    );
    final sendKey = controller.idempotencyKey('SEND', 10);
    expect(sendKey, startsWith('QTE-10-SEND-'));
    expect(controller.idempotencyKey('ACC', 10), 'QTE-10-ACC');
    expect(controller.idempotencyKey('REJ', 10), 'QTE-10-REJ');
    expect(controller.idempotencyKey('FAC', 10), 'QTE-10-FAC');
  });
}
