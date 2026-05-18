import 'jwt_utils.dart';

/// Shared helpers for auth-related API payloads and responses.
class AuthApiUtils {
  AuthApiUtils._();

  /// Normalizes a phone input to MSISDN digits with Pakistan country code `92`.
  static String normalizeMsisdn(String phoneNumber) {
    var digits = phoneNumber.replaceAll(RegExp(r'\D'), '');
    if (digits.startsWith('0')) {
      digits = digits.substring(1);
    }
    if (!digits.startsWith('92')) {
      digits = '92$digits';
    }
    return digits;
  }

  /// Resolves user id from auth API JSON: explicit fields first, then JWT claims.
  static String? extractUserIdFromAuthResponse(Map<String, dynamic> response) {
    final data = response['data'];
    final dataMap = data is Map<String, dynamic> ? data : <String, dynamic>{};
    final directUserId = dataMap['userId'] ?? response['userId'];
    if (directUserId != null) {
      return directUserId.toString();
    }

    final accessToken = dataMap['accessToken'];
    final accessTokenMap = accessToken is Map<String, dynamic>
        ? accessToken
        : <String, dynamic>{};
    final token = (dataMap['token'] ?? accessTokenMap['token'] ?? '')
        .toString();
    final tokenUserId =
        JwtUtils.claim<dynamic>(token, 'userId') ??
        JwtUtils.claim<dynamic>(token, 'sub');
    return tokenUserId?.toString();
  }
}
