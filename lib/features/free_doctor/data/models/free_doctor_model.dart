import '../../domain/entities/free_doctor_entity.dart';

class FreeDoctorModel extends FreeDoctorEntity {
  const FreeDoctorModel({
    required super.title,
    required super.descriptionPoints,
    required super.fikrfreeAndroidPackage,
    required super.fikrfreeIosAppStoreUrl,
    required super.fikrfreeWebUrl,
  });

  factory FreeDoctorModel.fromJson(Map<String, dynamic> json) {
    return FreeDoctorModel(
      title: json['title'] as String? ?? '',
      descriptionPoints: (json['descriptionPoints'] as List<dynamic>? ?? [])
          .map((e) => e.toString())
          .toList(),
      fikrfreeAndroidPackage: json['fikrfreeAndroidPackage'] as String? ?? '',
      fikrfreeIosAppStoreUrl: json['fikrfreeIosAppStoreUrl'] as String? ?? '',
      fikrfreeWebUrl: json['fikrfreeWebUrl'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'descriptionPoints': descriptionPoints,
      'fikrfreeAndroidPackage': fikrfreeAndroidPackage,
      'fikrfreeIosAppStoreUrl': fikrfreeIosAppStoreUrl,
      'fikrfreeWebUrl': fikrfreeWebUrl,
    };
  }
}
