import 'package:equatable/equatable.dart';

/// Open workflow from `GET /sdk/home` `resume` (for example an unpaid booking).
class ApnaClinicAiHomeResumeEntity extends Equatable {
  const ApnaClinicAiHomeResumeEntity({
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

  @override
  List<Object?> get props => [conversationId, title, subtitle, send, badge];
}
