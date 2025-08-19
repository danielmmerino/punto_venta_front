import 'package:dio/dio.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../core/network/dio_client.dart';
import 'models/venta_hora.dart';
import 'models/producto_vendido.dart';
import 'models/caja_estado.dart';
import 'models/subscription_info.dart';

final dashboardRepositoryProvider = Provider<DashboardRepository>((ref) {
  final dio = ref.read(dioProvider);
  return DashboardRepository(dio);
});

class DashboardRepository {
  DashboardRepository(this._dio);

  final Dio _dio;
  SubscriptionInfo? _cachedSub;
  DateTime? _cachedAt;

  Future<List<VentaHora>> fetchVentasDia({
    required String fecha,
    required int localId,
  }) async {
    final resp = await _dio.get('/v1/reportes/ventas-dia',
        queryParameters: {'fecha': fecha, 'local_id': localId});
    final data = resp.data['data'] as List<dynamic>;
    return data
        .map((e) => VentaHora.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<ProductoVendido>> fetchTopProductos({
    required String desde,
    required String hasta,
    required int localId,
    int top = 5,
    String ordenarPor = 'monto',
  }) async {
    final resp = await _dio.get('/v1/reportes/productos-mas-vendidos',
        queryParameters: {
          'desde': desde,
          'hasta': hasta,
          'top': top,
          'local_id': localId,
          'ordenar_por': ordenarPor,
        });
    final data = resp.data['data'] as List<dynamic>;
    return data
        .map((e) => ProductoVendido.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<bool> isCajaAbierta(int localId) async {
    try {
      final resp = await _dio.get('/v1/caja/estado',
          queryParameters: {'local_id': localId});
      final caja = CajaEstado.fromJson(resp.data as Map<String, dynamic>);
      return caja.abierta;
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        final resp = await _dio.get('/v1/caja/aperturas', queryParameters: {
          'estado': 'abierta',
          'local_id': localId,
          'limit': 1,
        });
        final list = resp.data['data'] as List<dynamic>;
        return list.isNotEmpty;
      }
      rethrow;
    }
  }

  Future<SubscriptionInfo> fetchEstadoSuscripcion({required int localId}) async {
    final now = DateTime.now();
    if (_cachedSub != null &&
        _cachedAt != null &&
        now.difference(_cachedAt!).inMinutes < 5) {
      return _cachedSub!;
    }
    final resp = await _dio.get('/v1/estado-suscripcion',
        queryParameters: {'local_id': localId});
    final data = resp.data is Map<String, dynamic> &&
            resp.data.containsKey('data')
        ? resp.data['data'] as Map<String, dynamic>
        : resp.data as Map<String, dynamic>;
    final sub = SubscriptionInfo.fromJson(data);
    _cachedSub = sub;
    _cachedAt = now;
    return sub;
  }
}
