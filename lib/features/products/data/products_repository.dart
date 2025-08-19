import 'package:dio/dio.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../core/network/dio_client.dart';
import 'models/product.dart';

final productsRepositoryProvider = Provider<ProductsRepository>((ref) {
  final dio = ref.read(dioProvider);
  return ProductsRepository(dio);
});

class ProductsRepository {
  ProductsRepository(this._dio);

  final Dio _dio;

  Future<List<Product>> list({Map<String, dynamic>? params}) async {
    final resp = await _dio.get('/v1/productos', queryParameters: params);
    final data = resp.data;
    if (data is List) {
      return data
          .map((e) => Product.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    }
    final list = data['data'] as List<dynamic>;
    return list
        .map((e) => Product.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  Future<Product> create(Map<String, dynamic> dto) async {
    final resp = await _dio.post('/v1/productos', data: dto);
    return Product.fromJson(Map<String, dynamic>.from(resp.data));
  }

  Future<Product> update(int id, Map<String, dynamic> dto) async {
    final resp = await _dio.put('/v1/productos/$id', data: dto);
    return Product.fromJson(Map<String, dynamic>.from(resp.data));
  }

  Future<void> delete(int id) async {
    await _dio.delete('/v1/productos/$id');
  }

  Future<Product> toggleActive(int id, bool active) async {
    final resp = await _dio.put('/v1/productos/$id', data: {'activo': active});
    return Product.fromJson(Map<String, dynamic>.from(resp.data));
  }

  Future<void> importFile(Map<String, dynamic> dto) async {
    await _dio.post('/v1/productos/import', data: dto);
  }
}
