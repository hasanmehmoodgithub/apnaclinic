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

  bool get isPendingPayment {
    return (status ?? '').trim().toUpperCase() == 'PENDING_PAYMENT';
  }

  /// Booking created, but no in-app gateway URL was returned.
  bool get isPendingWithoutPaymentUrl =>
      isPendingPayment && !requiresCardPayment;

  /// Parses booking/checkout API envelopes that include `data.paymentUrl`.
  factory PaymentInitiationResult.fromBookingResponse(
    Map<String, dynamic> response,
  ) {
    final map = _unwrapPayload(response);

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
      paymentUrl: read(const [
        'paymentUrl',
        'payment_url',
        'redirectUrl',
        'redirect_url',
        'checkoutUrl',
        'checkout_url',
        'paymentLink',
        'payment_link',
      ]),
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

  /// Matches pharmacy checkout unwrap: `data` or nested `data.data`.
  static Map<String, dynamic> _unwrapPayload(Map<String, dynamic> response) {
    final data = response['data'];
    if (data is Map) {
      final outer = Map<String, dynamic>.from(data);
      final nested = outer['data'];
      if (nested is Map) {
        return Map<String, dynamic>.from(nested);
      }
      return outer;
    }
    return response;
  }
}
