import 'package:equatable/equatable.dart';

class LabTestItemEntity extends Equatable {
  const LabTestItemEntity({
    required this.id,
    required this.title,
    required this.sampleType,
    this.labsSummary,
    this.requirement,
    this.discountedFee,
    this.originalFee,
  });

  final String id;
  final String title;
  final String sampleType;
  final String? labsSummary;
  final String? requirement;
  final String? discountedFee;
  final String? originalFee;

  @override
  List<Object?> get props => [
    id,
    title,
    sampleType,
    labsSummary,
    requirement,
    discountedFee,
    originalFee,
  ];
}
