import 'package:dio/dio.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/network/dio_client.dart';
import 'models/stock_item.dart';
import '../../../../products/data/models/product.dart';
import '../../../../products/data/products_repository.dart';

final stockRepositoryProvider = Provider<StockRepository>((ref) {
  final dio = ref.read(dioProvider);
  return StockRepository(dio);
});

final productsSearchProvider =
    FutureProvider.family<List<Product>, String>((ref, query) async {
  final repo = ref.read(productsRepositoryProvider);
  return repo.list(params: {'search': query, 'activo': true});
});

class StockRepository {
  StockRepository(this._dio);

  final Dio _dio;

  Future<List<StockItem>> list(Map<String, dynamic> params) async {
    final resp = await _dio.get('/v1/stock', queryParameters: params);
    final data = resp.data;
    final list = data is List ? data : data['data'] as List<dynamic>;
    return list
        .map((e) => StockItem.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }
}
