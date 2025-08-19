class ProductoVendido {
  const ProductoVendido({
    required this.productoId,
    required this.nombre,
    required this.unidades,
    required this.monto,
    this.margen,
  });

  final int productoId;
  final String nombre;
  final int unidades;
  final double monto;
  final double? margen;

  factory ProductoVendido.fromJson(Map<String, dynamic> json) => ProductoVendido(
        productoId: json['producto_id'] as int,
        nombre: json['nombre'] as String,
        unidades: json['unidades'] as int,
        monto: (json['monto'] as num).toDouble(),
        margen: (json['margen'] as num?)?.toDouble(),
      );
}
