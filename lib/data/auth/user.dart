class User {
  const User({
    required this.id,
    required this.nombre,
    required this.email,
    this.permisos = const [],
  });

  final int id;
  final String nombre;
  final String email;
  final List<String> permisos;

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json['id'] as int,
        nombre: json['nombre'] as String,
        email: json['email'] as String,
        permisos:
            (json['permisos'] as List<dynamic>? ?? []).cast<String>(),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'nombre': nombre,
        'email': email,
        'permisos': permisos,
      };
}
