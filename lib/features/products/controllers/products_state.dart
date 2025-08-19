import '../data/models/product.dart';

class ProductsState {
  const ProductsState({
    this.items = const [],
    this.isLoading = false,
    this.error,
    this.fieldErrors = const {},
  });

  final List<Product> items;
  final bool isLoading;
  final String? error;
  final Map<String, List<String>> fieldErrors;

  ProductsState copyWith({
    List<Product>? items,
    bool? isLoading,
    String? error,
    Map<String, List<String>>? fieldErrors,
  }) => ProductsState(
        items: items ?? this.items,
        isLoading: isLoading ?? this.isLoading,
        error: error,
        fieldErrors: fieldErrors ?? this.fieldErrors,
      );
}
