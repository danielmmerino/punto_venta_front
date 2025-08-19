import 'package:collection/collection.dart';

enum QuoteStatus { draft, sent, accepted, rejected, expired }

class QuoteItem {
  QuoteItem({
    required this.productoId,
    required this.cantidad,
    required this.precio,
    this.descuento = 0,
  }) : assert(cantidad > 0), assert(precio >= 0);

  final int productoId;
  final double cantidad;
  final double precio;
  final double descuento;

  double get subtotal => cantidad * precio;
  double get descuentoTotal => subtotal * descuento;
  double get total => subtotal - descuentoTotal;
}

class Quote {
  Quote({
    required this.clienteId,
    required this.validezDias,
    this.notas,
    List<QuoteItem>? items,
    this.estado = QuoteStatus.draft,
  }) : items = items ?? [];

  final int clienteId;
  final int validezDias;
  final String? notas;
  final List<QuoteItem> items;
  QuoteStatus estado;

  double get subtotal => items.map((i) => i.subtotal).sum;
  double get descuento => items.map((i) => i.descuentoTotal).sum;
  double get impuestos => 0;
  double get total => subtotal - descuento + impuestos;
}
