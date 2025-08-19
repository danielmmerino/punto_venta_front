import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../common/cash_repository.dart';
import 'close_cash_state.dart';

final closeCashControllerProvider =
    StateNotifierProvider<CloseCashController, CloseCashState>((ref) {
  final repo = ref.read(cashRepositoryProvider);
  return CloseCashController(repo);
});

class CloseCashController extends StateNotifier<CloseCashState> {
  CloseCashController(this._repo) : super(const CloseCashState());

  final CashRepository _repo;

  Future<void> load({required int localId, DateTime? fecha}) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final status = await _repo.getStatus(localId: localId, fecha: fecha);
      state = state.copyWith(
        aperturaId: status.aperturaId,
        methods: status.totalesPorMetodo
            .map((e) => MethodCount(
                metodoId: e.metodoId,
                codigo: e.codigo,
                nombre: e.nombre,
                esperado: e.esperado))
            .toList(),
      );
    } catch (e) {
      state = state.copyWith(error: e.toString());
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  void updateCount(int metodoId, double conteo) {
    if (conteo < 0) return;
    final methods = state.methods
        .map((e) => e.metodoId == metodoId ? e.copyWith(conteo: conteo) : e)
        .toList();
    state = state.copyWith(methods: methods);
  }

  Future<void> close({String? observaciones}) async {
    if (state.aperturaId == null) return;
    state = state.copyWith(isClosing: true, error: null);
    try {
      final resp = await _repo.closeCash(
          aperturaId: state.aperturaId!,
          conteos: state.methods,
          observaciones: observaciones);
      state = state.copyWith(closed: true, pdfUrl: resp.pdfUrl);
    } on CashAlreadyClosedException {
      state = state.copyWith(error: 'Caja ya cerrada');
    } catch (e) {
      state = state.copyWith(error: e.toString());
    } finally {
      state = state.copyWith(isClosing: false);
    }
  }
}
