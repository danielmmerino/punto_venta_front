class SubscriptionInfo {
  const SubscriptionInfo({
    required this.estado,
    this.trialEndsAt,
    this.nextRenewalAt,
  });

  final String estado;
  final String? trialEndsAt;
  final String? nextRenewalAt;

  factory SubscriptionInfo.fromJson(Map<String, dynamic> json) {
    final vig = json['vigente'];
    String? estado = json['estado'] as String?;
    if (estado == null) {
      bool vigente = false;
      if (vig is bool) {
        vigente = vig;
      } else if (vig is num) {
        vigente = vig != 0;
      } else if (vig != null) {
        vigente = vig.toString() == '1';
      }
      estado = vigente ? 'active' : 'inactive';
    }
    return SubscriptionInfo(
      estado: estado,
      trialEndsAt: json['trial_ends_at'] as String?,
      nextRenewalAt: json['next_renewal_at'] as String?,
    );
  }
}
