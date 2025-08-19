class SubscriptionStatus {
  const SubscriptionStatus({required this.vigente, this.estado, this.fechaFin});

  final bool vigente;
  final String? estado;
  final String? fechaFin;

  factory SubscriptionStatus.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('vigente')) {
      return SubscriptionStatus(
        vigente: json['vigente'] as bool,
        estado: json['estado'] as String?,
        fechaFin: json['fecha_fin'] as String? ?? json['next_renewal_at'] as String?,
      );
    }
    final estado = json['estado'] as String?;
    return SubscriptionStatus(
      vigente: estado == 'active',
      estado: estado,
      fechaFin: json['next_renewal_at'] as String?,
    );
  }
}
