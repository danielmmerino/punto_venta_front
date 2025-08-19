class Local {
  const Local({required this.id, required this.nombre, required this.empresaId});

  final int id;
  final String nombre;
  final int empresaId;

  factory Local.fromJson(Map<String, dynamic> json) => Local(
        id: json['id'] as int,
        nombre: json['nombre'] as String,
        empresaId: json['empresa_id'] as int? ?? json['empresaId'] as int? ?? 0,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'nombre': nombre,
        'empresa_id': empresaId,
      };
}
