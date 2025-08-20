class MenuItem {
  MenuItem({
    required this.id,
    required this.codigo,
    required this.nombre,
    this.descripcion,
    required this.tipo,
    required this.precioVenta,
    required this.impuestoId,
    required this.categoriaNombre,
    required this.impuestoCodigo,
    required this.impuestoPorcentaje,
    required this.stockLocal,
  });

  final int id;
  final String codigo;
  final String nombre;
  final String? descripcion;
  final String tipo;
  final double precioVenta;
  final int impuestoId;
  final String categoriaNombre;
  final String impuestoCodigo;
  final double impuestoPorcentaje;
  final double stockLocal;

  factory MenuItem.fromJson(Map<String, dynamic> json) => MenuItem(
        id: json['id'] as int,
        codigo: json['codigo'] as String,
        nombre: json['nombre'] as String,
        descripcion: json['descripcion'] as String?,
        tipo: json['tipo'] as String,
        precioVenta: (json['precio_venta'] as num).toDouble(),
        impuestoId: json['impuesto_id'] as int,
        categoriaNombre: json['categoria_nombre'] as String,
        impuestoCodigo: json['impuesto_codigo'] as String,
        impuestoPorcentaje:
            (double.tryParse(json['impuesto_porcentaje'].toString()) ?? 0),
        stockLocal: (double.tryParse(json['stock_local'].toString()) ?? 0),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'codigo': codigo,
        'nombre': nombre,
        'descripcion': descripcion,
        'tipo': tipo,
        'precio_venta': precioVenta,
        'impuesto_id': impuestoId,
        'categoria_nombre': categoriaNombre,
        'impuesto_codigo': impuestoCodigo,
        'impuesto_porcentaje': impuestoPorcentaje,
        'stock_local': stockLocal,
      };

  MenuItem copyWith({
    int? id,
    String? codigo,
    String? nombre,
    String? descripcion,
    String? tipo,
    double? precioVenta,
    int? impuestoId,
    String? categoriaNombre,
    String? impuestoCodigo,
    double? impuestoPorcentaje,
    double? stockLocal,
  }) {
    return MenuItem(
      id: id ?? this.id,
      codigo: codigo ?? this.codigo,
      nombre: nombre ?? this.nombre,
      descripcion: descripcion ?? this.descripcion,
      tipo: tipo ?? this.tipo,
      precioVenta: precioVenta ?? this.precioVenta,
      impuestoId: impuestoId ?? this.impuestoId,
      categoriaNombre: categoriaNombre ?? this.categoriaNombre,
      impuestoCodigo: impuestoCodigo ?? this.impuestoCodigo,
      impuestoPorcentaje: impuestoPorcentaje ?? this.impuestoPorcentaje,
      stockLocal: stockLocal ?? this.stockLocal,
    );
  }
}
