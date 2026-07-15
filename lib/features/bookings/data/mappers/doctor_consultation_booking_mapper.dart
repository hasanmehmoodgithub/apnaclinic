import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;

import '../../../../generated/assets.dart';
import '../../../consultation/domain/entities/consultation_booking_list_entity.dart';
import '../models/doctor_consultation_booking_details_model.dart';

class DoctorConsultationBookingMapper {
  DoctorConsultationBookingMapper._();
  //

  static DoctorConsultationBookingDetailsModel fromEntity(
    ConsultationBookingListItemEntity entity,
  ) {
    final parsedDate = DateTime.tryParse(entity.slotDate);
    final listDate = parsedDate != null
        ? DateFormat('dd/MM/yy').format(parsedDate)
        : entity.slotDate;
    final listTime = _formatTimeRange(entity.slotStartTime, entity.slotEndTime);
    final appointmentMonth =
        parsedDate != null ? DateFormat('MMM').format(parsedDate) : '';
    final appointmentDay =
        parsedDate != null ? DateFormat('dd').format(parsedDate) : '';
    final appointmentWeekday =
        parsedDate != null ? DateFormat('EEEE').format(parsedDate) : '';
    final appointmentTime = listTime;
    final experience = entity.yearsOfExperience == null
        ? ''
        : '${entity.yearsOfExperience} '
            '${entity.yearsOfExperience == 1 ? 'Year' : 'Years'} Experience';
    final qualification = entity.qualifications.isNotEmpty
        ? entity.qualifications.join(', ')
        : entity.education;
    final payable = entity.consultationFee;
    final totalText = payable <= 0 ? 'Free' : 'Rs.$payable';
    final patient = entity.patientRelation.isNotEmpty
        ? _titleCase(entity.patientRelation)
        : 'Self';
    final issue = entity.issue.isNotEmpty ? entity.issue : '-';
    final review = entity.patientReview;
    final slotStartAt = _combineSlotDateTime(
      entity.slotDate,
      entity.slotStartTime,
    );
    final slotEndAt = _combineSlotDateTime(
      entity.slotDate,
      entity.slotEndTime,
    );

    return DoctorConsultationBookingDetailsModel(
      bookingId: entity.bookingId,
      doctorName: entity.doctorName,
      specialty: entity.specialty,
      experience: experience,
      qualification: qualification,
      doctorImageUrl: entity.doctorImageUrl,
      status: DoctorConsultationBookingStatus.fromApi(entity.status),
      listDate: listDate,
      listTime: listTime,
      appointmentMonth: appointmentMonth,
      appointmentDay: appointmentDay,
      appointmentWeekday: appointmentWeekday,
      appointmentTime: appointmentTime,
      patientLabel: patient,
      patientValue: patient,
      issueLabel: issue,
      issueValue: issue,
      consultationFee: payable,
      discountAmount: entity.discountAmount,
      originalFee: entity.originalFee > 0
          ? entity.originalFee
          : payable + entity.discountAmount,
      discountPercent: entity.discountPercent,
      totalText: totalText,
      partnerRefNo: entity.partnerRefNo,
      meetingLink: entity.consultationLink,
      ratings: entity.ratings,
      pmdcVerified: entity.pmdcVerified,
      partnerTenantId: entity.partnerTenantId,
      partnerLogoUrl: entity.partnerLogoUrl,
      attachments: entity.attachments,
      doctorPrescriptions: entity.doctorPrescriptions,
      patientReview: review == null
          ? null
          : DoctorConsultationBookingPatientReview(
              rating: review.rating,
              review: review.review,
              dateLabel: _formatReviewDate(review.date),
            ),
      slotStartAt: slotStartAt,
      slotEndAt: slotEndAt,
    );
  }

  static String attachmentDisplayName(String url, int index) {
    final name = p.basename(Uri.tryParse(url)?.path ?? url).trim();
    if (name.isNotEmpty) return name;
    return 'Document ${index + 1}';
  }

