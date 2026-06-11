class LabTestPriceFormatter {
  LabTestPriceFormatter._();

  static String formatRs(int amount) => 'Rs. ${_formatAmount(amount)}/-';

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
