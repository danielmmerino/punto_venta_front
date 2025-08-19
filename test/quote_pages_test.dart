import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:punto_venta_front/features/quotes/controllers/quote_controller.dart';
import 'package:punto_venta_front/features/quotes/data/models/quote.dart';
import 'package:punto_venta_front/features/quotes/ui/quote_detail_page.dart';
import 'package:punto_venta_front/features/quotes/ui/quotes_page.dart';

void main() {
  testWidgets('flow send -> accept -> invoice', (tester) async {
    final controller = QuoteController(
      Quote(clienteId: 1, validezDias: 30, items: [
        QuoteItem(productoId: 1, cantidad: 1, precio: 1),
      ]),
    );
    await tester.pumpWidget(MaterialApp(home: QuoteDetailPage(controller: controller)));
    await tester.tap(find.text('Enviar'));
    await tester.pump();
    expect(find.textContaining('sent'), findsOneWidget);
    await tester.tap(find.text('Aceptar'));
    await tester.pump();
    expect(find.textContaining('accepted'), findsOneWidget);
    await tester.tap(find.text('Facturar'));
    await tester.pump();
    expect(controller.facturar, isNotNull);
  });

  testWidgets('flow send -> reject', (tester) async {
    final controller = QuoteController(
      Quote(clienteId: 1, validezDias: 30, items: [
        QuoteItem(productoId: 1, cantidad: 1, precio: 1),
      ]),
    );
    await tester.pumpWidget(MaterialApp(home: QuoteDetailPage(controller: controller)));
    await tester.tap(find.text('Enviar'));
    await tester.pump();
    await tester.tap(find.text('Rechazar'));
    await tester.pump();
    expect(find.textContaining('rejected'), findsOneWidget);
  });

  testWidgets('quotes page builds mobile and web', (tester) async {
    await tester.binding.setSurfaceSize(const Size(400, 800));
    await tester.pumpWidget(const MaterialApp(home: QuotesPage()));
    expect(find.text('Cotizaciones'), findsOneWidget);
    await tester.binding.setSurfaceSize(const Size(1200, 800));
    await tester.pumpWidget(const MaterialApp(home: QuotesPage()));
    expect(find.text('Cotizaciones'), findsOneWidget);
  });
}
