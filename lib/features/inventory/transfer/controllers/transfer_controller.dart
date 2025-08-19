import 'package:dio/dio.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../common/line_item.dart';
import '../data/transfer_repository.dart';
import '../../../products/data/models/product.dart';
import 'transfer_state.dart';

final transferControllerProvider =
    StateNotifierProvider<TransferController, TransferState>((ref) {
  return TransferController(ref);
});

class TransferController extends StateNotifier<TransferState> {
  TransferController(this._ref) : super(const TransferState());

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

  Future<bool> submit({required int origen, required int destino}) async {
    final errors = <String, List<String>>{};
    if (origen == destino) {
      errors['bodegas'] = ['Origen y destino deben ser distintos'];
    }
    if (state.lines.isEmpty) {
      errors['items'] = ['Agregar al menos una línea'];
    }
    for (var i = 0; i < state.lines.length; i++) {
      final l = state.lines[i];
      if (l.product == null) {
        errors['items[$i].producto_id'] = ['Requerido'];
      }
      if (l.quantity <= 0) {
        errors['items[$i].cantidad'] = ['Debe ser > 0'];
      }
    }
    if (errors.isNotEmpty) {
      state = state.copyWith(fieldErrors: errors);
      return false;
    }

    state = state.copyWith(isSaving: true, fieldErrors: {});
    final dto = {
      'bodega_origen': origen,
      'bodega_destino': destino,
      'items': state.lines
          .map((l) => {
                'producto_id': l.product!.id,
                'cantidad': l.quantity,
              })
          .toList(),
    };
    try {
      await _ref
          .read(transferRepositoryProvider)
          .create(dto, origen: origen, destino: destino);
      state = const TransferState();
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
