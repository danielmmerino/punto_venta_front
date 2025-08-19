class Product {
  Product({
    required this.id,
    required this.codigo,
    required this.nombre,
    this.descripcion,
    required this.categoriaId,
    this.categoriaNombre,
    required this.unidadId,
    this.unidadCodigo,
    required this.impuestoId,
    this.impuestoCodigo,
    required this.precio,
    required this.activo,
  });

  final int id;
  final String codigo;
  final String nombre;
  final String? descripcion;
  final int categoriaId;
  final String? categoriaNombre;
  final int unidadId;
  final String? unidadCodigo;
  final int impuestoId;
  final String? impuestoCodigo;
  final double precio;
  final bool activo;

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json['id'] as int,
        codigo: json['codigo'] as String,
        nombre: json['nombre'] as String,
        descripcion: json['descripcion'] as String?,
        categoriaId: json['categoria_id'] as int,
        categoriaNombre: json['categoria_nombre'] as String?,
        unidadId: json['unidad_id'] as int,
        unidadCodigo: json['unidad_codigo'] as String?,
        impuestoId: json['impuesto_id'] as int,
        impuestoCodigo: json['impuesto_codigo'] as String?,
        precio: (json['precio'] as num).toDouble(),
        activo: json['activo'] as bool,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'codigo': codigo,
        'nombre': nombre,
        'descripcion': descripcion,
        'categoria_id': categoriaId,
        'categoria_nombre': categoriaNombre,
        'unidad_id': unidadId,
        'unidad_codigo': unidadCodigo,
        'impuesto_id': impuestoId,
        'impuesto_codigo': impuestoCodigo,
        'precio': precio,
        'activo': activo,
      };

  Product copyWith({
    int? id,
    String? codigo,
    String? nombre,
    String? descripcion,
    int? categoriaId,
    String? categoriaNombre,
    int? unidadId,
    String? unidadCodigo,
    int? impuestoId,
    String? impuestoCodigo,
    double? precio,
    bool? activo,
  }) {
    return Product(
      id: id ?? this.id,
      codigo: codigo ?? this.codigo,
      nombre: nombre ?? this.nombre,
      descripcion: descripcion ?? this.descripcion,
      categoriaId: categoriaId ?? this.categoriaId,
      categoriaNombre: categoriaNombre ?? this.categoriaNombre,
      unidadId: unidadId ?? this.unidadId,
      unidadCodigo: unidadCodigo ?? this.unidadCodigo,
      impuestoId: impuestoId ?? this.impuestoId,
      impuestoCodigo: impuestoCodigo ?? this.impuestoCodigo,
      precio: precio ?? this.precio,
      activo: activo ?? this.activo,
    );
  }
}
