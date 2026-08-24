import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/l10n/app_localizations.dart';

class InstantDoctorBookingStatusPillWidget extends StatelessWidget {
  const InstantDoctorBookingStatusPillWidget({
    super.key,
    required this.status,
  });

  final String status;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final kind = InstantDoctorBookingStatusKind.fromStatus(status);
    final (bg, fg, label) = switch (kind) {
      InstantDoctorBookingStatusKind.pending => (
          AppColors.clrFFF4E5,
          AppColors.clrC85600,
          l10n.bookingsStatusPending,
        ),
      InstantDoctorBookingStatusKind.confirmed => (
          AppColors.clrDEF8FB,
          AppColors.clr15A9A0,
          l10n.bookingsStatusConfirmed,
        ),
      InstantDoctorBookingStatusKind.failed => (
          AppColors.clrFBDEDE,
          AppColors.clrBA2025,
          _failedLabel(status, l10n),
        ),
      InstantDoctorBookingStatusKind.completed => (
          AppColors.clrE5F7EA,
          AppColors.clr1F8F4A,
          l10n.bookingsStatusCompleted,
        ),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: fg,
              fontWeight: FontWeight.w500,
            ),
      ),
    );
  }

  static String _failedLabel(String raw, AppLocalizations l10n) {
    final key = raw.trim().toUpperCase().replaceAll(RegExp(r'[\s\-]+'), '_');
    if (key == 'CANCELLED' || key == 'CANCELED' || key == 'CANCEL') {
      return l10n.bookingsStatusCancel;
    }
    if (key == 'FAILED') return l10n.bookingsStatusFailed;
    return raw.trim().isEmpty ? l10n.bookingsStatusFailed : raw.trim();
  }
}

enum InstantDoctorBookingStatusKind {
  pending,
  confirmed,
  failed,
  completed;

  static InstantDoctorBookingStatusKind fromStatus(String raw) {
    final key = raw.trim().toUpperCase().replaceAll(RegExp(r'[\s\-]+'), '_');
    switch (key) {
      case 'CONFIRMED':
      case 'PAID':
      case 'SUCCESS':
        return InstantDoctorBookingStatusKind.confirmed;
      case 'COMPLETED':
        return InstantDoctorBookingStatusKind.completed;
      case 'FAILED':
      case 'CANCELLED':
      case 'CANCELED':
      case 'CANCEL':
      case 'REJECTED':
        return InstantDoctorBookingStatusKind.failed;
      default:
        return InstantDoctorBookingStatusKind.pending;
    }
  }
}
