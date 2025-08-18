import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:punto_venta_front/features/_placeholders_/auth_blocked_page.dart';
import 'package:punto_venta_front/features/_placeholders_/subscription_blocked_page.dart';

void main() {
  testWidgets('AuthBlockedPage renders text', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: MaterialApp(home: AuthBlockedPage())));
    expect(find.text('Autenticación requerida'), findsOneWidget);
  });

  testWidgets('SubscriptionBlockedPage renders text', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: MaterialApp(home: SubscriptionBlockedPage())));
    expect(find.text('Suscripción inactiva'), findsOneWidget);
  });
}
