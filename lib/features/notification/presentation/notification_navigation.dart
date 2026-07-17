import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/app_localizations.dart';
import '../../../core/router/app_routes.dart';
import '../../bookings/data/models/surgery_details_item.dart';
import '../../bookings/presentation/doctor_consultation_booking_details_args.dart';
import '../../lab_test/presentation/lab_test_route_args.dart';
import '../domain/entities/notification_entity.dart';

/// Opens the booking / order screen for a notification's `serviceType` + `entityId`.
void openNotificationDeepLink(
  BuildContext context,
  NotificationEntity item,
) {
  final entityId = item.entityId.trim();
  if (entityId.isEmpty) return;

  final service = item.serviceType.trim().toUpperCase();
  switch (service) {
    case 'CONSULTATION':
      context.pushNamed(
        AppRoutes.doctorConsultationBookingDetails,
        extra: DoctorConsultationBookingDetailsArgs(bookingId: entityId),
      );
      return;
    case 'SURGERY':
      context.pushNamed(
        AppRoutes.surgeryBookingDetails,
        extra: SurgeryBookingDetailsArgs(
          leadId: entityId,
          item: _placeholderSurgeryItem(entityId),
          initialStatus: SurgeryBookingStatus.inReview,
        ),
      );
      return;
    case 'LAB':
      final l10n = AppLocalizations.of(context)!;
      context.pushNamed(
        AppRoutes.labTestViewDetails,
        extra: LabTestViewDetailsArgs(
          testTitle: item.title,
          labName: '',
          labLogoUrl: '',
          partnerLogoUrl: '',
          sampleType: l10n.labTestSampleTypeNotAvailable,
          discountedFee: '',
          originalFee: '',
          discountCode: '',
          patientName: '',
          patientAge: 0,
          patientGender: '',
          patientPhone: '',
          orderNo: entityId,
          bookingDate: item.dateLabel,
          statusLabel: item.type.replaceAll('_', ' '),
          note: item.message,
        ),
      );
      return;
    case 'PHARMACY':
      context.pushNamed(
        AppRoutes.pharmacyBookingDetails,
        extra: {
          'orderNo': entityId,
          'status': 'confirmed',
        },
      );
      return;
    default:
      return;
  }
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
