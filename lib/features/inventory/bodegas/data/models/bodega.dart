class Bodega {
  const Bodega({
    required this.id,
    required this.codigo,
    required this.nombre,
    this.zona,
    required this.activo,
  });

  final int id;
  final String codigo;
  final String nombre;
  final String? zona;
  final bool activo;

  factory Bodega.fromJson(Map<String, dynamic> json) => Bodega(
        id: json['id'] as int,
        codigo: json['codigo'] as String,
        nombre: json['nombre'] as String,
        zona: json['zona'] as String?,
        activo: json['activo'] as bool? ?? true,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'codigo': codigo,
        'nombre': nombre,
        if (zona != null) 'zona': zona,
        'activo': activo,
      };
}
