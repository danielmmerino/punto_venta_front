class SubscriptionInfo {
  const SubscriptionInfo({
    required this.estado,
    this.trialEndsAt,
    this.nextRenewalAt,
  });

  final String estado;
  final String? trialEndsAt;
  final String? nextRenewalAt;

  factory SubscriptionInfo.fromJson(Map<String, dynamic> json) => SubscriptionInfo(
        estado: json['estado'] as String,
        trialEndsAt: json['trial_ends_at'] as String?,
        nextRenewalAt: json['next_renewal_at'] as String?,
      );
}
