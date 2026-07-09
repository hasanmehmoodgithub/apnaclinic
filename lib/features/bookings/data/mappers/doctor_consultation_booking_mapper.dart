import 'package:intl/intl.dart';

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
        ? entity.patientRelation
        : 'Self';
    final issue = entity.issue.isNotEmpty ? entity.issue : '-';

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
      consultationFee: entity.consultationFee,
      discountAmount: entity.discountAmount,
      totalText: totalText,
    );
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
