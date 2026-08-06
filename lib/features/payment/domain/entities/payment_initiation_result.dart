/// Result of initiating a booking that may require card payment in a WebView.
class PaymentInitiationResult {
  const PaymentInitiationResult({
    this.paymentUrl,
    this.orderId,
    this.publicId,
    this.status,
    this.inProgress = false,
    this.message,
  });

  final String? paymentUrl;
  final String? orderId;
  final String? publicId;
  final String? status;
  final bool inProgress;
  final String? message;

  bool get requiresCardPayment {
    final url = paymentUrl?.trim() ?? '';
    return url.isNotEmpty;
  }

  /// Parses booking/checkout API envelopes that include `data.paymentUrl`.
  factory PaymentInitiationResult.fromBookingResponse(
    Map<String, dynamic> response,
  ) {
    final data = response['data'];
    final map = data is Map
        ? Map<String, dynamic>.from(data)
        : <String, dynamic>{};

    String? read(List<String> keys) {
      for (final key in keys) {
        final value = map[key];
        if (value == null) continue;
        final text = value.toString().trim();
        if (text.isNotEmpty) return text;
      }
      return null;
    }

    return PaymentInitiationResult(
      paymentUrl: read(const ['paymentUrl', 'payment_url']),
      orderId: read(const [
        'orderId',
        'order_id',
        'bookingId',
        'booking_id',
        'orderNo',
        'order_no',
      ]),
      publicId: read(const ['publicId', 'public_id']),
      status: read(const ['status']),
      inProgress:
          map['inProgress'] == true || map['in_progress'] == true,
      message: response['message']?.toString(),
    );
  }
}
