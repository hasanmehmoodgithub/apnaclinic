import 'package:apnaclinic/core/utils/max_int_text_input_formatter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('MaxIntTextInputFormatter', () {
    const formatter = MaxIntTextInputFormatter(99);

    test('allows empty string', () {
      final result = formatter.formatEditUpdate(
        const TextEditingValue(text: '12'),
        const TextEditingValue(text: ''),
      );
      expect(result.text, '');
    });

    test('allows values <= max (e.g. 1, 9, 99)', () {
      for (final val in ['1', '9', '25', '99']) {
        final result = formatter.formatEditUpdate(
          const TextEditingValue(text: ''),
          TextEditingValue(text: val),
        );
        expect(result.text, val);
      }
    });

    test('rejects values > max (e.g. 100, 150, 999)', () {
      for (final val in ['100', '150', '999']) {
        final result = formatter.formatEditUpdate(
          const TextEditingValue(text: '99'),
          TextEditingValue(text: val),
        );
        expect(result.text, '99');
      }
    });

    test('rejects non-numeric string', () {
      final result = formatter.formatEditUpdate(
        const TextEditingValue(text: '20'),
        const TextEditingValue(text: 'abc'),
      );
      expect(result.text, '20');
    });
  });
}
