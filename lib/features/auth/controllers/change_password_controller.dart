import 'package:dio/dio.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../data/auth/auth_repository.dart';

class ChangePasswordState {
  const ChangePasswordState({this.isLoading = false, this.error, this.success = false});

  final bool isLoading;
  final String? error;
  final bool success;

  ChangePasswordState copyWith({bool? isLoading, String? error, bool? success}) =>
      ChangePasswordState(
        isLoading: isLoading ?? this.isLoading,
        error: error,
        success: success ?? this.success,
      );
}

final changePasswordControllerProvider =
    StateNotifierProvider<ChangePasswordController, ChangePasswordState>((ref) {
  final repo = ref.read(authRepositoryProvider);
  return ChangePasswordController(repo);
});

class ChangePasswordController extends StateNotifier<ChangePasswordState> {
  ChangePasswordController(this._repo) : super(const ChangePasswordState());

  final AuthRepository _repo;

  Future<void> submit(String currentPassword, String newPassword) async {
    if (state.isLoading) return;
    state = state.copyWith(isLoading: true, error: null, success: false);
    try {
      await _repo.changePassword(currentPassword, newPassword);
      state = state.copyWith(success: true);
    } on DioException catch (e) {
      state = state.copyWith(error: e.response?.data['message'] as String? ?? 'Ocurrió un problema');
    } catch (_) {
      state = state.copyWith(error: 'Ocurrió un problema');
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }
}
