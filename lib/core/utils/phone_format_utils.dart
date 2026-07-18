import 'auth_api_utils.dart';

class PhoneFormatUtils {
  PhoneFormatUtils._();

  static String toMsisdn(String input) => AuthApiUtils.normalizeMsisdn(input);

  static String toLocalDisplay(String msisdn) {
    final digits = msisdn.replaceAll(RegExp(r'\D'), '');
    if (digits.startsWith('92') && digits.length >= 12) {
      return '0${digits.substring(2)}';
    }
    if (digits.startsWith('0')) return digits;
    return msisdn;
  }

  /// Mobile (11 digits) or landline/PTCL (10 digits). Max length 11.
  static bool isValidMobileOrLandline(String value) {
    final digits = value.replaceAll(RegExp(r'\D'), '');
    return digits.length == 10 || digits.length == 11;
  }
}
