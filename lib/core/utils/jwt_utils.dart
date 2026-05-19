import 'package:jwt_decoder/jwt_decoder.dart';

/// Utility helpers for decoding and inspecting JWT tokens.
class JwtUtils {
  JwtUtils._();

  /// Returns `true` when token is null/empty or has invalid JWT format.
  static bool isMalformed(String? token) {
    if (token == null || token.trim().isEmpty) {
      return true;
    }

    try {
      JwtDecoder.decode(token);
      return false;
    } catch (_) {
      return true;
    }
  }

  /// Decodes JWT payload into a map.
  ///
  /// Returns `null` if token is empty or invalid.
  static Map<String, dynamic>? decode(String? token) {
    if (token == null || token.trim().isEmpty) {
      return null;
    }

    try {
      return JwtDecoder.decode(token);
    } catch (_) {
      return null;
    }
  }

  /// Returns `true` when token is expired.
  ///
  /// Invalid/empty tokens are treated as expired for safety.
  static bool isExpired(String? token) {
    if (token == null || token.trim().isEmpty) {
      return true;
    }

    try {
      return JwtDecoder.isExpired(token);
    } catch (_) {
      return true;
    }
  }

  /// Returns token expiration date from `exp` claim, if available.
  static DateTime? expirationDate(String? token) {
    if (token == null || token.trim().isEmpty) {
      return null;
    }

    try {
      return JwtDecoder.getExpirationDate(token);
    } catch (_) {
      return null;
    }
  }

  /// Returns remaining token lifetime.
  ///
  /// Returns `Duration.zero` for invalid/expired tokens.
  static Duration timeToExpire(String? token) {
    final expiry = expirationDate(token);
    if (expiry == null) {
      return Duration.zero;
    }

    final remaining = expiry.difference(DateTime.now());
    if (remaining.isNegative) {
      return Duration.zero;
    }

    return remaining;
  }

  /// Reads any claim by key from decoded token payload.
  static T? claim<T>(String? token, String key) {
    final payload = decode(token);
    if (payload == null) {
      return null;
    }

    final value = payload[key];
    if (value is T) {
      return value;
    }

    return null;
  }
}
