import 'package:equatable/equatable.dart';

class ProSubscribeResultEntity extends Equatable {
  const ProSubscribeResultEntity({
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

  bool get opensJazzCash {
    final url = link?.trim() ?? '';
    return url.startsWith('http://') || url.startsWith('https://');
  }

  @override
  List<Object?> get props => [
        planCode,
        planPriceCode,
        publicId,
        status,
        paymentAttemptRef,
        link,
        message,
      ];
}
