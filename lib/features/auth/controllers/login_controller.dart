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
      print('Login successful for $email');
      final subRepo = _ref.read(subscriptionRepositoryProvider);
      await subRepo.refresh();
      print('Subscription active: ${subRepo.isActive}');
      if (!subRepo.isActive) {
        print('Subscription inactive, redirecting to /subscription/blocked');
        _ref.read(routerProvider).go('/subscription/blocked');
        return;
      }
      final locales = resp.locales;
      print('Locales count: ${locales.length}');
      if (locales.isEmpty) {
        state = state.copyWith(error: 'No se encontraron locales');
        print('No locales found, staying on login page');
        return;
      }
      if (locales.length > 1) {
        print('Multiple locales detected, redirecting to /selector-local');
        _ref.read(routerProvider).go('/selector-local');
      } else {
        print('Single locale, redirecting to /dashboard');
        _ref.read(routerProvider).go('/dashboard');
      }
    } on DioException catch (e) {
      print('DioException during login: ' + e.message.toString());
      if (e.response?.statusCode == 401) {
        state = state.copyWith(error: 'Credenciales inválidas');
      } else {
        state = state.copyWith(error: 'Ocurrió un problema, intenta de nuevo');
      }
    } catch (e, stack) {
      print('Unexpected error during login: ' + e.toString());
      print(stack.toString());
      state = state.copyWith(error: 'Ocurrió un problema, intenta de nuevo');
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }
}
