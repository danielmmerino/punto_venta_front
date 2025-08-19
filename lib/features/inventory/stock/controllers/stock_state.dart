import '../data/models/stock_item.dart';

class StockState {
  const StockState({
    this.items = const [],
    this.isLoading = false,
    this.error,
  });

  final List<StockItem> items;
  final bool isLoading;
  final String? error;

  StockState copyWith({
    List<StockItem>? items,
    bool? isLoading,
    String? error,
  }) => StockState(
        items: items ?? this.items,
        isLoading: isLoading ?? this.isLoading,
        error: error,
      );
}
