import '../../common/cash_repository.dart';

class CloseCashState {
  const CloseCashState({
    this.isLoading = false,
    this.isClosing = false,
    this.closed = false,
    this.aperturaId,
    this.methods = const [],
    this.pdfUrl,
    this.error,
  });

  final bool isLoading;
  final bool isClosing;
  final bool closed;
  final int? aperturaId;
  final List<MethodCount> methods;
  final String? pdfUrl;
  final String? error;

  double get totalEsperado =>
      methods.fold(0, (p, e) => p + e.esperado);
  double get totalConteo => methods.fold(0, (p, e) => p + e.conteo);
  double get totalDiferencia =>
      methods.fold(0, (p, e) => p + e.diferencia);

  CloseCashState copyWith({
    bool? isLoading,
    bool? isClosing,
    bool? closed,
    int? aperturaId,
    List<MethodCount>? methods,
    String? pdfUrl,
    String? error,
  }) {
    return CloseCashState(
      isLoading: isLoading ?? this.isLoading,
      isClosing: isClosing ?? this.isClosing,
      closed: closed ?? this.closed,
      aperturaId: aperturaId ?? this.aperturaId,
      methods: methods ?? this.methods,
      pdfUrl: pdfUrl ?? this.pdfUrl,
      error: error,
    );
  }
}
