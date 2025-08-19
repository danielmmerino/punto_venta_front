import 'package:dio/dio.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../data/customers_repository.dart';
import '../data/models/customer.dart';
import 'customers_state.dart';

final customersControllerProvider =
    StateNotifierProvider<CustomersController, CustomersState>((ref) {
  return CustomersController(ref);
});

class CustomersController extends StateNotifier<CustomersState> {
  CustomersController(this._ref) : super(const CustomersState());

  final Ref _ref;

  Future<void> load({Map<String, dynamic>? params}) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final repo = _ref.read(customersRepositoryProvider);
      final list = await repo.fetch(params: params);
      state = state.copyWith(customers: list);
    } catch (e) {
      state = state.copyWith(error: 'No se pudo cargar');
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<Customer?> create(Map<String, dynamic> dto) async {
    final repo = _ref.read(customersRepositoryProvider);
    try {
      final c = await repo.create(dto);
      state = state.copyWith(customers: [...state.customers, c]);
      return c;
    } on DioException catch (e) {
      state = state.copyWith(error: e.message);
      if (e.response?.statusCode == 422) {
        throw repo.map422(e);
      }
      rethrow;
    }
  }

  Future<Customer?> update(int id, Map<String, dynamic> dto) async {
    final repo = _ref.read(customersRepositoryProvider);
    try {
      final c = await repo.update(id, dto);
      final idx = state.customers.indexWhere((e) => e.id == id);
      if (idx != -1) {
        final list = [...state.customers];
        list[idx] = c;
        state = state.copyWith(customers: list);
      }
      return c;
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
      final repo = _ref.read(customersRepositoryProvider);
      await repo.delete(id);
      state = state.copyWith(
          customers: state.customers.where((e) => e.id != id).toList());
    } on DioException catch (e) {
      state = state.copyWith(error: e.message);
      rethrow;
    }
  }
}
