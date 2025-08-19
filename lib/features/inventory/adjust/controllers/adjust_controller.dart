import 'package:dio/dio.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../common/line_item.dart';
import '../data/adjust_repository.dart';
import '../../../products/data/models/product.dart';
import 'adjust_state.dart';

final adjustControllerProvider =
    StateNotifierProvider<AdjustController, AdjustState>((ref) {
  return AdjustController(ref);
});

class AdjustController extends StateNotifier<AdjustState> {
  AdjustController(this._ref) : super(const AdjustState());

  final Ref _ref;

  void addLine() {
    state = state.copyWith(lines: [...state.lines, LineItem()]);
  }

  void removeLine(int index) {
    final list = [...state.lines]..removeAt(index);
    state = state.copyWith(lines: list);
  }

  void updateProduct(int index, Product product) {
    final list = [...state.lines];
    list[index].product = product;
    state = state.copyWith(lines: list);
  }

  void updateQuantity(int index, double qty) {
    final list = [...state.lines];
    list[index].quantity = qty;
    state = state.copyWith(lines: list);
  }

  void updateCost(int index, double? cost) {
    final list = [...state.lines];
    list[index].cost = cost;
    state = state.copyWith(lines: list);
  }

  Future<bool> submit({required int bodegaId, required String motivo}) async {
    final errors = <String, List<String>>{};
    if (motivo.trim().isEmpty) {
      errors['motivo'] = ['Requerido'];
    }
    if (state.lines.isEmpty) {
      errors['items'] = ['Agregar al menos una línea'];
    }
    for (var i = 0; i < state.lines.length; i++) {
      final l = state.lines[i];
      if (l.product == null) {
        errors['items[$i].producto_id'] = ['Requerido'];
      }
      if (l.quantity == 0) {
        errors['items[$i].cantidad'] = ['No puede ser 0'];
      }
      if (l.cost != null && l.cost! < 0) {
        errors['items[$i].costo'] = ['Debe ser >= 0'];
      }
    }
    if (errors.isNotEmpty) {
      state = state.copyWith(fieldErrors: errors);
      return false;
    }

    state = state.copyWith(isSaving: true, fieldErrors: {});
    final dto = {
      'bodega_id': bodegaId,
      'motivo': motivo,
      'items': state.lines
          .map((l) => {
                'producto_id': l.product!.id,
                'cantidad': l.quantity,
                if (l.cost != null) 'costo': l.cost,
              })
          .toList(),
    };
    try {
      await _ref.read(adjustRepositoryProvider).create(dto, bodegaId: bodegaId);
      state = const AdjustState();
      return true;
    } on DioException catch (e) {
      final details =
          e.response?.data['error']?['details'] as Map<String, dynamic>?;
      if (details != null) {
        state = state.copyWith(
            fieldErrors: details.map((k, v) => MapEntry(
                k, (v as List).map((e) => e.toString()).toList())));
      } else {
        state = state.copyWith(error: e.message);
      }
      return false;
    } finally {
      state = state.copyWith(isSaving: false);
    }
  }
}
