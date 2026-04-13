import 'package:equatable/equatable.dart';

class ConsultationCategoryEntity extends Equatable {
  final String id;
  final String title;
  final String description;
  final String iconUrl;

  const ConsultationCategoryEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.iconUrl,
  });

  @override
  List<Object?> get props => [id, title, description, iconUrl];
}
