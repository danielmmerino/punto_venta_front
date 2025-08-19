import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../data/invoices_repository.dart';
import '../data/models/invoice.dart';
import 'invoice_detail_state.dart';

final invoiceDetailControllerProvider =
    StateNotifierProvider<InvoiceDetailController, InvoiceDetailState>(
        (ref) {
  return InvoiceDetailController(ref);
});

class InvoiceDetailController extends StateNotifier<InvoiceDetailState> {
  InvoiceDetailController(this._ref) : super(const InvoiceDetailState());

  final Ref _ref;
  Timer? _timer;
  int _attempts = 0;

  Future<void> load(int id) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final repo = _ref.read(invoicesRepositoryProvider);
      final invoice = await repo.getInvoice(id);
      state = state.copyWith(invoice: invoice);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> emit(int id) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final repo = _ref.read(invoicesRepositoryProvider);
      final status = await repo.emit(id);
      state = state.copyWith(
          invoice: state.invoice?.copyWith(estadoSri: status));
      if (status == 'enviada') {
        startPolling(id);
      }
    } catch (e) {
      state = state.copyWith(error: e.toString());
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  void startPolling(int id,
      {Duration interval = const Duration(seconds: 3), int maxAttempts = 20}) {
    stopPolling();
    _attempts = 0;
    state = state.copyWith(isPolling: true);
    _timer = Timer.periodic(interval, (timer) async {
      _attempts++;
      if (_attempts > maxAttempts) {
        stopPolling();
        return;
      }
      final repo = _ref.read(invoicesRepositoryProvider);
      try {
        final invoice = await repo.getInvoice(id);
        state = state.copyWith(invoice: invoice);
        if (invoice.estadoSri == 'autorizada' ||
            invoice.estadoSri == 'rechazada') {
          stopPolling();
        }
      } catch (_) {}
    });
  }

  void stopPolling() {
    _timer?.cancel();
    state = state.copyWith(isPolling: false);
  }

  Future<void> downloadPdf(int id) async {
    final repo = _ref.read(invoicesRepositoryProvider);
    await repo.downloadPdf(id);
  }

  Future<void> downloadXml(int id) async {
    final repo = _ref.read(invoicesRepositoryProvider);
    await repo.downloadXml(id);
  }
}
