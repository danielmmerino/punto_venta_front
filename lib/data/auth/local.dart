class Local {
  const Local({required this.id, required this.nombre, this.empresaId});

  final int id;
  final String nombre;
  final int? empresaId;

  factory Local.fromJson(Map<String, dynamic> json) => Local(
        id: json['id'] as int,
        nombre: json['nombre'] as String,
        empresaId: json['empresa_id'] as int?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'nombre': nombre,
        if (empresaId != null) 'empresa_id': empresaId,
      };
}
