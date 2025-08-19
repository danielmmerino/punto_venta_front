class PurchaseItem {
  PurchaseItem({
    required this.productoId,
    required this.cantidad,
    required this.costo,
    this.impuesto,
  });

  final int productoId;
  final double cantidad;
  final double costo;
  final double? impuesto; // e.g. 0.12 for 12%

  double get subtotal => cantidad * costo;

  double get iva => impuesto != null ? subtotal * impuesto! : 0;

  double get total => subtotal + iva;

  Map<String, dynamic> toJson() => {
        'producto_id': productoId,
        'cantidad': cantidad,
        'costo': costo,
        if (impuesto != null) 'impuesto': impuesto,
      };
}

class Purchase {
  Purchase({
    required this.proveedorId,
    required this.bodegaId,
    required this.fecha,
    List<PurchaseItem>? items,
  }) : items = items ?? [];

  final int proveedorId;
  final int bodegaId;
  final DateTime fecha;
  final List<PurchaseItem> items;

  double get subtotal =>
      items.fold(0, (sum, item) => sum + item.subtotal);

  double get iva => items.fold(0, (sum, item) => sum + item.iva);

  double get total => subtotal + iva;

  Map<String, dynamic> toJson() => {
        'proveedor_id': proveedorId,
        'bodega_id': bodegaId,
        'fecha': fecha.toIso8601String().split('T').first,
        'items': items.map((e) => e.toJson()).toList(),
      };
}
