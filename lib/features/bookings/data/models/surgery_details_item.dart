enum SurgeryBookingStatus { inReview, paymentPending, confirmed }

class SurgeryBookingDetailsArgs {
  const SurgeryBookingDetailsArgs({
    required this.leadId,
    required this.item,
    required this.initialStatus,
  });

  final String leadId;
  final SurgeryDetailsItem item;
  final SurgeryBookingStatus initialStatus;
}

class SurgeryDetailsItem {
  final String leadId;
  final String procedure;
  final String procedureSubtitle;
  final String hospital;
  final String doctor;
  final String specialty;
  final String qualification;
  final String status;
  final String dateCreated;
  final String patientName;
  final int age;
  final String gender;
  final String contactNumber;
  final String emergencyContact;
  final int fee;
  final int discountPercent;
  final int discountAmount;
  final int total;

  /// Empty when the API sends no discount code; hides the discount strip.
  final String discountCode;
  final bool paymentAllowed;
  final String appointmentDay;
  final String appointmentMonth;
  final String appointmentWeekday;
  final String appointmentTime;
  final String appointmentSubtitle;
  final String appointmentDateFull;
  final String partnerLogoUrl;

  const SurgeryDetailsItem({
    required this.leadId,
    required this.procedure,
    required this.procedureSubtitle,
    required this.hospital,
    required this.doctor,
    required this.specialty,
    required this.qualification,
    required this.status,
    required this.dateCreated,
    required this.patientName,
    required this.age,
    required this.gender,
    required this.contactNumber,
    required this.emergencyContact,
    required this.fee,
    required this.discountPercent,
    required this.discountAmount,
    required this.total,
    this.discountCode = '',
    required this.paymentAllowed,
    required this.appointmentDay,
    required this.appointmentMonth,
    required this.appointmentWeekday,
    required this.appointmentTime,
    required this.appointmentSubtitle,
    required this.appointmentDateFull,
    required this.partnerLogoUrl,
  });

  SurgeryDetailsItem copyWith({
    String? status,
    bool? paymentAllowed,
  }) {
    return SurgeryDetailsItem(
      leadId: leadId,
      procedure: procedure,
      procedureSubtitle: procedureSubtitle,
      hospital: hospital,
      doctor: doctor,
      specialty: specialty,
      qualification: qualification,
      status: status ?? this.status,
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
      discountCode: discountCode,
      paymentAllowed: paymentAllowed ?? this.paymentAllowed,
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
