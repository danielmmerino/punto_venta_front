class Customer {
  Customer({
    required this.id,
    required this.tipo,
    required this.identificacion,
    required this.nombreRazon,
    this.email,
    this.telefono,
    this.direccion,
    required this.activo,
  });

  final int id;
  final String tipo;
  final String identificacion;
  final String nombreRazon;
  final String? email;
  final String? telefono;
  final String? direccion;
  final bool activo;

  factory Customer.fromJson(Map<String, dynamic> json) => Customer(
        id: json['id'] as int,
        tipo: json['tipo'] as String,
        identificacion: json['identificacion'] as String,
        nombreRazon: json['nombre_razon'] as String,
        email: json['email'] as String?,
        telefono: json['telefono'] as String?,
        direccion: json['direccion'] as String?,
        activo: json['activo'] as bool? ?? true,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'tipo': tipo,
        'identificacion': identificacion,
        'nombre_razon': nombreRazon,
        'email': email,
        'telefono': telefono,
        'direccion': direccion,
        'activo': activo,
      };

  Customer copyWith({
    int? id,
    String? tipo,
    String? identificacion,
    String? nombreRazon,
    String? email,
    String? telefono,
    String? direccion,
    bool? activo,
  }) =>
      Customer(
        id: id ?? this.id,
        tipo: tipo ?? this.tipo,
        identificacion: identificacion ?? this.identificacion,
        nombreRazon: nombreRazon ?? this.nombreRazon,
        email: email ?? this.email,
        telefono: telefono ?? this.telefono,
        direccion: direccion ?? this.direccion,
        activo: activo ?? this.activo,
      );
}
