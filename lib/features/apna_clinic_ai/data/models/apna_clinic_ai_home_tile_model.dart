class ApnaClinicAiHomeTileModel {
  const ApnaClinicAiHomeTileModel({
    required this.id,
    required this.title,
    required this.send,
    this.subtitle,
  });

  final String id;
  final String title;
  final String send;
  final String? subtitle;
}
