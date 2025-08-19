import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

import '../../context/controllers/context_controller.dart';
import '../data/dashboard_repository.dart';
import '../data/models/producto_vendido.dart';

class DashboardAlert {
  DashboardAlert({required this.message, required this.type});
  final String message;
  final AlertType type;
}

enum AlertType { warning, error }

class DashboardState {
  const DashboardState({
    this.isLoading = false,
    this.error,
    this.ventasTotales = 0,
    this.tickets = 0,
    this.ticketPromedio = 0,
    this.productos = const [],
    this.alertas = const [],
  });

  final bool isLoading;
  final String? error;
  final double ventasTotales;
  final int tickets;
  final double ticketPromedio;
  final List<ProductoVendido> productos;
  final List<DashboardAlert> alertas;

  DashboardState copyWith({
    bool? isLoading,
    String? error,
    double? ventasTotales,
    int? tickets,
    double? ticketPromedio,
    List<ProductoVendido>? productos,
    List<DashboardAlert>? alertas,
  }) =>
      DashboardState(
        isLoading: isLoading ?? this.isLoading,
        error: error,
        ventasTotales: ventasTotales ?? this.ventasTotales,
        tickets: tickets ?? this.tickets,
        ticketPromedio: ticketPromedio ?? this.ticketPromedio,
        productos: productos ?? this.productos,
        alertas: alertas ?? this.alertas,
      );
}

final dashboardControllerProvider =
    StateNotifierProvider<DashboardController, DashboardState>((ref) {
  return DashboardController(ref);
});

class DashboardController extends StateNotifier<DashboardState> {
  DashboardController(this._ref) : super(const DashboardState());

  final Ref _ref;

  Future<void> load() async {
    if (state.isLoading) return;
    state = state.copyWith(isLoading: true, error: null);
    try {
      final ctx = _ref.read(contextControllerProvider);
      final localId = ctx.localId;
      if (localId == null) {
        throw Exception('Local no seleccionado');
      }
      final repo = _ref.read(dashboardRepositoryProvider);
      final now = DateTime.now().toUtc().subtract(const Duration(hours: 5));
      final hoy = DateFormat('yyyy-MM-dd').format(now);
      final desde = '$hoy 00:00:00';
      final hasta = '$hoy 23:59:59';

      final ventas = await repo.fetchVentasDia(fecha: hoy, localId: localId);
      final productos =
          await repo.fetchTopProductos(desde: desde, hasta: hasta, localId: localId);
      final cajaAbierta = await repo.isCajaAbierta(localId);
      final sub = await repo.fetchEstadoSuscripcion(localId: localId);

      final ventasTotales = ventas
          .fold<double>(0, (sum, e) => sum + e.ventasTotales);
      final tickets = ventas.fold<int>(0, (sum, e) => sum + e.tickets);
      final ticketPromedio =
          ventasTotales / (tickets == 0 ? 1 : tickets);

      final alertas = <DashboardAlert>[];
      if (!cajaAbierta) {
        alertas.add(DashboardAlert(
            type: AlertType.error,
            message: 'Abre tu caja para registrar ventas'));
      }
      DateTime? trial =
          sub.trialEndsAt != null ? DateTime.tryParse(sub.trialEndsAt!) : null;
      DateTime? renewal =
          sub.nextRenewalAt != null ? DateTime.tryParse(sub.nextRenewalAt!) : null;
      DateTime? minDate;
      if (trial != null && renewal != null) {
        minDate = trial.isBefore(renewal) ? trial : renewal;
      } else {
        minDate = trial ?? renewal;
      }
      if (minDate != null) {
        final days = minDate.difference(DateTime.now()).inDays;
        if (days <= 7) {
          alertas.add(DashboardAlert(
              type: AlertType.warning,
              message: 'Tu suscripción vence en $days días'));
        }
      }

      state = state.copyWith(
        ventasTotales: ventasTotales,
        tickets: tickets,
        ticketPromedio: ticketPromedio,
        productos: productos,
        alertas: alertas,
      );
    } catch (_) {
      state = state.copyWith(error: 'No se pudo cargar');
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }
}
