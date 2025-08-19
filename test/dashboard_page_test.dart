import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:punto_venta_front/features/dashboard/ui/dashboard_page.dart';
import 'package:punto_venta_front/features/dashboard/data/dashboard_repository.dart';
import 'package:punto_venta_front/features/dashboard/data/models/venta_hora.dart';
import 'package:punto_venta_front/features/dashboard/data/models/producto_vendido.dart';
import 'package:punto_venta_front/features/dashboard/data/models/subscription_info.dart';
import 'package:punto_venta_front/features/context/controllers/context_controller.dart';

class FakeDashboardRepository implements DashboardRepository {
  @override
  Future<List<VentaHora>> fetchVentasDia({
    required String fecha,
    required int localId,
  }) async => const [];

  @override
  Future<List<ProductoVendido>> fetchTopProductos({
    required String desde,
    required String hasta,
    required int localId,
    int top = 5,
    String ordenarPor = 'monto',
  }) async => const [];

  @override
  Future<bool> isCajaAbierta(int localId) async => true;

  @override
  Future<SubscriptionInfo> fetchEstadoSuscripcion() async =>
      const SubscriptionInfo(estado: 'active');
}

class FakeContextController extends StateNotifier<ContextState> {
  FakeContextController() : super(const ContextState(localId: 1));
}

void main() {
  testWidgets('DashboardPage shows title', (tester) async {
    await tester.pumpWidget(ProviderScope(
      overrides: [
        dashboardRepositoryProvider.overrideWithValue(FakeDashboardRepository()),
        contextControllerProvider.overrideWith((ref) => FakeContextController()),
      ],
      child: const MaterialApp(home: DashboardPage()),
    ));
    await tester.pump();
    expect(find.text('Dashboard'), findsOneWidget);
  });
}
