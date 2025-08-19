import '../data/models/purchase.dart';

class PurchaseController {
  PurchaseController({List<PurchaseItem>? items})
      : items = items ?? [];

  final List<PurchaseItem> items;

  bool get canApprove => items.isNotEmpty;

  void approve() {
    if (items.isEmpty) {
      throw StateError('No hay líneas para aprobar');
    }
    // Aquí se llamaría al repositorio para aprobar la compra.
  }
}
