class StockItem {
  const StockItem({
    required this.productoId,
    required this.codigo,
    required this.nombre,
    required this.unidadCodigo,
    required this.stock,
    this.reservado,
    this.disponible,
  });

  final int productoId;
  final String codigo;
  final String nombre;
  final String unidadCodigo;
  final double stock;
  final double? reservado;
  final double? disponible;

  factory StockItem.fromJson(Map<String, dynamic> json) => StockItem(
        productoId: json['producto_id'] as int,
        codigo: json['codigo'] as String? ?? '',
        nombre: json['nombre'] as String? ?? '',
        unidadCodigo: json['unidad_codigo'] as String? ?? '',
        stock: (json['stock'] as num).toDouble(),
        reservado: (json['reservado'] as num?)?.toDouble(),
        disponible: (json['disponible'] as num?)?.toDouble(),
      );
}
