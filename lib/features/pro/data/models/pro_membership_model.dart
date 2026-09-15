class ProMembershipModel {
  const ProMembershipModel({
    required this.isPro,
    required this.status,
    this.planId,
    this.planName,
    this.startedAt,
    this.expiresAt,
    this.autoRenew = false,
  });

  final bool isPro;
  final String status;
  final String? planId;
  final String? planName;
  final String? startedAt;
  final String? expiresAt;
  final bool autoRenew;

  factory ProMembershipModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const ProMembershipModel(isPro: false, status: 'none');
    }
    return ProMembershipModel(
      isPro: json['isPro'] == true || json['is_pro'] == true,
      status: (json['status'] ?? 'none').toString(),
      planId: _nullableString(json['planId'] ?? json['plan_id']),
      planName: _nullableString(json['planName'] ?? json['plan_name']),
      startedAt: _nullableString(json['startedAt'] ?? json['started_at']),
      expiresAt: _nullableString(json['expiresAt'] ?? json['expires_at']),
      autoRenew: json['autoRenew'] == true || json['auto_renew'] == true,
    );
  }

  static String? _nullableString(Object? value) {
    if (value == null) return null;
    final text = value.toString().trim();
    return text.isEmpty ? null : text;
  }
}
