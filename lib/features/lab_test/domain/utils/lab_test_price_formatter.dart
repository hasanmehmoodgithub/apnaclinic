class LabTestPriceFormatter {
  LabTestPriceFormatter._();

  static String formatRs(int amount) => 'Rs. ${_formatAmount(amount)}/-';

  static bool isSameFee(String? a, String? b) {
    final left = (a ?? '').trim();
    final right = (b ?? '').trim();
    if (left.isEmpty || right.isEmpty) return left == right;
    if (left == right) return true;
    final leftDigits = _digitsOnly(left);
    final rightDigits = _digitsOnly(right);
    return leftDigits.isNotEmpty && leftDigits == rightDigits;
  }

  static String _digitsOnly(String value) =>
      value.replaceAll(RegExp(r'[^0-9]'), '');

  static String _formatAmount(int amount) {
    final text = amount.toString();
    final buffer = StringBuffer();
    for (var i = 0; i < text.length; i++) {
      final fromEnd = text.length - i;
      if (i > 0 && fromEnd % 3 == 0) {
        buffer.write(',');
      }
      buffer.write(text[i]);
    }
    return buffer.toString();
  }
}
