class ConsultationSlotsErrorUtils {
  ConsultationSlotsErrorUtils._();

  static String toUserMessage(String error) {
    final trimmed = error.trim();
    if (trimmed.isEmpty) {
      return 'Unable to load availability right now.';
    }

    var message = trimmed;
    if (message.toLowerCase().startsWith('message from upstream:')) {
      message = message
          .replaceFirst(
            RegExp(r'^message from upstream:\s*', caseSensitive: false),
            '',
          )
          .replaceAll(RegExp(r',\s*/[^\s,]+$'), '')
          .trim();
    }

    final lower = message.toLowerCase();
    if (lower.contains('doctor hospital not found') ||
        lower.contains('hospital not found')) {
      return 'This doctor has no available appointment slots at the moment.';
    }
    if (lower.contains('no slots') || lower.contains('slot not found')) {
      return 'No appointment slots are available for this doctor right now.';
    }

    return message;
  }
}
