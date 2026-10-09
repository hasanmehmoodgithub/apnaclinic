import '../../domain/entities/pro_unsubscribe_result_entity.dart';

/// `POST /acs-aggregator/api/v1/mobile/pro/unsubscribe` response.
class ProUnsubscribeResponseModel {
  const ProUnsubscribeResponseModel({
    required this.planCode,
    required this.message,
  });

  final String planCode;
  final String message;

  factory ProUnsubscribeResponseModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    final root = data is Map<String, dynamic>
        ? data
        : (data is Map ? Map<String, dynamic>.from(data) : json);
    final topMessage = _text(json['message']);
    final dataMessage = _text(root['message']);
    return ProUnsubscribeResponseModel(
      planCode: _text(root['planCode']) ?? '',
      message: dataMessage ?? topMessage ?? '',
    );
  }

  ProUnsubscribeResultEntity toEntity() {
    return ProUnsubscribeResultEntity(
      planCode: planCode,
      message: message,
    );
  }

  static String? _text(Object? value) {
    if (value == null) return null;
    final text = value.toString().trim();
    if (text.isEmpty || text.toLowerCase() == 'null') return null;
    return text;
  }
}
