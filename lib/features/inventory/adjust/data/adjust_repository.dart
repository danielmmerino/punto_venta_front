import 'package:dio/dio.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/network/dio_client.dart';

final adjustRepositoryProvider = Provider<AdjustRepository>((ref) {
  final dio = ref.read(dioProvider);
  return AdjustRepository(dio);
});

class AdjustRepository {
  AdjustRepository(this._dio);
  final Dio _dio;
  final _uuid = const Uuid();

  Future<Map<String, dynamic>> create(
    Map<String, dynamic> dto, {
    required int bodegaId,
  }) async {
    final key = 'AJU-$bodegaId-${_uuid.v4()}';
    final resp = await _dio.post(
      '/v1/inventario/ajuste',
      data: dto,
      options: Options(headers: {'Idempotency-Key': key}),
    );
    return Map<String, dynamic>.from(resp.data as Map);
  }
}
