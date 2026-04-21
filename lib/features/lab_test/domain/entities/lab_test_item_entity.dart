import 'package:equatable/equatable.dart';

class LabTestItemEntity extends Equatable {
  const LabTestItemEntity({
    required this.id,
    required this.title,
    required this.sampleType,
    this.requirement,
  });

  final String id;
  final String title;
  final String sampleType;
  final String? requirement;

  @override
  List<Object?> get props => [id, title, sampleType, requirement];
}
