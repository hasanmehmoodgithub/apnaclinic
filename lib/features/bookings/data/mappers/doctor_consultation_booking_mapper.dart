import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;

import '../../../consultation/domain/entities/consultation_booking_list_entity.dart';
import '../models/doctor_consultation_booking_details_model.dart';

class DoctorConsultationBookingMapper {
  DoctorConsultationBookingMapper._();

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
      ratings: entity.ratings,
      pmdcVerified: entity.pmdcVerified,
      partnerTenantId: entity.partnerTenantId,
      partnerLogoUrl: entity.partnerLogoUrl,
      attachments: entity.attachments,
      patientReview: review == null
          ? null
          : DoctorConsultationBookingPatientReview(
              rating: review.rating,
              review: review.review,
              dateLabel: _formatReviewDate(review.date),
            ),
    );
  }

  static String attachmentDisplayName(String url, int index) {
    final name = p.basename(Uri.tryParse(url)?.path ?? url).trim();
    if (name.isNotEmpty) return name;
    return 'Document ${index + 1}';
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
      return '${_formatTime12h(startTime)} - ${_formatTime12h(endTime)}';
    }
    return _formatTime12h(startTime.isNotEmpty ? startTime : endTime);
  }

  static String _formatTime12h(String time24) {
    final parts = time24.split(':');
    if (parts.length < 2) return time24;

    var hour = int.tryParse(parts[0]) ?? 0;
    final minute = parts[1].padLeft(2, '0');
    final period = hour >= 12 ? 'PM' : 'AM';
    hour = hour % 12;
    if (hour == 0) hour = 12;
    return '$hour:$minute $period'.toLowerCase();
  }
}
