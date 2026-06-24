class InstantDoctorModel {
  const InstantDoctorModel({
    required this.isSubscribed,
    required this.bulletPoints,
    required this.buttonText,
    required this.redirectUrl,
  });

  final bool isSubscribed;
  final List<String> bulletPoints;
  final String buttonText;
  final String redirectUrl;

  factory InstantDoctorModel.fromJson(Map<String, dynamic> json) {
    final bullets = json['bulletText'] ?? json['descriptionPoints'];
    return InstantDoctorModel(
      isSubscribed: json['isSubscribed'] == true,
      bulletPoints: (bullets as List<dynamic>? ?? [])
          .map((e) => e.toString())
          .where((e) => e.isNotEmpty)
          .toList(),
      buttonText: (json['buttonText'] ?? '').toString(),
      redirectUrl: (json['redirectUrl'] ?? '').toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'isSubscribed': isSubscribed,
      'bulletText': bulletPoints,
      'buttonText': buttonText,
      'redirectUrl': redirectUrl,
    };
  }
}

class InstantDoctorResponseModel {
  const InstantDoctorResponseModel({
    required this.success,
    required this.message,
    required this.content,
  });

  final bool success;
  final String message;
  final InstantDoctorModel content;

  factory InstantDoctorResponseModel.fromJson(Map<String, dynamic> json) {
    final payload = _contentMap(json);
    return InstantDoctorResponseModel(
      success: json['success'] == true,
      message: (json['message'] ?? '').toString(),
      content: InstantDoctorModel.fromJson(payload),
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
      ..remove('message')
      ..remove('code')
      ..remove('timestamp');
    return copy;
  }
}
