import 'package:dio/dio.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../core/network/dio_client.dart';
import 'models/recipe_line.dart';

final recipeRepositoryProvider = Provider<RecipeRepository>((ref) {
  final dio = ref.read(dioProvider);
  return RecipeRepository(dio);
});

class RecipeRepository {
  RecipeRepository(this._dio);

  final Dio _dio;

  Future<List<RecipeLine>> getRecipe(int productId) async {
    final resp = await _dio.get('/v1/productos/$productId/receta');
    final list = resp.data['data'] as List<dynamic>;
    return list
        .map((e) => RecipeLine.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  Future<List<RecipeLine>> saveRecipe(
      int productId, List<RecipeLine> lines) async {
    final payload = lines.map((e) => e.toPayload()).toList();
    final resp = await _dio.post(
      '/v1/productos/$productId/receta',
      data: payload,
    );
    final list = resp.data['data'] as List<dynamic>;
    return list
        .map((e) => RecipeLine.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  Future<void> deleteLine(int productId, int insumoId) async {
    await _dio.delete('/v1/productos/$productId/receta/$insumoId');
  }
}
