class Role {
  Role({
    required this.codigo,
    required this.nombre,
    this.permisos = const [],
  });

  final String codigo;
  final String nombre;
  final List<String> permisos;

  factory Role.fromJson(Map<String, dynamic> json) => Role(
        codigo: json['codigo'] as String,
        nombre: json['nombre'] as String,
        permisos: (json['permisos'] as List<dynamic>? ?? []).cast<String>(),
      );

  Map<String, dynamic> toJson() => {
        'codigo': codigo,
        'nombre': nombre,
        'permisos': permisos,
      };

  Role copyWith({
    String? codigo,
    String? nombre,
    List<String>? permisos,
  }) =>
      Role(
        codigo: codigo ?? this.codigo,
        nombre: nombre ?? this.nombre,
        permisos: permisos ?? this.permisos,
      );
}
