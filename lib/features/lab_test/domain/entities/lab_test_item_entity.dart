import 'package:equatable/equatable.dart';

import 'lab_test_lab_offer_entity.dart';

class LabTestItemEntity extends Equatable {
  const LabTestItemEntity({
    required this.id,
    required this.title,
    required this.sampleType,
    this.labsSummary,
    this.requirement,
    this.discountedFee,
    this.originalFee,
    this.labOffers = const [],
    this.description,
    this.turnaroundHours,
  });

  final String id;
  final String title;
  final String sampleType;
  final String? labsSummary;
  final String? requirement;
  final String? discountedFee;
  final String? originalFee;
  final List<LabTestLabOfferEntity> labOffers;
  final String? description;
  final int? turnaroundHours;

  @override
  List<Object?> get props => [
    id,
    title,
    sampleType,
    labsSummary,
    requirement,
    discountedFee,
    originalFee,
    labOffers,
    description,
    turnaroundHours,
  ];
}
