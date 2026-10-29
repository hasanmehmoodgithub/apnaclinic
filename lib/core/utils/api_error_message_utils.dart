import 'dart:convert';

/// Parses API error bodies where `message` may be a [String], [List], or nested [Map].
class ApiErrorMessageUtils {
  ApiErrorMessageUtils._();

  /// Returns a user-facing message, or null if nothing usable was found.
  static String? tryParse(dynamic responseData) {
    if (responseData == null) return null;
    if (responseData is List<int>) {
      return tryParse(_decodeBytes(responseData));
    }
    if (responseData is String) {
      final t = responseData.trim();
      if (t.isEmpty) return null;
      return _sanitizeRawMessage(t);
    }
    if (responseData is! Map) return null;
    final map = Map<String, dynamic>.from(responseData);

    final fromMessage = _parseMessageValue(map['message']);
    if (fromMessage != null && fromMessage.isNotEmpty) {
      return fromMessage;
    }

    final detail = map['detail'];
    if (detail is String && detail.trim().isNotEmpty) {
      return detail.trim();
    }

    final errorField = map['error'];
    if (errorField is String && errorField.trim().isNotEmpty) {
      return errorField.trim();
    }
    if (errorField is Map) {
      final nested = Map<String, dynamic>.from(errorField);
      final nestedMsg = _parseMessageValue(nested['message']);
      if (nestedMsg != null && nestedMsg.isNotEmpty) return nestedMsg;
      final nestedErr = nested['error'];
      if (nestedErr is String && nestedErr.trim().isNotEmpty) {
        return nestedErr.trim();
      }
    }

    return null;
  }

  static String parseOrDefault(
    dynamic responseData, [
    String fallback = 'Request failed',
  ]) {
    final parsed = tryParse(responseData);
    if (parsed != null && parsed.isNotEmpty) return parsed;
    return fallback;
  }

  static String? _parseMessageValue(dynamic message) {
    if (message == null) return null;
    if (message is String) {
      final t = message.trim();
      if (t.isEmpty) return null;
      return _sanitizeRawMessage(t);
    }
    if (message is List) {
      final parts = <String>[];
      for (final e in message) {
        if (e is String && e.trim().isNotEmpty) {
          parts.add(e.trim());
        }
      }
      if (parts.isNotEmpty) return parts.join('\n');
      return null;
    }
    if (message is Map) {
      final nested = Map<String, dynamic>.from(message);
      final inner = _parseMessageValue(nested['message']);
      if (inner != null && inner.isNotEmpty) return inner;
      final err = nested['error'];
      if (err is String && err.trim().isNotEmpty) return err.trim();
    }
    return null;
  }

  static dynamic _decodeBytes(List<int> bytes) {
    if (bytes.length >= 4 &&
        bytes[0] == 0x25 &&
        bytes[1] == 0x50 &&
        bytes[2] == 0x44 &&
        bytes[3] == 0x46) {
      return null;
    }
    try {
      final text = utf8.decode(bytes).trim();
      if (text.isEmpty) return null;
      if (text.startsWith('{') || text.startsWith('[')) {
        return jsonDecode(text);
      }
      return text;
    } catch (_) {
      return null;
    }
  }

  /// WAFs often return HTML "Request Rejected" pages; don't show raw HTML to users.
  static String _sanitizeRawMessage(String message) {
    final lower = message.toLowerCase();
    if (lower.contains('request rejected') ||
        (lower.contains('<html') && lower.contains('support id'))) {
      return 'Request was rejected by the server. Please try again, or upload fewer/smaller attachments.';
    }
    if (message.length > 400 && lower.contains('<html')) {
      return 'Request failed. Please try again.';
    }
    return message;
  }
}
