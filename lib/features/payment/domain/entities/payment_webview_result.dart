enum PaymentWebViewStatus { success, failed, cancelled }

class PaymentWebViewResult {
  const PaymentWebViewResult({
    required this.status,
    this.message,
  });

  final PaymentWebViewStatus status;
  final String? message;

  bool get isSuccess => status == PaymentWebViewStatus.success;

  factory PaymentWebViewResult.success({String? message}) {
    return PaymentWebViewResult(
      status: PaymentWebViewStatus.success,
      message: message,
    );
  }

  factory PaymentWebViewResult.failed({String? message}) {
    return PaymentWebViewResult(
      status: PaymentWebViewStatus.failed,
      message: message,
    );
  }

  factory PaymentWebViewResult.cancelled({String? message}) {
    return PaymentWebViewResult(
      status: PaymentWebViewStatus.cancelled,
      message: message,
    );
  }
}
