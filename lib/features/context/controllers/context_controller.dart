import 'package:dio/dio.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/routing/app_router.dart';
import '../data/context_repository.dart';
import '../data/local.dart';

class ContextState {
  const ContextState({
    this.empresaId,
    this.localId,
    this.locales = const [],
    this.isLoading = false,
    this.error,
  });

  final int? empresaId;
  final int? localId;
  final List<Local> locales;
  final bool isLoading;
  final String? error;

  ContextState copyWith({
    int? empresaId,
    int? localId,
    List<Local>? locales,
    bool? isLoading,
    String? error,
  }) =>
      ContextState(
        empresaId: empresaId ?? this.empresaId,
        localId: localId ?? this.localId,
        locales: locales ?? this.locales,
        isLoading: isLoading ?? this.isLoading,
        error: error,
      );
}

final contextControllerProvider =
    StateNotifierProvider<ContextController, ContextState>((ref) {
  return ContextController(ref);
});

class ContextController extends StateNotifier<ContextState> {
  ContextController(this._ref) : super(const ContextState());

  final Ref _ref;

  Future<void> loadContext() async {
    if (state.isLoading) return;
    state = state.copyWith(isLoading: true, error: null);
    final repo = _ref.read(contextRepositoryProvider);
    try {
      final ctx = await repo.fetchTenancyContext();
      if (ctx != null) {
        state = state.copyWith(
          empresaId: ctx.empresaId,
          locales: ctx.locales,
        );
        if (ctx.suscripcionEstado != 'active') {
          _ref.read(routerProvider).go('/subscription/blocked');
          return;
        }
      } else {
        final locales = await repo.fetchUserLocales();
        state = state.copyWith(locales: locales);
      }
      if (state.locales.length == 1) {
        await selectLocal(state.locales.first.id);
      }
    } catch (_) {
      state = state.copyWith(error: 'Error al cargar');
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> selectLocal(int localId) async {
    final local = state.locales.firstWhere(
      (l) => l.id == localId,
      orElse: () => throw Exception('Local no permitido'),
    );
    try {
      final status = await _ref
          .read(contextRepositoryProvider)
          .checkSubscription(localId: localId);
      if (!status.vigente) {
        _ref.read(routerProvider).go('/subscription/blocked');
        return;
      }
      setHeaderXLocalId(localId);
      state = state.copyWith(localId: localId, empresaId: local.empresaId);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('currentLocalId', localId);
      _ref.read(routerProvider).go('/dashboard');
    } on DioException catch (e) {
      if (e.response?.statusCode == 403) {
        _ref.read(routerProvider).go('/subscription/blocked');
      } else {
        state = state.copyWith(error: 'Error al seleccionar local');
      }
    }
  }

  void setHeaderXLocalId(int? localId) {
    state = state.copyWith(localId: localId);
  }
}
