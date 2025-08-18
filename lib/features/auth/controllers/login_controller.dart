import 'package:dio/dio.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../data/auth/auth_repository.dart';
import '../../../data/subscription/subscription_repository.dart';
import '../../../core/routing/app_router.dart';

class LoginState {
  const LoginState({this.isLoading = false, this.error});

  final bool isLoading;
  final String? error;

  LoginState copyWith({bool? isLoading, String? error}) => LoginState(
        isLoading: isLoading ?? this.isLoading,
        error: error,
      );
}

final loginControllerProvider =
    StateNotifierProvider<LoginController, LoginState>((ref) {
  return LoginController(ref);
});

class LoginController extends StateNotifier<LoginState> {
  LoginController(this._ref) : super(const LoginState());

  final Ref _ref;

  Future<void> submit(String email, String password) async {
    if (state.isLoading) return;
    state = state.copyWith(isLoading: true, error: null);
    try {
      final authNotifier = _ref.read(authStateProvider.notifier);
      final resp = await authNotifier.login(email, password);
      final subRepo = _ref.read(subscriptionRepositoryProvider);
      await subRepo.refresh();
      if (!subRepo.isActive) {
        _ref.read(routerProvider).go('/subscription/blocked');
        return;
      }
      final locales = resp.locales;
      if (locales.length > 1) {
        _ref.read(routerProvider).go('/selector-local');
      } else {
        _ref.read(routerProvider).go('/dashboard');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        state = state.copyWith(error: 'Credenciales inválidas');
      } else {
        state = state.copyWith(error: 'Ocurrió un problema, intenta de nuevo');
      }
    } catch (_) {
      state = state.copyWith(error: 'Ocurrió un problema, intenta de nuevo');
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }
}
