import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:punto_venta_front/features/auth/ui/login_page.dart';
import 'package:punto_venta_front/features/auth/controllers/login_controller.dart';

class FakeLoginController extends LoginController {
  FakeLoginController(Ref ref, LoginState initialState) : super(ref) {
    state = initialState;
  }
}

void main() {
  testWidgets('button disabled when loading', (tester) async {
    final container = ProviderContainer(overrides: [
      loginControllerProvider.overrideWith(
          (ref) => FakeLoginController(ref, const LoginState(isLoading: true))),
    ]);
    await tester.pumpWidget(ProviderScope(
      parent: container,
      child: const MaterialApp(home: LoginPage()),
    ));
    final button = find.text('Ingresar');
    expect(tester.widget<ElevatedButton>(button).onPressed, isNull);
  });

  testWidgets('shows error message', (tester) async {
    final container = ProviderContainer(overrides: [
      loginControllerProvider.overrideWith(
          (ref) => FakeLoginController(ref, const LoginState(error: 'fail'))),
    ]);
    await tester.pumpWidget(ProviderScope(
      parent: container,
      child: const MaterialApp(home: LoginPage()),
    ));
    expect(find.text('fail'), findsOneWidget);
  });
}
