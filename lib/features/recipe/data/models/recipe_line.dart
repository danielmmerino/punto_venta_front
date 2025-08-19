class RecipeLine {
  RecipeLine({
    required this.insumoId,
    this.insumoCodigo,
    this.insumoNombre,
    this.unidadId,
    this.unidadCodigo,
    required this.cantidad,
    required this.mermaPorcentaje,
  });

  final int insumoId;
  final String? insumoCodigo;
  final String? insumoNombre;
  final int? unidadId;
  final String? unidadCodigo;
  final double cantidad;
  final double mermaPorcentaje;

  factory RecipeLine.fromJson(Map<String, dynamic> json) => RecipeLine(
        insumoId: json['insumo_id'] as int,
        insumoCodigo: json['insumo_codigo'] as String?,
        insumoNombre: json['insumo_nombre'] as String?,
        unidadId: json['unidad_id'] as int?,
        unidadCodigo: json['unidad_codigo'] as String?,
        cantidad: (json['cantidad'] as num).toDouble(),
        mermaPorcentaje: (json['merma_porcentaje'] as num).toDouble(),
      );

  Map<String, dynamic> toJson() => {
        'insumo_id': insumoId,
        'insumo_codigo': insumoCodigo,
        'insumo_nombre': insumoNombre,
        'unidad_id': unidadId,
        'unidad_codigo': unidadCodigo,
        'cantidad': cantidad,
        'merma_porcentaje': mermaPorcentaje,
      };

  RecipeLine copyWith({
    int? insumoId,
    String? insumoCodigo,
    String? insumoNombre,
    int? unidadId,
    String? unidadCodigo,
    double? cantidad,
    double? mermaPorcentaje,
  }) {
    return RecipeLine(
      insumoId: insumoId ?? this.insumoId,
      insumoCodigo: insumoCodigo ?? this.insumoCodigo,
      insumoNombre: insumoNombre ?? this.insumoNombre,
      unidadId: unidadId ?? this.unidadId,
      unidadCodigo: unidadCodigo ?? this.unidadCodigo,
      cantidad: cantidad ?? this.cantidad,
      mermaPorcentaje: mermaPorcentaje ?? this.mermaPorcentaje,
    );
  }

  Map<String, dynamic> toPayload() => {
        'insumo_id': insumoId,
        'cantidad': cantidad,
        'merma_porcentaje': mermaPorcentaje,
      };
}
