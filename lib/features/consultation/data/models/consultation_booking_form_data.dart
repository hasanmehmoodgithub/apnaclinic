import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;

import '../../domain/use_cases/submit_consultation_booking_use_case.dart';

/// Same pattern as [profileSetupSaveFormData]: fields + files in one map → [FormData.fromMap].
Future<FormData> consultationBookingFormData(
  SubmitConsultationBookingParams params,
) async {
  final payload = <String, dynamic>{
    'doctorId': '${params.doctorId}',
    'tenantId': '${params.tenantId}',
    'consultationFee': '${params.consultationFee}',
    'patientId': '${params.patientId}',
    'patientRelation': params.patientRelation,
    'slotDate': params.slotDate,
    'slotStartTime': _to12HourAmPm(params.slotStartTime),
    'slotEndTime': _to12HourAmPm(params.slotEndTime),
    'paymentMethod': params.paymentMethod,
    'msisdn': params.msisdn,
    'issue': params.issue,
  };

  final attachmentFiles = <MultipartFile>[];
  for (final attachment in params.attachments) {
    final path = attachment.path.trim();
    if (path.isEmpty) continue;

    final filename = attachment.name.trim().isNotEmpty
        ? attachment.name.trim()
        : p.basename(path);

    attachmentFiles.add(
      await MultipartFile.fromFile(path, filename: filename),
    );
  }

  if (attachmentFiles.length == 1) {
    payload['attachments'] = attachmentFiles.first;
  } else if (attachmentFiles.length > 1) {
    payload['attachments'] = attachmentFiles;
  }

  return FormData.fromMap(payload);
}

/// Normalizes to API-style 12h time, e.g. `03:50 PM`.
String _to12HourAmPm(String value) {
  final trimmed = value.trim();
  if (trimmed.isEmpty) return trimmed;

  final upper = trimmed.toUpperCase();
  if (upper.contains('AM') || upper.contains('PM')) {
    for (final pattern in ['h:mm a', 'hh:mm a']) {
      try {
        final parsed = DateFormat(pattern).parseLoose(trimmed);
        return DateFormat('hh:mm a').format(parsed);
      } catch (_) {}
    }
    return trimmed;
  }

  final parts = trimmed.split(':');
  if (parts.length < 2) return trimmed;

  final hour = int.tryParse(parts[0]);
  final minute = int.tryParse(parts[1].replaceAll(RegExp(r'\D'), ''));
  if (hour == null || minute == null) return trimmed;

  final parsed = DateTime(2026, 1, 1, hour, minute);
  return DateFormat('hh:mm a').format(parsed);
}
