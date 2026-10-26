class ApnaClinicAiHomeResumeModel {
  const ApnaClinicAiHomeResumeModel({
    required this.conversationId,
    required this.title,
    required this.subtitle,
    required this.send,
    this.badge,
  });

  final String conversationId;
  final String title;
  final String subtitle;
  final String send;
  final String? badge;
}
