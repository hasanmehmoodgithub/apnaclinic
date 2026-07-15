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
    required this.paymentAllowed,
    required this.procedureSubtitle,
    required this.patientName,
    required this.age,
    required this.gender,
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
    required this.appointmentSubtitle,
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
  final bool paymentAllowed;
  final String procedureSubtitle;
  final String patientName;
  final int age;
  final String gender;
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
  final String appointmentSubtitle;
  final String appointmentDateFull;
  final String partnerLogoUrl;

  SurgeryDetailsItem toDetailsItem() {
    return SurgeryDetailsItem(
      leadId: bookingId,
      procedure: procedure,
      procedureSubtitle: procedureSubtitle,
      hospital: hospital,
      doctor: doctor,
      specialty: specialty,
      qualification: qualification,
      status: status,
      dateCreated: dateCreated,
      patientName: patientName,
      age: age,
      gender: gender,
      contactNumber: contactNumber,
      emergencyContact: emergencyContact,
      fee: fee,
      discountPercent: discountPercent,
      discountAmount: discountAmount,
      total: total,
      paymentAllowed: paymentAllowed,
      appointmentDay: appointmentDay,
      appointmentMonth: appointmentMonth,
      appointmentWeekday: appointmentWeekday,
      appointmentTime: appointmentTime,
      appointmentSubtitle: appointmentSubtitle,
      appointmentDateFull: appointmentDateFull,
      partnerLogoUrl: partnerLogoUrl,
    );
  }
}
