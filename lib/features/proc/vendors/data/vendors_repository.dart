import 'package:dio/dio.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/network/dio_client.dart';
import 'models/vendor.dart';

final vendorsRepositoryProvider = Provider<VendorsRepository>((ref) {
  final dio = ref.read(dioProvider);
  return VendorsRepository(dio);
});

class VendorsRepository {
  VendorsRepository(this._dio);

  final Dio _dio;

  Future<List<Vendor>> fetch({Map<String, dynamic>? params}) async {
    final resp = await _dio.get('/v1/proveedores', queryParameters: params);
    final data = resp.data;
    final list = data is List ? data : data['data'] as List<dynamic>;
    return list
        .map((e) => Vendor.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  Future<Vendor> create(Map<String, dynamic> dto) async {
    final resp = await _dio.post('/v1/proveedores', data: dto);
    return Vendor.fromJson(Map<String, dynamic>.from(resp.data));
  }

  Future<Vendor> update(int id, Map<String, dynamic> dto) async {
    final resp = await _dio.put('/v1/proveedores/$id', data: dto);
    return Vendor.fromJson(Map<String, dynamic>.from(resp.data));
  }

  Future<void> delete(int id) async {
    await _dio.delete('/v1/proveedores/$id');
  }

  Map<String, List<String>> map422(DioException e) {
    final details = e.response?.data['details'] as Map<String, dynamic>?;
    if (details == null) return {};
    return details.map(
        (key, value) => MapEntry(key, List<String>.from(value as List)));
  }
}
