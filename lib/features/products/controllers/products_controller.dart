import 'package:dio/dio.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../data/models/product.dart';
import '../data/products_repository.dart';
import 'products_state.dart';

final productsControllerProvider =
    StateNotifierProvider<ProductsController, ProductsState>((ref) {
  return ProductsController(ref);
});

class ProductsController extends StateNotifier<ProductsState> {
  ProductsController(this._ref) : super(const ProductsState());

  final Ref _ref;

  Future<void> load({Map<String, dynamic>? filters}) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final repo = _ref.read(productsRepositoryProvider);
      final items = await repo.list(params: filters);
      state = state.copyWith(items: items);
    } catch (_) {
      state = state.copyWith(error: 'No se pudo cargar');
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<Product?> create(Map<String, dynamic> dto) async {
    state = state.copyWith(fieldErrors: {});
    try {
      final repo = _ref.read(productsRepositoryProvider);
      final product = await repo.create(dto);
      state = state.copyWith(items: [...state.items, product]);
      return product;
    } on DioException catch (e) {
      final details =
          e.response?.data['error']?['details'] as Map<String, dynamic>?;
      if (details != null) {
        state = state.copyWith(
          fieldErrors: details.map(
            (key, value) => MapEntry(
              key,
              (value as List).map((e) => e.toString()).toList(),
            ),
          ),
        );
      }
      rethrow;
    }
  }

  Future<Product?> update(int id, Map<String, dynamic> dto) async {
    state = state.copyWith(fieldErrors: {});
    try {
      final repo = _ref.read(productsRepositoryProvider);
      final product = await repo.update(id, dto);
      final idx = state.items.indexWhere((p) => p.id == id);
      if (idx != -1) {
        final list = [...state.items];
        list[idx] = product;
        state = state.copyWith(items: list);
      }
      return product;
    } on DioException catch (e) {
      final details =
          e.response?.data['error']?['details'] as Map<String, dynamic>?;
      if (details != null) {
        state = state.copyWith(
          fieldErrors: details.map(
            (key, value) => MapEntry(
              key,
              (value as List).map((e) => e.toString()).toList(),
            ),
          ),
        );
      }
      rethrow;
    }
  }

  Future<void> remove(int id) async {
    try {
      final repo = _ref.read(productsRepositoryProvider);
      await repo.delete(id);
      state =
          state.copyWith(items: state.items.where((p) => p.id != id).toList());
    } on DioException catch (e) {
      state = state.copyWith(error: e.message);
      rethrow;
    }
  }

  Future<void> toggleActive(int id, bool active) async {
    try {
      final repo = _ref.read(productsRepositoryProvider);
      final product = await repo.toggleActive(id, active);
      final idx = state.items.indexWhere((p) => p.id == id);
      if (idx != -1) {
        final list = [...state.items];
        list[idx] = product;
        state = state.copyWith(items: list);
      }
    } on DioException catch (e) {
      state = state.copyWith(error: e.message);
      rethrow;
    }
  }
}
