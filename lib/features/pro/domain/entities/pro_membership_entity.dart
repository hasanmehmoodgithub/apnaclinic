import 'package:equatable/equatable.dart';

class ProMembershipEntity extends Equatable {
  const ProMembershipEntity({
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

  /// Active (or cancelled-but-still-entitled) Pro membership.
  bool get isActivePro {
    if (!isPro) return false;
    final normalized = status.trim().toLowerCase();
    return normalized == 'active' || normalized == 'cancelled';
  }

  @override
  List<Object?> get props => [
        isPro,
        status,
        planId,
        planName,
        startedAt,
        expiresAt,
        autoRenew,
      ];
}
