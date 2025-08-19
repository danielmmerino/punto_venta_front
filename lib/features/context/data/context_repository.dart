import 'package:dio/dio.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../core/network/dio_client.dart';
import 'tenancy_context.dart';
import 'local.dart';
import 'subscription_status.dart';

final contextRepositoryProvider = Provider<ContextRepository>((ref) {
  final dio = ref.read(dioProvider);
  return ContextRepository(dio);
});

class ContextRepository {
  ContextRepository(this._dio);

  final Dio _dio;

  Future<TenancyContext?> fetchTenancyContext() async {
    final resp = await _dio.get('/v1/tenancy/context');
    if (resp.statusCode == 200) {
      return TenancyContext.fromJson(resp.data as Map<String, dynamic>);
    }
    return null;
  }

  Future<List<Local>> fetchUserLocales() async {
    final resp = await _dio.get('/v1/locales', queryParameters: {'mine': 1});
    if (resp.statusCode == 200) {
      final data = resp.data['data'] as List<dynamic>;
      return data.map((e) => Local.fromJson(e as Map<String, dynamic>)).toList();
    }
    return [];
  }

  Future<SubscriptionStatus> checkSubscription({int? localId}) async {
    try {
      final resp = await _dio.get('/v1/estado-suscripcion',
          queryParameters: localId != null ? {'local_id': localId} : null);
      return SubscriptionStatus.fromJson(resp.data as Map<String, dynamic>);
    } on DioException catch (e) {
      if (e.response?.statusCode == 400 || e.response?.statusCode == 404) {
        final resp = await _dio.get('/v1/estado-suscripcion');
        return SubscriptionStatus.fromJson(resp.data as Map<String, dynamic>);
      }
      rethrow;
    }
  }
}
