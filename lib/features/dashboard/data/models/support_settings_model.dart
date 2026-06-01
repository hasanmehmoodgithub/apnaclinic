class SupportSettingsDataModel {
  const SupportSettingsDataModel({
    required this.phone,
    required this.email,
    required this.description,
    required this.buttonText,
  });

  final String phone;
  final String email;
  final String description;
  final String buttonText;

  factory SupportSettingsDataModel.fromJson(Map<String, dynamic> json) {
    return SupportSettingsDataModel(
      phone: (json['phone'] ?? '').toString().trim(),
      email: (json['email'] ?? '').toString().trim(),
      description: (json['description'] ?? '').toString().trim(),
      buttonText: (json['buttonText'] ?? json['button_text'] ?? '')
          .toString()
          .trim(),
    );
  }

  factory SupportSettingsDataModel.empty() {
    return const SupportSettingsDataModel(
      phone: '',
      email: '',
      description: '',
      buttonText: '',
    );
  }
}

class SupportSettingsResponseModel {
  const SupportSettingsResponseModel({
    required this.success,
    required this.message,
    required this.data,
  });

  final bool success;
  final String message;
  final SupportSettingsDataModel data;

  factory SupportSettingsResponseModel.fromJson(Map<String, dynamic> json) {
    final dataRaw = json['data'];
    final data = dataRaw is Map<String, dynamic>
        ? SupportSettingsDataModel.fromJson(dataRaw)
        : SupportSettingsDataModel.empty();

    final code = json['code'];
    final success =
        json['success'] == true || (code is num && code.toInt() == 200);

    return SupportSettingsResponseModel(
      success: success,
      message: (json['message'] ?? '').toString(),
      data: data,
    );
  }
}
