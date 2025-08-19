import 'package:dio/dio.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/network/dio_client.dart';
import 'models/bodega.dart';

final bodegasRepositoryProvider = Provider<BodegasRepository>((ref) {
  final dio = ref.read(dioProvider);
  return BodegasRepository(dio);
});

class BodegasRepository {
  BodegasRepository(this._dio);

  final Dio _dio;

  Future<List<Bodega>> list({Map<String, dynamic>? params}) async {
    final resp = await _dio.get('/v1/bodegas', queryParameters: params);
    final data = resp.data;
    final list = data is List ? data : data['data'] as List<dynamic>;
    return list
        .map((e) => Bodega.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  Future<Bodega> create(Map<String, dynamic> dto) async {
    final resp = await _dio.post('/v1/bodegas', data: dto);
    return Bodega.fromJson(Map<String, dynamic>.from(resp.data));
  }

  Future<Bodega> update(int id, Map<String, dynamic> dto) async {
    final resp = await _dio.put('/v1/bodegas/$id', data: dto);
    return Bodega.fromJson(Map<String, dynamic>.from(resp.data));
  }

  Future<void> delete(int id) async {
    await _dio.delete('/v1/bodegas/$id');
  }
}
