import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:punto_venta_front/features/inventory/adjust/ui/adjust_page.dart';
import 'package:punto_venta_front/features/inventory/bodegas/data/bodegas_repository.dart';
import 'package:punto_venta_front/features/inventory/bodegas/data/models/bodega.dart';

class FakeBodegasRepository implements BodegasRepository {
  @override
  Future<Bodega> create(Map<String, dynamic> dto) async =>
      throw UnimplementedError();

  @override
  Future<void> delete(int id) async {}

  @override
  Future<List<Bodega>> list({Map<String, dynamic>? params}) async => [
        Bodega(id: 1, codigo: 'B1', nombre: 'Bodega', zona: null, activo: true)
      ];

  @override
  Future<Bodega> update(int id, Map<String, dynamic> dto) async =>
      throw UnimplementedError();
}

void main() {
  testWidgets('agregar y eliminar líneas', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          bodegasRepositoryProvider.overrideWithValue(FakeBodegasRepository()),
        ],
        child: const MaterialApp(home: Scaffold(body: AdjustPage())),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byIcon(Icons.delete), findsNothing);
    await tester.tap(find.text('Agregar línea'));
    await tester.pump();
    expect(find.byIcon(Icons.delete), findsOneWidget);
    await tester.tap(find.byIcon(Icons.delete));
    await tester.pump();
    expect(find.byIcon(Icons.delete), findsNothing);
  });
}
