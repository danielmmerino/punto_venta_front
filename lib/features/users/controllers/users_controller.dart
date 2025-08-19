import 'package:dio/dio.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../data/models/user.dart';
import '../data/users_repository.dart';
import 'users_state.dart';

final usersControllerProvider =
    StateNotifierProvider<UsersController, UsersState>((ref) {
  return UsersController(ref);
});

class UsersController extends StateNotifier<UsersState> {
  UsersController(this._ref) : super(const UsersState());

  final Ref _ref;

  Future<void> load({Map<String, dynamic>? filters}) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final repo = _ref.read(usersRepositoryProvider);
      final users = await repo.fetchUsers(params: filters);
      state = state.copyWith(users: users);
    } catch (_) {
      state = state.copyWith(error: 'No se pudo cargar');
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<User?> create(Map<String, dynamic> dto) async {
    try {
      final repo = _ref.read(usersRepositoryProvider);
      final user = await repo.createUser(dto);
      state = state.copyWith(users: [...state.users, user]);
      return user;
    } on DioException catch (e) {
      state = state.copyWith(error: e.message);
      rethrow;
    }
  }

  Future<User?> update(int id, Map<String, dynamic> dto) async {
    try {
      final repo = _ref.read(usersRepositoryProvider);
      final user = await repo.updateUser(id, dto);
      final idx = state.users.indexWhere((u) => u.id == id);
      if (idx != -1) {
        final list = [...state.users];
        list[idx] = user;
        state = state.copyWith(users: list);
      }
      return user;
    } on DioException catch (e) {
      state = state.copyWith(error: e.message);
      rethrow;
    }
  }

  Future<void> remove(int id) async {
    try {
      final repo = _ref.read(usersRepositoryProvider);
      await repo.deleteUser(id);
      state =
          state.copyWith(users: state.users.where((u) => u.id != id).toList());
    } on DioException catch (e) {
      state = state.copyWith(error: e.message);
      rethrow;
    }
  }

  Future<User?> assignRoles(int id, List<String> roles) async {
    try {
      final repo = _ref.read(usersRepositoryProvider);
      final user = await repo.assignRoles(id, roles);
      final idx = state.users.indexWhere((u) => u.id == id);
      if (idx != -1) {
        final list = [...state.users];
        list[idx] = user;
        state = state.copyWith(users: list);
      }
      return user;
    } on DioException catch (e) {
      state = state.copyWith(error: e.message);
      rethrow;
    }
  }
}
