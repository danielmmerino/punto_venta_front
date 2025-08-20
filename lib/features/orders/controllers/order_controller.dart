import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../data/menu_repository.dart';
import '../data/models/menu_item.dart';
import 'order_state.dart';

final orderControllerProvider =
    StateNotifierProvider<OrderController, OrderState>((ref) {
  return OrderController(ref);
});

class OrderController extends StateNotifier<OrderState> {
  OrderController(this._ref) : super(const OrderState());

  final Ref _ref;

  Future<void> loadMenu({int localId = 100}) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final repo = _ref.read(menuRepositoryProvider);
      final items = await repo.list(localId: localId);
      state = state.copyWith(menu: items);
    } catch (_) {
      state = state.copyWith(error: 'No se pudo cargar el menú');
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  void add(MenuItem item) {
    final idx = state.items.indexWhere((e) => e.item.id == item.id);
    if (idx == -1) {
      state = state.copyWith(items: [...state.items, OrderLine(item: item)]);
    } else {
      final list = [...state.items];
      final line = list[idx];
      list[idx] = line.copyWith(quantity: line.quantity + 1);
      state = state.copyWith(items: list);
    }
  }

  void remove(MenuItem item) {
    final idx = state.items.indexWhere((e) => e.item.id == item.id);
    if (idx == -1) return;
    final list = [...state.items];
    final line = list[idx];
    if (line.quantity <= 1) {
      list.removeAt(idx);
    } else {
      list[idx] = line.copyWith(quantity: line.quantity - 1);
    }
    state = state.copyWith(items: list);
  }

  void clear() {
    state = state.copyWith(items: []);
  }
}
