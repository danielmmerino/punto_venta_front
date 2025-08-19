import 'package:dio/dio.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../data/bodegas_repository.dart';
import '../data/models/bodega.dart';
import 'bodegas_state.dart';

final bodegasControllerProvider =
    StateNotifierProvider<BodegasController, BodegasState>((ref) {
  return BodegasController(ref);
});

class BodegasController extends StateNotifier<BodegasState> {
  BodegasController(this._ref) : super(const BodegasState());

  final Ref _ref;

  Future<void> load({Map<String, dynamic>? filters}) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final repo = _ref.read(bodegasRepositoryProvider);
      final items = await repo.list(params: filters);
      state = state.copyWith(items: items);
    } catch (_) {
      state = state.copyWith(error: 'No se pudo cargar');
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<Bodega?> create(Map<String, dynamic> dto) async {
    state = state.copyWith(fieldErrors: {});
    try {
      final repo = _ref.read(bodegasRepositoryProvider);
      final bodega = await repo.create(dto);
      state = state.copyWith(items: [...state.items, bodega]);
      return bodega;
    } on DioException catch (e) {
      final details =
          e.response?.data['error']?['details'] as Map<String, dynamic>?;
      if (details != null) {
        state = state.copyWith(
          fieldErrors: details.map((k, v) =>
              MapEntry(k, (v as List).map((e) => e.toString()).toList())),
        );
      }
      rethrow;
    }
  }

  Future<Bodega?> update(int id, Map<String, dynamic> dto) async {
    state = state.copyWith(fieldErrors: {});
    try {
      final repo = _ref.read(bodegasRepositoryProvider);
      final bodega = await repo.update(id, dto);
      final idx = state.items.indexWhere((b) => b.id == id);
      if (idx != -1) {
        final list = [...state.items];
        list[idx] = bodega;
        state = state.copyWith(items: list);
      }
      return bodega;
    } on DioException catch (e) {
      final details =
          e.response?.data['error']?['details'] as Map<String, dynamic>?;
      if (details != null) {
        state = state.copyWith(
          fieldErrors: details.map((k, v) =>
              MapEntry(k, (v as List).map((e) => e.toString()).toList())),
        );
      }
      rethrow;
    }
  }

  Future<void> remove(int id) async {
    try {
      final repo = _ref.read(bodegasRepositoryProvider);
      await repo.delete(id);
      state =
          state.copyWith(items: state.items.where((b) => b.id != id).toList());
    } on DioException catch (e) {
      state = state.copyWith(error: e.message);
      rethrow;
    }
  }
}
