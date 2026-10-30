import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/analytics/analytics_event_keys.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/utils/auth_guard.dart';
import '../domain/entities/consultation_selected_slot_entity.dart';
import 'doctor_consultation_book_doctor_args.dart';
import 'widgets/results_doctor_item.dart';

/// Parsed `apnaclinic://doctor/{id}?step=checkout&date=&start=&end=`.
class ConsultationCheckoutDeepLink {
  const ConsultationCheckoutDeepLink({
    required this.doctorId,
    this.date,
    this.start,
    this.end,
  });

  final String doctorId;
  final String? date;
  final String? start;
  final String? end;

  bool get hasSlot =>
      (date ?? '').trim().isNotEmpty &&
      (start ?? '').trim().isNotEmpty &&
      (end ?? '').trim().isNotEmpty;

  static ConsultationCheckoutDeepLink? tryParse(String raw) {
    final uri = Uri.tryParse(raw.trim());
    if (uri == null) return null;
    if (uri.scheme.toLowerCase() != 'apnaclinic') return null;

    final host = uri.host.toLowerCase();
    final segments = uri.pathSegments
        .where((part) => part.trim().isNotEmpty)
        .toList();

    String? doctorId;
    if (host == 'doctor' && segments.isNotEmpty) {
      doctorId = segments.first.trim();
    } else if (segments.length >= 2 && segments.first.toLowerCase() == 'doctor') {
      doctorId = segments[1].trim();
    }
    if (doctorId == null || doctorId.isEmpty) return null;

    final params = uri.queryParameters;
    return ConsultationCheckoutDeepLink(
      doctorId: doctorId,
      date: params['date']?.trim(),
      start: params['start']?.trim(),
      end: params['end']?.trim(),
    );
  }
}

/// Opens the doctor consultation booking screen with slot prefill when present.
void consultationOpenBookFromDeepLink(
  BuildContext context, {
  required String url,
  String? doctorName,
  String? feeHint,
}) {
  if (!context.requireLogin(
    loginSource: AnalyticsAuthSourceKeys.consultancy,
  )) {
    return;
  }

  final deepLink = ConsultationCheckoutDeepLink.tryParse(url);
  if (deepLink == null) return;

  final name = (doctorName ?? '').trim();
  final feeRaw = (feeHint ?? '').trim();
  final fee = feeRaw.isEmpty
      ? ''
      : (feeRaw.toUpperCase().startsWith('PKR') ? feeRaw : 'PKR $feeRaw');

  ConsultationSelectedSlotEntity? initialSlot;
  if (deepLink.hasSlot) {
    final start = deepLink.start!;
    final end = deepLink.end!;
    initialSlot = ConsultationSelectedSlotEntity(
      date: deepLink.date!,
      startTime: start,
      endTime: end,
      label: '$start – $end',
    );
  }

  context.pushNamed(
    AppRoutes.consultationBookDoctor,
    extra: DoctorConsultationBookDoctorArgs(
      doctor: ResultsDoctorItem(
        id: deepLink.doctorId,
        apiDoctorId: deepLink.doctorId,
        name: name.isEmpty ? 'Doctor' : name,
        specialty: '',
        experience: '',
        qualification: '',
        fee: fee,
        oldFee: '',
        partner: '',
        rating: '',
        imageUrl: '',
      ),
      initialSelectedSlot: initialSlot,
      moduleSource: AnalyticsConsultancySourceKeys.home,
      hydrateDoctorFromDetailApi: true,
    ),
  );
}
