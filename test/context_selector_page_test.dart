import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:punto_venta_front/features/context/controllers/context_controller.dart';
import 'package:punto_venta_front/features/context/ui/context_selector_page.dart';
import 'package:punto_venta_front/features/context/data/local.dart';

class DummyController extends ContextController {
  DummyController(Ref ref, ContextState initial) : super(ref) {
    state = initial;
  }

  @override
  Future<void> loadContext() async {}

  @override
  Future<void> selectLocal(int localId) async {}
}

void main() {
  testWidgets('grid adapts to narrow width', (tester) async {
    tester.view.physicalSize = const Size(360, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(ProviderScope(
      overrides: [
        contextControllerProvider.overrideWith((ref) => DummyController(
            ref,
            const ContextState(locales: [
              Local(id: 1, nombre: 'A', empresaId: 1),
              Local(id: 2, nombre: 'B', empresaId: 1)
            ]))),
      ],
      child: const MaterialApp(home: ContextSelectorPage()),
    ));
    await tester.pumpAndSettle();
    final first = tester.getTopLeft(find.byKey(const Key('local-1')));
    final second = tester.getTopLeft(find.byKey(const Key('local-2')));
    expect(second.dy, greaterThan(first.dy));
  });

  testWidgets('grid adapts to wide width', (tester) async {
    tester.view.physicalSize = const Size(1024, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(ProviderScope(
      overrides: [
        contextControllerProvider.overrideWith((ref) => DummyController(
            ref,
            const ContextState(locales: [
              Local(id: 1, nombre: 'A', empresaId: 1),
              Local(id: 2, nombre: 'B', empresaId: 1)
            ]))),
      ],
      child: const MaterialApp(home: ContextSelectorPage()),
    ));
    await tester.pumpAndSettle();
    final first = tester.getTopLeft(find.byKey(const Key('local-1')));
    final second = tester.getTopLeft(find.byKey(const Key('local-2')));
    expect(second.dy, equals(first.dy));
  });
}
