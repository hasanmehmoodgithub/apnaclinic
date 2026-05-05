class FreeDoctorModel {
  const FreeDoctorModel({
    required this.title,
    required this.descriptionPoints,
    required this.fikrfreeAndroidPackage,
    required this.fikrfreeIosAppStoreUrl,
    required this.fikrfreeWebUrl,
  });

  final String title;
  final List<String> descriptionPoints;
  final String fikrfreeAndroidPackage;
  final String fikrfreeIosAppStoreUrl;
  final String fikrfreeWebUrl;

  factory FreeDoctorModel.fromJson(Map<String, dynamic> json) {
    return FreeDoctorModel(
      title: (json['title'] ?? '').toString(),
      descriptionPoints: (json['descriptionPoints'] as List<dynamic>? ?? [])
          .map((e) => e.toString())
          .toList(),
      fikrfreeAndroidPackage: (json['fikrfreeAndroidPackage'] ?? '').toString(),
      fikrfreeIosAppStoreUrl: (json['fikrfreeIosAppStoreUrl'] ?? '').toString(),
      fikrfreeWebUrl: (json['fikrfreeWebUrl'] ?? '').toString(),
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

class FreeDoctorResponseModel {
  const FreeDoctorResponseModel({
    required this.success,
    required this.message,
    required this.content,
  });

  final bool success;
  final String message;
  final FreeDoctorModel content;

  factory FreeDoctorResponseModel.fromJson(Map<String, dynamic> json) {
    final payload = _contentMap(json);
    return FreeDoctorResponseModel(
      success: json['success'] == true,
      message: (json['message'] ?? '').toString(),
      content: FreeDoctorModel.fromJson(payload),
    );
  }

  static Map<String, dynamic> _contentMap(Map<String, dynamic> json) {
    final data = json['data'];
    if (data is Map<String, dynamic>) {
      return data;
    }
    final content = json['content'];
    if (content is Map<String, dynamic>) {
      return content;
    }
    final copy = Map<String, dynamic>.from(json)
      ..remove('success')
      ..remove('message');
    return copy;
  }
}
