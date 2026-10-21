class SendApnaClinicAiMessageParams {
  const SendApnaClinicAiMessageParams({
    required this.message,
    this.speak = false,
    this.voiceId,
  });

  final String message;
  final bool speak;
  final String? voiceId;
}
