import '../../products/data/models/product.dart';

class LineItem {
  LineItem({this.product, this.quantity = 0, this.cost});

  Product? product;
  double quantity;
  double? cost;
}
