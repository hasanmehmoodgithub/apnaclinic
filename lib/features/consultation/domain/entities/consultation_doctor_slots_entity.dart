class ConsultationTimeSlotEntity {
  const ConsultationTimeSlotEntity({
    required this.startTime,
    required this.endTime,
    required this.label,
  });

  final String startTime;
  final String endTime;
  final String label;
}

class ConsultationAvailabilityDayEntity {
  const ConsultationAvailabilityDayEntity({
    required this.date,
    required this.weekDay,
    required this.dayOfMonth,
    required this.slots,
  });

  final String date;
  final String weekDay;
  final String dayOfMonth;
  final List<ConsultationTimeSlotEntity> slots;
}

class ConsultationDoctorSlotsDoctorInfoEntity {
  const ConsultationDoctorSlotsDoctorInfoEntity({
    required this.ratings,
    required this.pmdcVerified,
    required this.verifiedPatientsCount,
    required this.patientsSatisfiedPercentage,
  });

  final double ratings;
  final bool pmdcVerified;
  final int verifiedPatientsCount;
  final double patientsSatisfiedPercentage;
}

class ConsultationDoctorSlotsEntity {
  const ConsultationDoctorSlotsEntity({
    required this.monthLabel,
    required this.days,
    this.doctorInfo,
  });

  final String monthLabel;
  final List<ConsultationAvailabilityDayEntity> days;
  final ConsultationDoctorSlotsDoctorInfoEntity? doctorInfo;

  static const empty = ConsultationDoctorSlotsEntity(
    monthLabel: '',
    days: [],
  );
}
