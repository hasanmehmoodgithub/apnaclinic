class SurgeryOptionModel {
  const SurgeryOptionModel({
    required this.id,
    required this.name,
    required this.price,
    required this.oldPrice,
  });

  final String id;
  final String name;
  final String price;
  final String oldPrice;

  factory SurgeryOptionModel.fromJson(Map<String, dynamic> json) {
    return SurgeryOptionModel(
      id: (json['id'] ?? '').toString(),
      name: (json['name'] ?? '').toString(),
      price: (json['price'] ?? '').toString(),
      oldPrice: (json['oldPrice'] ?? json['old_price'] ?? '').toString(),
    );
  }
}

class SurgeryPatientPrefillModel {
  const SurgeryPatientPrefillModel({
    required this.patientName,
    required this.age,
    required this.contactNumber,
    required this.emergencyContact,
  });

  final String patientName;
  final String age;
  final String contactNumber;
  final String emergencyContact;

  factory SurgeryPatientPrefillModel.fromJson(Map<String, dynamic> json) {
    return SurgeryPatientPrefillModel(
      patientName: (json['patientName'] ?? json['patient_name'] ?? '')
          .toString(),
      age: (json['age'] ?? '').toString(),
      contactNumber:
          (json['contactNumber'] ?? json['contact_number'] ?? '').toString(),
      emergencyContact: (json['emergencyContact'] ??
              json['emergency_contact'] ??
              '')
          .toString(),
    );
  }
}

class SurgeryPatientFormModel {
  const SurgeryPatientFormModel({
    required this.success,
    required this.message,
    required this.doctorId,
    required this.patientPrefill,
    required this.surgeryOptions,
  });

  final bool success;
  final String message;
  final String doctorId;
  final SurgeryPatientPrefillModel patientPrefill;
  final List<SurgeryOptionModel> surgeryOptions;

  factory SurgeryPatientFormModel.fromJson(Map<String, dynamic> json) {
    final payload = _payloadMap(json);
    final prefillJson = payload['patientPrefill'] ?? payload['patient_prefill'];
    final rawOptions = payload['surgeryOptions'] ?? payload['surgery_options'];

    return SurgeryPatientFormModel(
      success: json['success'] == true,
      message: (json['message'] ?? '').toString(),
      doctorId: (payload['doctorId'] ?? payload['doctor_id'] ?? '').toString(),
      patientPrefill: prefillJson is Map<String, dynamic>
          ? SurgeryPatientPrefillModel.fromJson(prefillJson)
          : const SurgeryPatientPrefillModel(
              patientName: '',
              age: '',
              contactNumber: '',
              emergencyContact: '',
            ),
      surgeryOptions: (rawOptions is List ? rawOptions : const <dynamic>[])
          .whereType<Map<String, dynamic>>()
          .map(SurgeryOptionModel.fromJson)
          .toList(),
    );
  }

  static Map<String, dynamic> _payloadMap(Map<String, dynamic> json) {
    final data = json['data'];
    if (data is Map<String, dynamic>) return data;

    final copy = Map<String, dynamic>.from(json)
      ..remove('success')
      ..remove('message');
    return copy;
  }
}
