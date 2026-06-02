class SurgeryDoctorModel {
  const SurgeryDoctorModel({
    required this.id,
    required this.doctorName,
    required this.speciality,
    required this.experience,
    required this.qualifications,
    required this.hospitalName,
    required this.procedureName,
    required this.price,
    required this.oldPrice,
    required this.imageUrl,
    required this.partnerLogoUrl,
  });

  final String id;
  final String doctorName;
  final String speciality;
  final String experience;
  final String qualifications;
  final String hospitalName;
  final String procedureName;
  final String price;
  final String oldPrice;
  final String imageUrl;
  final String partnerLogoUrl;

  factory SurgeryDoctorModel.fromJson(Map<String, dynamic> json) {
    return SurgeryDoctorModel(
      id: (json['id'] ?? '').toString(),
      doctorName: (json['doctorName'] ?? json['doctor_name'] ?? '').toString(),
      speciality: (json['speciality'] ?? json['specialty'] ?? '').toString(),
      experience: (json['experience'] ?? '').toString(),
      qualifications: (json['qualifications'] ?? '').toString(),
      hospitalName: (json['hospitalName'] ?? json['hospital_name'] ?? '')
          .toString(),
      procedureName: (json['procedureName'] ?? json['procedure_name'] ?? '')
          .toString(),
      price: (json['price'] ?? '').toString(),
      oldPrice: (json['oldPrice'] ?? json['old_price'] ?? '').toString(),
      imageUrl: (json['imageUrl'] ?? json['image_url'] ?? '').toString(),
      partnerLogoUrl:
          (json['partnerLogoUrl'] ?? json['partner_logo_url'] ?? '').toString(),
    );
  }
}

class SurgeryDoctorsResponseModel {
  const SurgeryDoctorsResponseModel({
    required this.success,
    required this.message,
    required this.procedureName,
    required this.city,
    required this.hospitals,
    required this.specialties,
    required this.doctors,
  });

  final bool success;
  final String message;
  final String procedureName;
  final String city;
  final List<String> hospitals;
  final List<String> specialties;
  final List<SurgeryDoctorModel> doctors;

  factory SurgeryDoctorsResponseModel.fromJson(Map<String, dynamic> json) {
    final payload = _payloadMap(json);
    final rawDoctors = payload['doctors'];
    final rawHospitals = payload['hospitals'];
    final rawSpecialties = payload['specialties'] ?? payload['specialities'];

    return SurgeryDoctorsResponseModel(
      success: json['success'] == true,
      message: (json['message'] ?? '').toString(),
      procedureName: (payload['procedureName'] ?? '').toString(),
      city: (payload['city'] ?? '').toString(),
      hospitals: _toStringList(rawHospitals),
      specialties: _toStringList(rawSpecialties),
      doctors: (rawDoctors is List ? rawDoctors : const <dynamic>[])
          .whereType<Map<String, dynamic>>()
          .map(SurgeryDoctorModel.fromJson)
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

  static List<String> _toStringList(dynamic value) {
    if (value is! List) return const [];
    return value.map((e) => e.toString()).toList();
  }
}
