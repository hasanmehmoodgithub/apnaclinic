import 'package:equatable/equatable.dart';

class ConsultationCategoryEntity extends Equatable {
  final String id;
  final String title;
  final String displayLabel;
  final String description;
  final String iconUrl;

  const ConsultationCategoryEntity({
    required this.id,
    required this.title,
    required this.displayLabel,
    required this.description,
    required this.iconUrl,
  });

  String get cardTitle =>
      displayLabel.trim().isNotEmpty ? displayLabel.trim() : title;

  @override
  List<Object?> get props => [id, title, displayLabel, description, iconUrl];
}
