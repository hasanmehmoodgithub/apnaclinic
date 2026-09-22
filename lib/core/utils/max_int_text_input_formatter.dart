import 'package:flutter/services.dart';

/// Restricts numeric text input so its parsed integer value never exceeds [max].
class MaxIntTextInputFormatter extends TextInputFormatter {
  const MaxIntTextInputFormatter(this.max);

  final int max;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) return newValue;
    final value = int.tryParse(newValue.text);
    if (value == null || value > max) {
      return oldValue;
    }
    return newValue;
  }
}