  static String prescriptionDisplayName(String url, int index) {
    final name = p.basename(Uri.tryParse(url)?.path ?? url).trim();
    if (name.isNotEmpty) {
      final lower = name.toLowerCase();
      if (lower.endsWith('.pdf') ||
          lower.endsWith('.png') ||
          lower.endsWith('.jpg') ||
          lower.endsWith('.jpeg') ||
          lower.endsWith('.webp')) {
        return name;
      }
    }
    return index == 0 ? 'Prescription.pdf' : 'Prescription ${index + 1}.pdf';
  }

  static bool isPdfUrl(String url) {
    final path = (Uri.tryParse(url)?.path ?? url).toLowerCase();
    return path.endsWith('.pdf');
  }

  static String fileTypeIconAsset(String url) {
    return isPdfUrl(url)
        ? Assets.consultationPdfIcon
        : Assets.consultationFileIcon;
  }

  static String _formatReviewDate(String raw) {
    final parsed = DateTime.tryParse(raw);
    if (parsed == null) return raw;
    return DateFormat('dd/MM/yyyy').format(parsed);
  }

  static String _titleCase(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return trimmed;
    return trimmed[0].toUpperCase() + trimmed.substring(1).toLowerCase();
  }

  static String _formatTimeRange(String startTime, String endTime) {
    if (startTime.isEmpty && endTime.isEmpty) return '';
    if (startTime.isNotEmpty && endTime.isNotEmpty) {
      return '${_formatSlotTime(startTime)} - ${_formatSlotTime(endTime)}';
    }
    return _formatSlotTime(startTime.isNotEmpty ? startTime : endTime);
  }

  static String _formatSlotTime(String raw) {
    final trimmed = raw.trim();
    if (trimmed.isEmpty) return trimmed;

    final upper = trimmed.toUpperCase();
    if (upper.contains('AM') || upper.contains('PM')) {
      return trimmed
          .replaceAllMapped(
            RegExp(r'\s*(AM|PM)$', caseSensitive: false),
            (match) => ' ${match.group(1)!.toLowerCase()}',
          )
          .replaceFirst(RegExp(r'^0'), '');
    }

    final parts = trimmed.split(':');
    if (parts.length < 2) return trimmed;

    var hour = int.tryParse(parts[0]) ?? 0;
    final minute = parts[1].replaceAll(RegExp(r'\D'), '').padLeft(2, '0');
    final period = hour >= 12 ? 'pm' : 'am';
    hour = hour % 12;
    if (hour == 0) hour = 12;
    return '$hour:$minute $period';
  }

  static DateTime? _combineSlotDateTime(String dateRaw, String timeRaw) {
    final date = DateTime.tryParse(dateRaw.trim());
    if (date == null) return null;
    final tod = _parseTimeParts(timeRaw);
    if (tod == null) return null;
    return DateTime(date.year, date.month, date.day, tod.$1, tod.$2);
  }

  static (int, int)? _parseTimeParts(String raw) {
    final trimmed = raw.trim();
    if (trimmed.isEmpty) return null;

    final match12 = RegExp(
      r'^(\d{1,2}):(\d{2})\s*(AM|PM)$',
      caseSensitive: false,
    ).firstMatch(trimmed);
    if (match12 != null) {
      var hour = int.tryParse(match12.group(1)!) ?? 0;
      final minute = int.tryParse(match12.group(2)!) ?? 0;
      final period = match12.group(3)!.toUpperCase();
      if (period == 'AM') {
        if (hour == 12) hour = 0;
      } else {
        if (hour != 12) hour += 12;
      }
      return (hour.clamp(0, 23), minute.clamp(0, 59));
    }

    final parts = trimmed.split(':');
    if (parts.length < 2) return null;
    final hour = int.tryParse(parts[0]);
    final minute = int.tryParse(parts[1].replaceAll(RegExp(r'\D'), ''));
    if (hour == null || minute == null) return null;
    return (hour.clamp(0, 23), minute.clamp(0, 59));
  }
}
