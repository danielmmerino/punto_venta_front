class CajaEstado {
  const CajaEstado({
    required this.abierta,
    this.aperturaId,
  });

  final bool abierta;
  final int? aperturaId;

  factory CajaEstado.fromJson(Map<String, dynamic> json) => CajaEstado(
        abierta: json['abierta'] as bool,
        aperturaId: json['apertura_id'] as int?,
      );
}
