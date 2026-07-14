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

class ConsultationPatientReviewEntity {
  const ConsultationPatientReviewEntity({
    required this.rating,
    required this.maxRating,
    required this.dateLabel,
    required this.comment,
    required this.patientName,
  });

  final double rating;
  final double maxRating;
  final String dateLabel;
  final String comment;
  final String patientName;
}

class ConsultationPatientReviewsEntity {
  const ConsultationPatientReviewsEntity({
    required this.totalCount,
    required this.filteredCount,
    required this.reviews,
  });

  final int totalCount;
  final int filteredCount;
  final List<ConsultationPatientReviewEntity> reviews;

  static const empty = ConsultationPatientReviewsEntity(
    totalCount: 0,
    filteredCount: 0,
    reviews: [],
  );

  bool get hasReviews => reviews.isNotEmpty;
}

class ConsultationDoctorSlotsDoctorInfoEntity {
  const ConsultationDoctorSlotsDoctorInfoEntity({
    required this.ratings,
    required this.pmdcVerified,
    required this.verifiedPatientsCount,
    required this.patientsSatisfiedPercentage,
    this.patientReviews = ConsultationPatientReviewsEntity.empty,
  });

  final double ratings;
  final bool pmdcVerified;
  final int verifiedPatientsCount;
  final double patientsSatisfiedPercentage;
  final ConsultationPatientReviewsEntity patientReviews;
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
