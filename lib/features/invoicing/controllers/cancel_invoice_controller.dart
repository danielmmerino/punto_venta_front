import 'package:dio/dio.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../invoices/data/invoices_repository.dart';
import '../../invoices/data/models/cancel_result.dart';

class CancelInvoiceState {
  const CancelInvoiceState({
    this.isSending = false,
    this.error,
    this.result,
  });

  final bool isSending;
  final String? error;
  final CancelInvoiceResult? result;

  CancelInvoiceState copyWith({
    bool? isSending,
    String? error,
    CancelInvoiceResult? result,
  }) =>
      CancelInvoiceState(
        isSending: isSending ?? this.isSending,
        error: error,
        result: result ?? this.result,
      );
}

final cancelInvoiceControllerProvider =
    StateNotifierProvider<CancelInvoiceController, CancelInvoiceState>((ref) {
  return CancelInvoiceController(ref);
});

class CancelInvoiceController extends StateNotifier<CancelInvoiceState> {
  CancelInvoiceController(this._ref) : super(const CancelInvoiceState());

  final Ref _ref;

  Future<void> submit(int facturaId, String motivo) async {
    final validation = validateMotivo(motivo);
    if (validation != null) {
      state = state.copyWith(error: validation);
      return;
    }
    state = state.copyWith(isSending: true, error: null);
    try {
      final repo = _ref.read(invoicesRepositoryProvider);
      final result = await repo.cancel(facturaId, motivo);
      state = state.copyWith(result: result);
    } on DioException catch (e) {
      if (e.response?.statusCode == 409) {
        state = state.copyWith(error: 'Factura ya anulada');
      } else if (e.response?.statusCode == 422) {
        final msg = e.response?.data['message'];
        state =
            state.copyWith(error: msg is String ? msg : 'No se puede anular');
      } else {
        state = state.copyWith(error: 'Error al anular');
      }
    } catch (_) {
      state = state.copyWith(error: 'Error al anular');
    } finally {
      state = state.copyWith(isSending: false);
    }
  }
}

String? validateMotivo(String? value) {
  final v = value?.trim() ?? '';
  if (v.isEmpty) return 'Motivo requerido';
  if (v.length < 10 || v.length > 200) {
    return 'Debe tener entre 10 y 200 caracteres';
  }
  return null;
}
