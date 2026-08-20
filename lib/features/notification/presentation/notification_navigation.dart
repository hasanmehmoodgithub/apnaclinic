import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/app_localizations.dart';
import '../../../core/router/app_routes.dart';
import '../../bookings/data/models/surgery_details_item.dart';
import '../../bookings/presentation/doctor_consultation_booking_details_args.dart';
import '../../bookings/presentation/widgets/alert_dialog_card.dart';
import '../../lab_test/presentation/lab_test_route_args.dart';
import '../domain/entities/notification_entity.dart';

/// Opens the booking / order screen for a notification's `serviceType`.
///
/// Prefers `deepLink.data.unified_order_id`; falls back to `entity.id` /
/// `entity_id` when the unified id is missing. Pharmacy uses
/// `deepLink.entity.publicId`.
///
/// Returns `true` when navigation was started; `false` when the notification
/// cannot be routed (missing booking id, unsupported service type, etc.).
bool openNotificationDeepLink(
  BuildContext context,
  NotificationEntity item,
) {
  final bookingId = _bookingId(item);
  if (bookingId.isEmpty) return false;

  final service = item.serviceType.trim().toUpperCase();
  switch (service) {
    case 'CONSULTATION':
      context.pushNamed(
        AppRoutes.doctorConsultationBookingDetails,
        extra: DoctorConsultationBookingDetailsArgs(bookingId: bookingId),
      );
      return true;
    case 'SURGERY':
      context.pushNamed(
        AppRoutes.surgeryBookingDetails,
        extra: SurgeryBookingDetailsArgs(
          leadId: bookingId,
          item: _placeholderSurgeryItem(bookingId),
          initialStatus: SurgeryBookingStatus.inReview,
        ),
      );
      return true;
    case 'LAB':
      context.pushNamed(
        AppRoutes.labTestViewDetails,
        extra: LabTestViewDetailsArgs(orderId: bookingId),
      );
      return true;
    case 'PHARMACY':
      final pharmacyOrderId = item.entityPublicId.trim().isNotEmpty
          ? item.entityPublicId.trim()
          : bookingId;
      if (pharmacyOrderId.isEmpty) return false;
      context.pushNamed(
        AppRoutes.pharmacyBookingDetails,
        extra: {
          'orderId': pharmacyOrderId,
        },
      );
      return true;
    default:
      return false;
  }
}

String _bookingId(NotificationEntity item) {
  final unified = item.unifiedOrderId.trim();
  if (unified.isNotEmpty) return unified;
  return item.entityId.trim();
}

/// Shows notification content when deep link routing is unavailable.
Future<void> showNotificationUnavailableDialog(
  BuildContext context,
  NotificationEntity item,
) {
  final l10n = AppLocalizations.of(context)!;
  final title = item.title.trim().isNotEmpty
      ? item.title.trim()
      : l10n.notificationsDeepLinkUnavailableTitle;
  final message = item.message.trim().isNotEmpty
      ? item.message.trim()
      : l10n.notificationsDeepLinkUnavailableMessage;

  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    useRootNavigator: true,
    builder: (_) => AlertDialogCard(
      kind: AlertKind.error,
      title: title,
      message: message,
    ),
  );
}

SurgeryDetailsItem _placeholderSurgeryItem(String leadId) {
  return SurgeryDetailsItem(
    leadId: leadId,
    procedure: '',
    procedureSubtitle: '',
    hospital: '',
    doctor: '',
    specialty: '',
    qualification: '',
    status: '',
    dateCreated: '',
    patientName: '',
    age: 0,
    gender: '',
    contactNumber: '',
    emergencyContact: '',
    fee: 0,
    discountPercent: 0,
    discountAmount: 0,
    total: 0,
    paymentAllowed: false,
    appointmentDay: '',
    appointmentMonth: '',
    appointmentWeekday: '',
    appointmentTime: '',
    appointmentSubtitle: '',
    appointmentDateFull: '',
    partnerLogoUrl: '',
  );
}
