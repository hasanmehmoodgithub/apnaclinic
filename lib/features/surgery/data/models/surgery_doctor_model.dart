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

  factory SurgeryDoctorModel.fromJson(
    Map<String, dynamic> json, {
    String procedureName = '',
  }) {
    final doctorSlug = (json['doctorSlug'] ?? json['doctor_slug'] ?? '')
        .toString()
        .trim();
    final hospitalSlug = (json['hospitalSlug'] ?? json['hospital_slug'] ?? '')
        .toString()
        .trim();
    final rawId = (json['id'] ?? '').toString().trim();
    final id = rawId.isNotEmpty
        ? rawId
        : (doctorSlug.isNotEmpty
            ? (hospitalSlug.isNotEmpty ? '$doctorSlug-$hospitalSlug' : doctorSlug)
            : '');

    final discounted = json['discountedPrice'] ?? json['discounted_price'];
    final original = json['price'] ?? json['oldPrice'] ?? json['old_price'];

    return SurgeryDoctorModel(
      id: id,
      doctorName: (json['doctorName'] ?? json['doctor_name'] ?? '').toString(),
      speciality: (json['speciality'] ?? json['specialty'] ?? '').toString(),
      experience: (json['experience'] ?? json['tatMessage'] ?? '').toString(),
      qualifications: (json['qualifications'] ?? '').toString(),
      hospitalName: (json['hospitalName'] ?? json['hospital_name'] ?? '')
          .toString(),
      procedureName: procedureName.isNotEmpty
          ? procedureName
          : (json['procedureName'] ?? json['procedure_name'] ?? '').toString(),
      price: _formatPrice(discounted ?? original),
      oldPrice: _formatOriginalPrice(original, discounted),
      imageUrl: (json['imageUrl'] ??
              json['image_url'] ??
              json['image'] ??
              json['imagePath'] ??
              '')
          .toString(),
      partnerLogoUrl:
          (json['partnerLogoUrl'] ?? json['partner_logo_url'] ?? '').toString(),
    );
  }

  static String _formatPrice(dynamic amount) {
    if (amount == null) return '';
    if (amount is num) {
      return 'Rs. ${amount.round()}/-';
    }
    final text = amount.toString().trim();
    if (text.isEmpty) return '';
    if (text.toLowerCase().startsWith('rs')) return text;
    return 'Rs. $text/-';
  }

  static String _formatOriginalPrice(dynamic original, dynamic discounted) {
    if (original == null) return '';
    if (discounted != null && original == discounted) return '';
    return _formatPrice(original);
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

  factory SurgeryDoctorsResponseModel.fromJson(
    Map<String, dynamic> json, {
    String procedureName = '',
    String city = '',
  }) {
    final code = json['code'];
    final success = json['success'] == true || (code is num && code.toInt() == 200);
    final dataRaw = json['data'];

    if (dataRaw is List) {
      final doctors = (dataRaw)
          .whereType<Map<String, dynamic>>()
          .map(
            (item) => SurgeryDoctorModel.fromJson(
              item,
              procedureName: procedureName,
            ),
          )
          .where((doctor) => doctor.doctorName.isNotEmpty)
          .toList();

      final hospitals = doctors
          .map((doctor) => doctor.hospitalName.trim())
          .where((name) => name.isNotEmpty)
          .toSet()
          .toList();
      final specialties = doctors
          .map((doctor) => doctor.speciality.trim())
          .where((name) => name.isNotEmpty)
          .toSet()
          .toList();

      return SurgeryDoctorsResponseModel(
        success: success,
        message: (json['message'] ?? '').toString(),
        procedureName: procedureName,
        city: city,
        hospitals: hospitals,
        specialties: specialties,
        doctors: doctors,
      );
    }

    final payload = _payloadMap(json);
    final rawDoctors = payload['doctors'] ?? payload['providers'];
    final rawHospitals = payload['hospitals'];
    final rawSpecialties = payload['specialties'] ?? payload['specialities'];

    return SurgeryDoctorsResponseModel(
      success: success,
      message: (json['message'] ?? '').toString(),
      procedureName: (payload['procedureName'] ?? procedureName).toString(),
      city: (payload['city'] ?? city).toString(),
      hospitals: _toStringList(rawHospitals),
      specialties: _toStringList(rawSpecialties),
      doctors: (rawDoctors is List ? rawDoctors : const <dynamic>[])
          .whereType<Map<String, dynamic>>()
          .map(
            (item) => SurgeryDoctorModel.fromJson(
              item,
              procedureName: procedureName,
            ),
          )
          .toList(),
    );
  }

  static Map<String, dynamic> _payloadMap(Map<String, dynamic> json) {
    final data = json['data'];
    if (data is Map<String, dynamic>) return data;

    final copy = Map<String, dynamic>.from(json)
      ..remove('success')
      ..remove('message')
      ..remove('code')
      ..remove('timestamp');
    return copy;
  }

  static List<String> _toStringList(dynamic value) {
    if (value is! List) return const [];
    return value.map((e) => e.toString()).toList();
  }
}
