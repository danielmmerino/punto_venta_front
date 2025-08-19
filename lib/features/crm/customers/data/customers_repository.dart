import 'package:dio/dio.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/network/dio_client.dart';
import 'models/customer.dart';

final customersRepositoryProvider = Provider<CustomersRepository>((ref) {
  final dio = ref.read(dioProvider);
  return CustomersRepository(dio);
});

class CustomersRepository {
  CustomersRepository(this._dio);

  final Dio _dio;

  Future<List<Customer>> fetch({Map<String, dynamic>? params}) async {
    final resp = await _dio.get('/v1/clientes', queryParameters: params);
    final data = resp.data;
    final list = data is List ? data : data['data'] as List<dynamic>;
    return list
        .map((e) => Customer.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  Future<Customer> create(Map<String, dynamic> dto) async {
    final resp = await _dio.post('/v1/clientes', data: dto);
    return Customer.fromJson(Map<String, dynamic>.from(resp.data));
  }

  Future<Customer> update(int id, Map<String, dynamic> dto) async {
    final resp = await _dio.put('/v1/clientes/$id', data: dto);
    return Customer.fromJson(Map<String, dynamic>.from(resp.data));
  }

  Future<void> delete(int id) async {
    await _dio.delete('/v1/clientes/$id');
  }

  Map<String, List<String>> map422(DioException e) {
    final details = e.response?.data['details'] as Map<String, dynamic>?;
    if (details == null) return {};
    return details.map(
        (key, value) => MapEntry(key, List<String>.from(value as List)));
  }
}
