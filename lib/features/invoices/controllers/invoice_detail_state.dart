import '../data/models/invoice.dart';

class InvoiceDetailState {
  const InvoiceDetailState({
    this.isLoading = false,
    this.invoice,
    this.error,
    this.isPolling = false,
  });

  final bool isLoading;
  final Invoice? invoice;
  final String? error;
  final bool isPolling;

  bool get canEmit =>
      invoice != null &&
      (invoice!.estadoSri == 'pendiente' || invoice!.estadoSri == 'rechazada');

  InvoiceDetailState copyWith({
    bool? isLoading,
    Invoice? invoice,
    String? error,
    bool? isPolling,
  }) {
    return InvoiceDetailState(
      isLoading: isLoading ?? this.isLoading,
      invoice: invoice ?? this.invoice,
      error: error,
      isPolling: isPolling ?? this.isPolling,
    );
  }
}
