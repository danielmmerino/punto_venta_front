class User {
  User({
    required this.id,
    required this.nombres,
    required this.apellidos,
    required this.email,
    this.telefono,
    required this.estado,
    this.roles = const [],
    this.locales = const [],
  });

  final int id;
  final String nombres;
  final String apellidos;
  final String email;
  final String? telefono;
  final String estado;
  final List<String> roles;
  final List<int> locales;

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json['id'] as int,
        nombres: json['nombres'] as String,
        apellidos: json['apellidos'] as String,
        email: json['email'] as String,
        telefono: json['telefono'] as String?,
        estado: json['estado'] as String,
        roles: (json['roles'] as List<dynamic>? ?? []).cast<String>(),
        locales: (json['locales'] as List<dynamic>? ?? []).cast<int>(),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'nombres': nombres,
        'apellidos': apellidos,
        'email': email,
        'telefono': telefono,
        'estado': estado,
        'roles': roles,
        'locales': locales,
      };

  User copyWith({
    int? id,
    String? nombres,
    String? apellidos,
    String? email,
    String? telefono,
    String? estado,
    List<String>? roles,
    List<int>? locales,
  }) =>
      User(
        id: id ?? this.id,
        nombres: nombres ?? this.nombres,
        apellidos: apellidos ?? this.apellidos,
        email: email ?? this.email,
        telefono: telefono ?? this.telefono,
        estado: estado ?? this.estado,
        roles: roles ?? this.roles,
        locales: locales ?? this.locales,
      );
}
