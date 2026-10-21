class PrescriptionMedicineEntity {
  const PrescriptionMedicineEntity({
    required this.name,
    this.dosage = '',
    this.frequency = '',
    this.duration = '',
    this.instructions = '',
    this.quantity = 0,
  });

  final String name;
  final String dosage;
  final String frequency;
  final String duration;
  final String instructions;
  final int quantity;
}

class PrescriptionExtractEntity {
  const PrescriptionExtractEntity({
    required this.pages,
    required this.type,
    required this.date,
    required this.doctor,
    required this.patient,
    required this.institute,
    required this.location,
    required this.isLabReport,
    required this.medicines,
    required this.tests,
  });

  final int pages;
  final String type;
  final String date;
  final String doctor;
  final String patient;
  final String institute;
  final String location;
  final bool isLabReport;
  final List<PrescriptionMedicineEntity> medicines;
  final List<String> tests;
}
