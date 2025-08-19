import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:punto_venta_front/features/inventory/bodegas/controllers/bodegas_controller.dart';
import 'package:punto_venta_front/features/inventory/bodegas/data/bodegas_repository.dart';
import 'package:punto_venta_front/features/inventory/bodegas/data/models/bodega.dart';
import 'package:punto_venta_front/features/inventory/bodegas/ui/bodegas_page.dart';

class FakeBodegasRepository implements BodegasRepository {
  FakeBodegasRepository(this.items);

  List<Bodega> items;

  @override
  Future<Bodega> create(Map<String, dynamic> dto) async {
    final bodega = Bodega(
      id: items.length + 1,
      codigo: dto['codigo'] as String,
      nombre: dto['nombre'] as String,
      zona: dto['zona'] as String?,
      activo: dto['activo'] as bool? ?? true,
    );
    items.add(bodega);
    return bodega;
  }

  @override
  Future<void> delete(int id) async {
    items.removeWhere((b) => b.id == id);
  }

  @override
  Future<List<Bodega>> list({Map<String, dynamic>? params}) async {
    return items;
  }

  @override
  Future<Bodega> update(int id, Map<String, dynamic> dto) async {
    final idx = items.indexWhere((b) => b.id == id);
    final bodega = Bodega(
      id: id,
      codigo: dto['codigo'] as String,
      nombre: dto['nombre'] as String,
      zona: dto['zona'] as String?,
      activo: dto['activo'] as bool? ?? true,
    );
    items[idx] = bodega;
    return bodega;
  }
}

void main() {
  testWidgets('crear/editar/eliminar bodega', (tester) async {
    final repo = FakeBodegasRepository([]);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [bodegasRepositoryProvider.overrideWithValue(repo)],
        child: const MaterialApp(home: BodegasPage()),
      ),
    );
    await tester.pumpAndSettle();

    // Crear
    await tester.tap(find.text('Nueva bodega'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField).at(0), 'COD');
    await tester.enterText(find.byType(TextFormField).at(1), 'Nombre');
    await tester.tap(find.text('Guardar'));
    await tester.pumpAndSettle();
    expect(find.text('Nombre'), findsOneWidget);

    // Editar
    await tester.tap(find.text('Nombre'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField).at(1), 'Editado');
    await tester.tap(find.text('Guardar'));
    await tester.pumpAndSettle();
    expect(find.text('Editado'), findsOneWidget);

    // Eliminar
    await tester.tap(find.byIcon(Icons.delete));
    await tester.pumpAndSettle();
    expect(find.text('Editado'), findsNothing);
  });
}
