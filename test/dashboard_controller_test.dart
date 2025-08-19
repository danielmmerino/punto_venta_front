import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:punto_venta_front/features/dashboard/controllers/dashboard_controller.dart';
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
  }) async {
    return const [
      VentaHora(hora: '08', tickets: 5, ventasTotales: 100),
      VentaHora(hora: '09', tickets: 5, ventasTotales: 200),
    ];
  }

  @override
  Future<List<ProductoVendido>> fetchTopProductos({
    required String desde,
    required String hasta,
    required int localId,
    int top = 5,
    String ordenarPor = 'monto',
  }) async {
    return const [];
  }

  @override
  Future<bool> isCajaAbierta(int localId) async => false;

  @override
  Future<SubscriptionInfo> fetchEstadoSuscripcion() async {
    final futureDate = DateTime.now().add(const Duration(days: 5));
    return SubscriptionInfo(
      estado: 'active',
      trialEndsAt: null,
      nextRenewalAt: futureDate.toIso8601String(),
    );
  }
}

class FakeContextController extends ContextController {
  FakeContextController(Ref ref) : super(ref) {
    state = const ContextState(localId: 1);
  }
}

void main() {
  test('calculates totals and alerts', () async {
    final container = ProviderContainer(overrides: [
      dashboardRepositoryProvider.overrideWithValue(FakeDashboardRepository()),
      contextControllerProvider.overrideWith(
        (ref) => FakeContextController(ref),
      ),
    ]);
    final controller = container.read(dashboardControllerProvider.notifier);
    await controller.load();
    final state = container.read(dashboardControllerProvider);
    expect(state.ventasTotales, 300);
    expect(state.tickets, 10);
    expect(state.ticketPromedio, 30);
    // Alerts: caja no abierta and subscription expiring
    expect(state.alertas.length, 2);
  });
}
