import 'package:dio/dio.dart';
import 'package:intl/intl.dart';

import '../../domain/use_cases/submit_consultation_booking_use_case.dart';

Future<FormData> consultationBookingFormData(
  SubmitConsultationBookingParams params,
) async {
  final payload = <String, dynamic>{
    'doctorId': params.doctorId,
    'tenantId': params.tenantId,
    'consultationFee': params.consultationFee,
    'patientId': params.patientId,
    'patientRelation': params.patientRelation,
    'slotDate': params.slotDate,
    'slotStartTime': _normalizeTime(params.slotStartTime),
    'slotEndTime': _normalizeTime(params.slotEndTime),
    'paymentMethod': params.paymentMethod,
    'msisdn': params.msisdn,
  };

  if (params.attachments.isNotEmpty) {
    final files = <MultipartFile>[];
    for (final attachment in params.attachments) {
      final path = attachment.path.trim();
      if (path.isEmpty) continue;
      files.add(
        await MultipartFile.fromFile(
          path,
          filename: attachment.name,
        ),
      );
    }
    if (files.isNotEmpty) {
      payload['attachments'] = files;
    }
  }

  return FormData.fromMap(payload);
}

String _normalizeTime(String value) {
  final trimmed = value.trim();
  if (trimmed.isEmpty) return trimmed;

  final upper = trimmed.toUpperCase();
  if (upper.contains('AM') || upper.contains('PM')) {
    for (final pattern in ['h:mm a', 'hh:mm a']) {
      try {
        final parsed = DateFormat(pattern).parseLoose(trimmed);
        return DateFormat('HH:mm').format(parsed);
      } catch (_) {}
    }
  }

  final parts = trimmed.split(':');
  if (parts.length < 2) return trimmed;

  final hour = int.tryParse(parts[0]) ?? 0;
  final minute = int.tryParse(parts[1].replaceAll(RegExp(r'\D'), '')) ?? 0;
  return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
}
