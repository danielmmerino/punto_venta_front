import '../data/models/menu_item.dart';

class OrderLine {
  OrderLine({required this.item, this.quantity = 1});

  final MenuItem item;
  final int quantity;

  double get lineTotal => item.precioVenta * quantity;

  OrderLine copyWith({MenuItem? item, int? quantity}) => OrderLine(
        item: item ?? this.item,
        quantity: quantity ?? this.quantity,
      );
}

class OrderState {
  const OrderState({
    this.menu = const [],
    this.items = const [],
    this.isLoading = false,
    this.error,
  });

  final List<MenuItem> menu;
  final List<OrderLine> items;
  final bool isLoading;
  final String? error;

  double get total =>
      items.fold(0, (previous, e) => previous + e.lineTotal);

  OrderState copyWith({
    List<MenuItem>? menu,
    List<OrderLine>? items,
    bool? isLoading,
    String? error,
  }) =>
      OrderState(
        menu: menu ?? this.menu,
        items: items ?? this.items,
        isLoading: isLoading ?? this.isLoading,
        error: error,
      );
}
