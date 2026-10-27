/// Branding fields from `GET /sdk/app` (assistant name, chips, voice flags).
class ApnaClinicAiSdkBranding {
  const ApnaClinicAiSdkBranding({
    this.assistantName = 'Apna Clinic Ai Noor',
    this.welcomeMessage = '',
    this.suggestions = const [],
    this.composerHint = '',
    this.headerSubtitle = '',
    this.voiceEnabled = false,
    this.voiceOutputEnabled = false,
  });

  final String assistantName;
  final String welcomeMessage;
  final List<String> suggestions;
  final String composerHint;
  final String headerSubtitle;
  final bool voiceEnabled;
  final bool voiceOutputEnabled;

  /// Parses `/sdk/app` JSON. [fallbackWelcome] keeps init greeting when app
  /// branding has no welcome text.
  factory ApnaClinicAiSdkBranding.fromAppMap(
    Map<String, dynamic> app, {
    String fallbackWelcome = '',
  }) {
    final branding = app['branding'];
    final source = branding is Map ? branding : app;

    var assistantName = 'Apna Clinic Ai Noor';
    final nameFromApi = (source['assistant_name'] ?? app['assistant_name'])
        ?.toString()
        .trim();
    if (nameFromApi != null && nameFromApi.isNotEmpty) {
      assistantName = nameFromApi;
    }

    var welcomeMessage = fallbackWelcome.trim();
    if (welcomeMessage.isEmpty) {
      welcomeMessage =
          (source['welcome_message'] ?? app['welcome_message'] ?? '')
              .toString()
              .trim();
    }

    var composerHint = '';
    var headerSubtitle = '';
    final theme = app['theme'];
    if (theme is Map) {
      headerSubtitle = (theme['header_subtitle'] ?? '').toString().trim();
      final placeholder = (theme['input_placeholder'] ?? '').toString().trim();
      if (placeholder.isNotEmpty) composerHint = placeholder;
    }

    var suggestions = const <String>[];
    final raw = source['suggestions'] ?? app['suggestions'];
    if (raw is List) {
      suggestions = raw
          .map((item) => item.toString().trim())
          .where((item) => item.isNotEmpty)
          .toList();
    }

    var voiceEnabled = false;
    var voiceOutputEnabled = false;
    final voice = source['voice'] ?? app['voice'];
    if (voice is Map) {
      final input = voice['input'];
      if (input is Map) voiceEnabled = input['enabled'] == true;
      final output = voice['output'];
      if (output is Map) voiceOutputEnabled = output['enabled'] == true;
    }

    return ApnaClinicAiSdkBranding(
      assistantName: assistantName,
      welcomeMessage: welcomeMessage,
      suggestions: suggestions,
      composerHint: composerHint,
      headerSubtitle: headerSubtitle,
      voiceEnabled: voiceEnabled,
      voiceOutputEnabled: voiceOutputEnabled,
    );
  }
}
