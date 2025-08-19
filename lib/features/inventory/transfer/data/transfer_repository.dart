import 'package:dio/dio.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/network/dio_client.dart';

final transferRepositoryProvider = Provider<TransferRepository>((ref) {
  final dio = ref.read(dioProvider);
  return TransferRepository(dio);
});

class TransferRepository {
  TransferRepository(this._dio);
  final Dio _dio;
  final _uuid = const Uuid();

  Future<Map<String, dynamic>> create(
    Map<String, dynamic> dto, {
    required int origen,
    required int destino,
  }) async {
    final key = 'TRA-$origen-$destino-${_uuid.v4()}';
    final resp = await _dio.post(
      '/v1/inventario/traspaso',
      data: dto,
      options: Options(headers: {'Idempotency-Key': key}),
    );
    return Map<String, dynamic>.from(resp.data as Map);
  }
}
