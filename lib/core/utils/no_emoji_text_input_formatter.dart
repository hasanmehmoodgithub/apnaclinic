import 'package:flutter/services.dart';

/// Blocks emoji from typed or pasted text.
///
/// Keeps letters, digits, and whitespace by default.
/// Set [allowEmailSymbols] for email fields (`@ . _ + -`).
/// Set [allowBasicPunctuation] for free-text fields (`. , ' - ? !`).
/// Set [allowSpecialCharacters] for address-style fields (punctuation/symbols,
/// still no emoji).
class NoEmojiTextInputFormatter extends TextInputFormatter {
  NoEmojiTextInputFormatter({
    this.allowEmailSymbols = false,
    this.allowBasicPunctuation = false,
    this.allowSpecialCharacters = false,
  });

  final bool allowEmailSymbols;
  final bool allowBasicPunctuation;
  final bool allowSpecialCharacters;

  static final RegExp _emojiPattern = RegExp(
    r'[\u{1F1E6}-\u{1F1FF}\u{1F300}-\u{1FAFF}\u{2600}-\u{27BF}\u{FE0F}\u{200D}]',
    unicode: true,
  );

  static final RegExp _letterOrDigitOrSpace = RegExp(
    r'[\p{L}\p{N}\s]',
    unicode: true,
  );

  static const String _emailExtras = '@._+-';
  static const String _basicPunctuation = ".,'?!-";

  /// Prefer this when wiring fields so the block applies before other formatters.
  static List<TextInputFormatter> merge(
    List<TextInputFormatter>? formatters, {
    bool allowEmailSymbols = false,
    bool allowBasicPunctuation = false,
    bool allowSpecialCharacters = false,
  }) {
    return <TextInputFormatter>[
      NoEmojiTextInputFormatter(
        allowEmailSymbols: allowEmailSymbols,
        allowBasicPunctuation: allowBasicPunctuation,
        allowSpecialCharacters: allowSpecialCharacters,
      ),
      ...?formatters,
    ];
  }

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final sanitized = _sanitize(newValue.text);
    if (sanitized == newValue.text) {
      return newValue;
    }

    final removedCount = newValue.text.length - sanitized.length;
    final selectionOffset = (newValue.selection.end - removedCount).clamp(
      0,
      sanitized.length,
    );

    return TextEditingValue(
      text: sanitized,
      selection: TextSelection.collapsed(offset: selectionOffset),
      composing: TextRange.empty,
    );
  }

  String _sanitize(String input) {
    final buffer = StringBuffer();
    for (final unit in input.runes) {
      final char = String.fromCharCode(unit);
      if (_isAllowed(char)) {
        buffer.write(char);
      }
    }
    return buffer.toString();
  }

  bool _isAllowed(String char) {
    if (_emojiPattern.hasMatch(char)) return false;
    if (allowSpecialCharacters) return true;
    if (_letterOrDigitOrSpace.hasMatch(char)) return true;
    if (allowEmailSymbols && _emailExtras.contains(char)) return true;
    if (allowBasicPunctuation && _basicPunctuation.contains(char)) {
      return true;
    }
    return false;
  }
}
