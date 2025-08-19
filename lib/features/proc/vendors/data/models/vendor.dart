class Vendor {
  Vendor({
    required this.id,
    required this.ruc,
    required this.razonSocial,
    this.email,
    this.telefono,
    this.direccion,
    required this.activo,
  });

  final int id;
  final String ruc;
  final String razonSocial;
  final String? email;
  final String? telefono;
  final String? direccion;
  final bool activo;

  factory Vendor.fromJson(Map<String, dynamic> json) => Vendor(
        id: json['id'] as int,
        ruc: json['ruc'] as String,
        razonSocial: json['razon_social'] as String,
        email: json['email'] as String?,
        telefono: json['telefono'] as String?,
        direccion: json['direccion'] as String?,
        activo: json['activo'] as bool? ?? true,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'ruc': ruc,
        'razon_social': razonSocial,
        'email': email,
        'telefono': telefono,
        'direccion': direccion,
        'activo': activo,
      };

  Vendor copyWith({
    int? id,
    String? ruc,
    String? razonSocial,
    String? email,
    String? telefono,
    String? direccion,
    bool? activo,
  }) =>
      Vendor(
        id: id ?? this.id,
        ruc: ruc ?? this.ruc,
        razonSocial: razonSocial ?? this.razonSocial,
        email: email ?? this.email,
        telefono: telefono ?? this.telefono,
        direccion: direccion ?? this.direccion,
        activo: activo ?? this.activo,
      );
}
