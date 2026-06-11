import '../../../../core/l10n/app_localizations.dart';
import 'surgery_details_item.dart';

class SurgeryBookingListItemModel {
  const SurgeryBookingListItemModel({
    required this.bookingId,
    required this.procedure,
    required this.hospital,
    required this.doctor,
    required this.specialty,
    required this.qualification,
    required this.status,
    required this.dateCreated,
    required this.initialStatus,
    required this.procedureSubtitle,
    required this.patientName,
    required this.age,
    required this.contactNumber,
    required this.emergencyContact,
    required this.fee,
    required this.discountPercent,
    required this.discountAmount,
    required this.total,
    required this.appointmentDay,
    required this.appointmentMonth,
    required this.appointmentWeekday,
    required this.appointmentTime,
    required this.appointmentDateFull,
    required this.partnerLogoUrl,
  });

  final String bookingId;
  final String procedure;
  final String hospital;
  final String doctor;
  final String specialty;
  final String qualification;
  final String status;
  final String dateCreated;
  final SurgeryBookingStatus initialStatus;
  final String procedureSubtitle;
  final String patientName;
  final int age;
  final String contactNumber;
  final String emergencyContact;
  final int fee;
  final int discountPercent;
  final int discountAmount;
  final int total;
  final String appointmentDay;
  final String appointmentMonth;
  final String appointmentWeekday;
  final String appointmentTime;
  final String appointmentDateFull;
  final String partnerLogoUrl;

  factory SurgeryBookingListItemModel.fromJson(Map<String, dynamic> json) {
    return SurgeryBookingListItemModel(
      bookingId: (json['bookingId'] ?? json['booking_id'] ?? '').toString(),
      procedure: (json['procedure'] ?? '').toString(),
      hospital: (json['hospital'] ?? '').toString(),
      doctor: (json['doctor'] ?? '').toString(),
      specialty: (json['specialty'] ?? json['speciality'] ?? '').toString(),
      qualification: (json['qualification'] ?? '').toString(),
      status: (json['status'] ?? '').toString(),
      dateCreated: (json['dateCreated'] ?? json['date_created'] ?? '').toString(),
      initialStatus: _statusFromString(
        (json['initialStatus'] ?? json['initial_status'] ?? '').toString(),
      ),
      procedureSubtitle: (json['procedureSubtitle'] ??
              json['procedure_subtitle'] ??
              '')
          .toString(),
      patientName: (json['patientName'] ?? json['patient_name'] ?? '').toString(),
      age: int.tryParse((json['age'] ?? '0').toString()) ?? 0,
      contactNumber:
          (json['contactNumber'] ?? json['contact_number'] ?? '').toString(),
      emergencyContact: (json['emergencyContact'] ??
              json['emergency_contact'] ??
              '')
          .toString(),
      fee: int.tryParse((json['fee'] ?? '0').toString()) ?? 0,
      discountPercent:
          int.tryParse((json['discountPercent'] ?? json['discount_percent'] ?? '0').toString()) ??
              0,
      discountAmount:
          int.tryParse((json['discountAmount'] ?? json['discount_amount'] ?? '0').toString()) ??
              0,
      total: int.tryParse((json['total'] ?? '0').toString()) ?? 0,
      appointmentDay:
          (json['appointmentDay'] ?? json['appointment_day'] ?? '').toString(),
      appointmentMonth: (json['appointmentMonth'] ?? json['appointment_month'] ?? '')
          .toString(),
      appointmentWeekday: (json['appointmentWeekday'] ??
              json['appointment_weekday'] ??
              '')
          .toString(),
      appointmentTime:
          (json['appointmentTime'] ?? json['appointment_time'] ?? '').toString(),
      appointmentDateFull: (json['appointmentDateFull'] ??
              json['appointment_date_full'] ??
              '')
          .toString(),
      partnerLogoUrl:
          (json['partnerLogoUrl'] ?? json['partner_logo_url'] ?? '').toString(),
    );
  }

  SurgeryDetailsItem toDetailsItem(AppLocalizations l10n) {
    return SurgeryDetailsItem(
      procedure: procedure,
      procedureSubtitle:
          procedureSubtitle.isEmpty ? l10n.bookingsSurgeryProcedureSubtitle : procedureSubtitle,
      hospital: hospital,
      doctor: doctor,
      specialty: specialty,
      qualification: qualification,
      dateCreated: dateCreated,
      patientName: patientName,
      age: age,
      contactNumber: contactNumber,
      emergencyContact: emergencyContact,
      fee: fee,
      discountPercent: discountPercent,
      discountAmount: discountAmount,
      total: total,
      appointmentDay: appointmentDay,
      appointmentMonth: appointmentMonth,
      appointmentWeekday: appointmentWeekday,
      appointmentTime: appointmentTime,
      appointmentDateFull: appointmentDateFull,
      partnerLogoUrl: partnerLogoUrl,
    );
  }

  static SurgeryBookingStatus _statusFromString(String value) {
    switch (value.toLowerCase()) {
      case 'paymentpending':
      case 'payment_pending':
        return SurgeryBookingStatus.paymentPending;
      case 'confirmed':
        return SurgeryBookingStatus.confirmed;
      case 'inreview':
      case 'in_review':
      default:
        return SurgeryBookingStatus.inReview;
    }
  }
}
