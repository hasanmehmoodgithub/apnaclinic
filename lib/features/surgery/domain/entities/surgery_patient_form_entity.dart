class SurgeryOptionEntity {
  const SurgeryOptionEntity({
    required this.id,
    required this.name,
    required this.price,
    required this.oldPrice,
  });

  final String id;
  final String name;
  final String price;
  final String oldPrice;
}

class SurgeryPatientPrefillEntity {
  const SurgeryPatientPrefillEntity({
    required this.patientName,
    required this.age,
    required this.contactNumber,
    required this.emergencyContact,
  });

  final String patientName;
  final String age;
  final String contactNumber;
  final String emergencyContact;

  static const empty = SurgeryPatientPrefillEntity(
    patientName: '',
    age: '',
    contactNumber: '',
    emergencyContact: '',
  );
}

class SurgeryPatientFormEntity {
  const SurgeryPatientFormEntity({
    required this.doctorId,
    required this.patientPrefill,
    required this.surgeryOptions,
  });

  final String doctorId;
  final SurgeryPatientPrefillEntity patientPrefill;
  final List<SurgeryOptionEntity> surgeryOptions;

  static const empty = SurgeryPatientFormEntity(
    doctorId: '',
    patientPrefill: SurgeryPatientPrefillEntity.empty,
    surgeryOptions: [],
  );
}
