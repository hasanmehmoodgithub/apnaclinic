import '../../domain/entities/pro_subscribe_result_entity.dart';

/// `POST /acs-aggregator/api/v1/mobile/pro/subscribe` response.
class ProSubscribeResponseModel {
  const ProSubscribeResponseModel({
    required this.planCode,
    required this.planPriceCode,
    required this.publicId,
    required this.status,
    required this.paymentAttemptRef,
    required this.link,
    required this.message,
  });

  final String planCode;
  final String planPriceCode;
  final String? publicId;
  final String status;
  final String? paymentAttemptRef;
  final String? link;
  final String message;

  factory ProSubscribeResponseModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    final root = data is Map<String, dynamic>
        ? data
        : (data is Map ? Map<String, dynamic>.from(data) : json);
    final topMessage = _text(json['message']);
    final dataMessage = _text(root['message']);
    return ProSubscribeResponseModel(
      planCode: _text(root['planCode']) ?? '',
      planPriceCode: _text(root['planPriceCode']) ?? '',
      publicId: _text(root['publicId']),
      status: _text(root['status']) ?? '',
      paymentAttemptRef: _text(root['paymentAttemptRef']),
      link: _text(root['link']),
      message: dataMessage ?? topMessage ?? '',
    );
  }

  ProSubscribeResultEntity toEntity() {
    return ProSubscribeResultEntity(
      planCode: planCode,
      planPriceCode: planPriceCode,
      publicId: publicId,
      status: status,
      paymentAttemptRef: paymentAttemptRef,
      link: link,
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
