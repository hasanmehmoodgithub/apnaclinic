/// Existing unpaid/failed order returned by a booking/checkout API.
class PaymentBlockingOrder {
  const PaymentBlockingOrder({
    this.orderId,
    this.publicId,
    this.status,
    this.paymentStatus,
    this.paymentMethod,
    this.canAbandon = false,
    this.message,
  });

  final String? orderId;
  final String? publicId;
  final String? status;
  final String? paymentStatus;
  final String? paymentMethod;
  final bool canAbandon;
  final String? message;

  factory PaymentBlockingOrder.fromMap(Map<String, dynamic> map) {
    String? read(List<String> keys) {
      for (final key in keys) {
        final value = map[key];
        if (value == null) continue;
        final text = value.toString().trim();
        if (text.isNotEmpty && text.toLowerCase() != 'null') return text;
      }
      return null;
    }

    return PaymentBlockingOrder(
      orderId: read(const ['orderId', 'order_id', 'orderNo', 'order_no']),
      publicId: read(const ['publicId', 'public_id']),
      status: read(const ['status']),
      paymentStatus: read(const ['paymentStatus', 'payment_status']),
      paymentMethod: read(const ['paymentMethod', 'payment_method']),
      canAbandon: map['canAbandon'] == true || map['can_abandon'] == true,
      message: read(const ['message']),
    );
  }

  static PaymentBlockingOrder? tryParse(Map<String, dynamic> source) {
    final raw = source['blockingOrder'] ?? source['blocking_order'];
    if (raw is! Map) return null;
    final map = Map<String, dynamic>.from(raw);
    if (map.isEmpty) return null;
    return PaymentBlockingOrder.fromMap(map);
  }
}

/// Result of initiating a booking that may require card payment in a WebView.
class PaymentInitiationResult {
  const PaymentInitiationResult({
    this.paymentUrl,
    this.orderId,
    this.publicId,
    this.status,
    this.inProgress = false,
    this.message,
    this.blockingOrder,
  });

  final String? paymentUrl;
  final String? orderId;
  final String? publicId;
  final String? status;
  final bool inProgress;
  final String? message;
  final PaymentBlockingOrder? blockingOrder;

  bool get requiresCardPayment {
    final url = paymentUrl?.trim() ?? '';
    return url.isNotEmpty;
  }

  bool get isPendingPayment {
    return (status ?? '').trim().toUpperCase() == 'PENDING_PAYMENT';
  }

  /// An existing order is blocking a new booking (unpaid / failed card).
  bool get hasBlockingOrder => blockingOrder != null;

  /// `publicId` for abandon APIs (`order_id`), from blocking order then booking data.
  String? get abandonPublicId {
    final fromBlocking = blockingOrder?.publicId?.trim() ?? '';
    if (fromBlocking.isNotEmpty) return fromBlocking;
    final fromRoot = publicId?.trim() ?? '';
    return fromRoot.isEmpty ? null : fromRoot;
  }

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
      blockingOrder: _readBlockingOrder(response, map),
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

  static Map<String, dynamic>? _asMap(dynamic value) {
    if (value is Map) return Map<String, dynamic>.from(value);
    return null;
  }

  static PaymentBlockingOrder? _readBlockingOrder(
    Map<String, dynamic> response,
    Map<String, dynamic> unwrapped,
  ) {
    final data = _asMap(response['data']);
    return PaymentBlockingOrder.tryParse(unwrapped) ??
        (data != null ? PaymentBlockingOrder.tryParse(data) : null) ??
        PaymentBlockingOrder.tryParse(response);
  }
}
