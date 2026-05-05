enum SurgeryBookingStatus { inReview, paymentPending, confirmed }

class SurgeryBookingDetailsArgs {
  const SurgeryBookingDetailsArgs({
    required this.item,
    required this.initialStatus,
  });

  final SurgeryDetailsItem item;
  final SurgeryBookingStatus initialStatus;
}

class SurgeryDetailsItem {
  final String procedure;
  final String procedureSubtitle;
  final String hospital;
  final String doctor;
  final String specialty;
  final String qualification;
  final String dateCreated;
  final String patientName;
  final int age;
  final String contactNumber;
  final String emergencyContact;
  final int fee;
  final int discountPercent;
  final int discountAmount;
  final int total;
  // Appointment (only used for paymentPending / confirmed states)
  final String appointmentDay;
  final String appointmentMonth;
  final String appointmentWeekday;
  final String appointmentTime;
  final String appointmentDateFull; // e.g. "15th May,2025"

  const SurgeryDetailsItem({
    required this.procedure,
    required this.procedureSubtitle,
    required this.hospital,
    required this.doctor,
    required this.specialty,
    required this.qualification,
    required this.dateCreated,
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
  });
}