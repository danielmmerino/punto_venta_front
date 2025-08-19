import '../data/models/bodega.dart';

class BodegasState {
  const BodegasState({
    this.items = const [],
    this.isLoading = false,
    this.error,
    this.fieldErrors = const {},
  });

  final List<Bodega> items;
  final bool isLoading;
  final String? error;
  final Map<String, List<String>> fieldErrors;

  BodegasState copyWith({
    List<Bodega>? items,
    bool? isLoading,
    String? error,
    Map<String, List<String>>? fieldErrors,
  }) => BodegasState(
        items: items ?? this.items,
        isLoading: isLoading ?? this.isLoading,
        error: error,
        fieldErrors: fieldErrors ?? this.fieldErrors,
      );
}
