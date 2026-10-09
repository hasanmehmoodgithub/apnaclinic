import 'dart:convert';

enum PaymentWebViewStatus { success, failed, cancelled, pending }

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

  factory PaymentWebViewResult.pending({String? message}) {
    return PaymentWebViewResult(
      status: PaymentWebViewStatus.pending,
      message: message,
    );
  }

  /// Parses Rox/JazzCash `AndroidInterface.postMessage` payloads.
  ///
  /// Accepts plain tokens (`success` / `fail` / `cancel` / `pending`) or JSON:
  /// `{ "status": "success"|"fail"|"pending", "success": true/false, "message": "...", "statusCode": 200 }`.
  /// `status` wins over `success` and `statusCode`.
  static PaymentWebViewResult? tryParseBridgeMessage(String raw) {
    final text = raw.trim();
    if (text.isEmpty) return null;

    final fromToken = _fromPlainToken(text.toLowerCase());
    if (fromToken != null) return fromToken;

    try {
      final decoded = jsonDecode(text);
      if (decoded is Map) {
        return fromGatewayMap(Map<String, dynamic>.from(decoded));
      }
      if (decoded is String) {
        return _fromPlainToken(decoded.trim().toLowerCase());
      }
    } catch (_) {
      return null;
    }
    return null;
  }

  static PaymentWebViewResult? fromGatewayMap(Map<String, dynamic> map) {
    final status = _readString(
      map,
      const ['status', 'paymentStatus', 'payment_status', 'result', 'txnStatus'],
    )?.toLowerCase();
    final message = _readString(map, const ['message', 'msg', 'error', 'errorMessage']);
    final successFlag = _readBool(map['success']);
    final statusCode = int.tryParse(
      '${map['statusCode'] ?? map['status_code'] ?? map['code'] ?? ''}',
    );

    if (status == 'pending') {
      return PaymentWebViewResult.pending(message: message);
    }

    final isCancel = _isCancelStatus(status) || _messageLooksCancelled(message);
    final isFail = _isFailStatus(status);
    final isSuccess = _isSuccessStatus(status);

    if (isCancel && !isSuccess) {
      return PaymentWebViewResult.cancelled(message: message);
    }
    if (isFail) {
      return PaymentWebViewResult.failed(message: message);
    }
    if (isSuccess || successFlag == true) {
      return PaymentWebViewResult.success(message: message);
    }
    if (successFlag == false || (statusCode != null && statusCode >= 400)) {
      return PaymentWebViewResult.failed(message: message);
    }
    return null;
  }

  static PaymentWebViewResult? _fromPlainToken(String lower) {
    if (_successTokens.contains(lower)) {
      return PaymentWebViewResult.success();
    }
    if (_cancelTokens.contains(lower)) {
      return PaymentWebViewResult.cancelled();
    }
    if (_failTokens.contains(lower)) {
      return PaymentWebViewResult.failed();
    }
    if (lower == 'pending') {
      return PaymentWebViewResult.pending();
    }
    return null;
  }

  static const _successTokens = {'success', 'true', 'ok', 'paid'};
  static const _failTokens = {
    'fail',
    'failed',
    'failure',
    'error',
    'declined',
    'timeout',
    'unsuccessful',
  };
  static const _cancelTokens = {
    'cancel',
    'cancelled',
    'canceled',
    'abort',
    'aborted',
    'dropped',
    'user_cancelled',
    'user_canceled',
  };

  static bool _isSuccessStatus(String? status) {
    return status != null && _successTokens.contains(status);
  }

  static bool _isFailStatus(String? status) {
    return status != null && _failTokens.contains(status);
  }

  static bool _isCancelStatus(String? status) {
    return status != null && _cancelTokens.contains(status);
  }

  static bool _messageLooksCancelled(String? message) {
    final lower = (message ?? '').toLowerCase();
    if (lower.isEmpty) return false;
    return lower.contains('dropped') ||
        lower.contains('cancel') ||
        lower.contains('abort');
  }

  static String? _readString(Map<String, dynamic> map, List<String> keys) {
    for (final key in keys) {
      final value = map[key];
      if (value == null) continue;
      final text = value.toString().trim();
      if (text.isNotEmpty && text.toLowerCase() != 'null') return text;
    }
    return null;
  }

  static bool? _readBool(dynamic value) {
    if (value is bool) return value;
    if (value is num) return value != 0;
    if (value is String) {
      final lower = value.trim().toLowerCase();
      if (lower == 'true' || lower == '1' || lower == 'success' || lower == 'ok') {
        return true;
      }
      if (lower == 'false' ||
          lower == '0' ||
          lower == 'fail' ||
          lower == 'failed' ||
          lower == 'failure') {
        return false;
      }
    }
    return null;
  }
}
