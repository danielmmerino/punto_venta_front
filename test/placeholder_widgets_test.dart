import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:punto_venta_front/features/_placeholders_/subscription_blocked_page.dart';
import 'package:punto_venta_front/features/_placeholders_/dashboard_page.dart';
import 'package:punto_venta_front/features/_placeholders_/selector_local_page.dart';

void main() {
  testWidgets('SubscriptionBlockedPage renders text', (tester) async {
    await tester.pumpWidget(const ProviderScope(
        child: MaterialApp(home: SubscriptionBlockedPage())));
    expect(find.text('Suscripción inactiva'), findsOneWidget);
  });

  testWidgets('DashboardPage renders text', (tester) async {
    await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: DashboardPage())));
    expect(find.text('Dashboard'), findsOneWidget);
  });

  testWidgets('SelectorLocalPage renders text', (tester) async {
    await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: SelectorLocalPage())));
    expect(find.text('Selector de Local'), findsOneWidget);
  });
}
