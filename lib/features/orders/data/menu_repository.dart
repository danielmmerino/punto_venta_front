import 'package:dio/dio.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../core/network/dio_client.dart';
import 'models/menu_item.dart';

final menuRepositoryProvider = Provider<MenuRepository>((ref) {
  final dio = ref.read(dioProvider);
  return MenuRepository(dio);
});

class MenuRepository {
  MenuRepository(this._dio);

  final Dio _dio;

  Future<List<MenuItem>> list({required int localId}) async {
    final resp =
        await _dio.get('/v1/menu', queryParameters: {'local_id': localId});
    final data = resp.data;
    if (data is List) {
      return data
          .map((e) => MenuItem.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    }
    final list = data['data'] as List<dynamic>;
    return list
        .map((e) => MenuItem.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }
}
