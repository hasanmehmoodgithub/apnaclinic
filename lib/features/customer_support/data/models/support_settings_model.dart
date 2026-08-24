import '../../../../core/preference/support_settings_local_model.dart';

class SupportSettingsResponseModel {
  const SupportSettingsResponseModel({
    required this.success,
    required this.message,
    required this.data,
  });

  final bool success;
  final String message;
  final SupportSettingsLocalModel data;

  factory SupportSettingsResponseModel.fromJson(Map<String, dynamic> json) {
    final dataRaw = json['data'];
    final data = dataRaw is Map<String, dynamic>
        ? SupportSettingsLocalModel.fromJson(dataRaw)
        : const SupportSettingsLocalModel();

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
