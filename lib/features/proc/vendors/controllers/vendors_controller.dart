import 'package:dio/dio.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../data/models/vendor.dart';
import '../data/vendors_repository.dart';
import 'vendors_state.dart';

final vendorsControllerProvider =
    StateNotifierProvider<VendorsController, VendorsState>((ref) {
  return VendorsController(ref);
});

class VendorsController extends StateNotifier<VendorsState> {
  VendorsController(this._ref) : super(const VendorsState());

  final Ref _ref;

  Future<void> load({Map<String, dynamic>? params}) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final repo = _ref.read(vendorsRepositoryProvider);
      final list = await repo.fetch(params: params);
      state = state.copyWith(vendors: list);
    } catch (_) {
      state = state.copyWith(error: 'No se pudo cargar');
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<Vendor?> create(Map<String, dynamic> dto) async {
    final repo = _ref.read(vendorsRepositoryProvider);
    try {
      final v = await repo.create(dto);
      state = state.copyWith(vendors: [...state.vendors, v]);
      return v;
    } on DioException catch (e) {
      state = state.copyWith(error: e.message);
      if (e.response?.statusCode == 422) {
        throw repo.map422(e);
      }
      rethrow;
    }
  }

  Future<Vendor?> update(int id, Map<String, dynamic> dto) async {
    final repo = _ref.read(vendorsRepositoryProvider);
    try {
      final v = await repo.update(id, dto);
      final idx = state.vendors.indexWhere((e) => e.id == id);
      if (idx != -1) {
        final list = [...state.vendors];
        list[idx] = v;
        state = state.copyWith(vendors: list);
      }
      return v;
    } on DioException catch (e) {
      state = state.copyWith(error: e.message);
      if (e.response?.statusCode == 422) {
        throw repo.map422(e);
      }
      rethrow;
    }
  }

  Future<void> remove(int id) async {
    try {
      final repo = _ref.read(vendorsRepositoryProvider);
      await repo.delete(id);
      state = state.copyWith(
          vendors: state.vendors.where((e) => e.id != id).toList());
    } on DioException catch (e) {
      state = state.copyWith(error: e.message);
      rethrow;
    }
  }
}
