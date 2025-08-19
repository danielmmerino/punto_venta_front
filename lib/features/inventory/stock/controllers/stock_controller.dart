import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../data/stock_repository.dart';
import '../data/models/stock_item.dart';
import 'stock_state.dart';

final stockControllerProvider =
    StateNotifierProvider<StockController, StockState>((ref) {
  return StockController(ref);
});

class StockController extends StateNotifier<StockState> {
  StockController(this._ref) : super(const StockState());

  final Ref _ref;

  Future<void> load({
    int? bodegaId,
    int? productoId,
    bool? soloConStock,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final repo = _ref.read(stockRepositoryProvider);
      final params = <String, dynamic>{};
      if (bodegaId != null) params['bodega_id'] = bodegaId;
      if (productoId != null) params['producto_id'] = productoId;
      if (soloConStock == true) params['stock_gt'] = 0;
      final items = await repo.list(params);
      state = state.copyWith(items: items);
    } catch (_) {
      state = state.copyWith(error: 'No se pudo cargar');
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }
}
