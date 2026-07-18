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
    final rawId = (json['id'] ?? json['doctorId'] ?? json['doctor_id'] ?? '')
        .toString()
        .trim();
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
      experience: _formatExperience(json),
      qualifications:
          (json['qualifications'] ?? json['education'] ?? '').toString(),
      hospitalName: (json['hospitalName'] ?? json['hospital_name'] ?? '')
          .toString(),
      procedureName: procedureName.isNotEmpty
          ? procedureName
          : (json['procedureName'] ?? json['procedure_name'] ?? '').toString(),
      price: _formatPrice(discounted ?? original),
      oldPrice: _formatOriginalPrice(original, discounted),
      imageUrl: (json['imageUrl'] ??
              json['image_url'] ??
              json['profileImageUrl'] ??
              json['profile_image_url'] ??
              json['image'] ??
              json['imagePath'] ??
              '')
          .toString(),
      partnerLogoUrl: _resolvePartnerLogoUrl(json),
    );
  }

  static String _resolvePartnerLogoUrl(Map<String, dynamic> json) {
    final direct = (json['partnerLogoUrl'] ??
            json['PartnerLogoUrl'] ??
            json['partner_logo_url'] ??
            json['logoUrl'] ??
            json['logo_url'] ??
            '')
        .toString()
        .trim();
    if (direct.isNotEmpty) return direct;

    final partner = json['partner'];
    if (partner is Map) {
      final nested = (partner['logoUrl'] ??
              partner['logo_url'] ??
              partner['partnerLogoUrl'] ??
              partner['PartnerLogoUrl'] ??
              '')
          .toString()
          .trim();
      if (nested.isNotEmpty) return nested;
    }
    return '';
  }

  static String _formatExperience(Map<String, dynamic> json) {
    final years = json['yearsOfExperience'] ?? json['years_of_experience'];
    if (years != null) {
      if (years is num) {
        final value = years.toInt();
        if (value <= 0) return '';
        return value == 1 ? '1 year' : '$value years';
      }
      final text = years.toString().trim();
      if (text.isEmpty) return '';
      final parsed = int.tryParse(text);
      if (parsed != null) {
        if (parsed <= 0) return '';
        return parsed == 1 ? '1 year' : '$parsed years';
      }
      final match = RegExp(r'(\d+)').firstMatch(text);
      if (match != null) {
        final value = int.tryParse(match.group(1)!);
        if (value != null && value > 0) {
          return value == 1 ? '1 year' : '$value years';
        }
      }
      return text;
    }
    final fallback = (json['experience'] ?? '').toString().trim();
    if (fallback.isEmpty) return '';
    final parsed = int.tryParse(fallback);
    if (parsed != null) {
      if (parsed <= 0) return '';
      return parsed == 1 ? '1 year' : '$parsed years';
    }
    return fallback;
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

    final List<SurgeryDoctorModel> doctors;
    String resolvedProcedureName = procedureName;
    String resolvedCity = city;
    List<String> payloadHospitals = const [];
    List<String> payloadSpecialties = const [];

    if (dataRaw is List) {
      doctors = _parseDoctorList(dataRaw, procedureName: procedureName);
    } else {
      final payload = _payloadMap(json);
      final rawDoctors =
          payload['doctors'] ?? payload['providers'] ?? payload['items'];
      doctors = _parseDoctorList(
        rawDoctors is List ? rawDoctors : const <dynamic>[],
        procedureName: procedureName,
      );
      resolvedProcedureName =
          (payload['procedureName'] ?? procedureName).toString();
      resolvedCity = (payload['city'] ?? city).toString();
      payloadHospitals = _toStringList(payload['hospitals']);
      payloadSpecialties =
          _toStringList(payload['specialties'] ?? payload['specialities']);
    }

    final hospitals = payloadHospitals.isNotEmpty
        ? payloadHospitals
        : _uniqueNonEmpty(doctors.map((doctor) => doctor.hospitalName));
    final specialties = payloadSpecialties.isNotEmpty
        ? payloadSpecialties
        : _uniqueNonEmpty(doctors.map((doctor) => doctor.speciality));

    return SurgeryDoctorsResponseModel(
      success: success,
      message: (json['message'] ?? '').toString(),
      procedureName: resolvedProcedureName,
      city: resolvedCity,
      hospitals: hospitals,
      specialties: specialties,
      doctors: doctors,
    );
  }

  static List<SurgeryDoctorModel> _parseDoctorList(
    List<dynamic> rawDoctors, {
    required String procedureName,
  }) {
    return rawDoctors
        .whereType<Map<String, dynamic>>()
        .map(
          (item) => SurgeryDoctorModel.fromJson(
            item,
            procedureName: procedureName,
          ),
        )
        .where((doctor) => doctor.doctorName.isNotEmpty)
        .toList();
  }

  static List<String> _uniqueNonEmpty(Iterable<String> values) {
    return values
        .map((value) => value.trim())
        .where((value) => value.isNotEmpty)
        .toSet()
        .toList();
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
