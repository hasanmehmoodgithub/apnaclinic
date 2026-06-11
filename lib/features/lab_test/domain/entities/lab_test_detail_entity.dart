import 'package:equatable/equatable.dart';

import 'lab_test_lab_offer_entity.dart';
import 'lab_test_partner_entity.dart';

class LabTestDetailEntity extends Equatable {
  const LabTestDetailEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.sampleType,
    required this.fastingRequired,
    required this.turnaroundHours,
    required this.partners,
    required this.labOffers,
  });

  final int id;
  final String name;
  final String description;
  final String sampleType;
  final bool fastingRequired;
  final int turnaroundHours;
  final List<LabTestPartnerEntity> partners;
  final List<LabTestLabOfferEntity> labOffers;

  @override
  List<Object?> get props => [
    id,
    name,
    description,
    sampleType,
    fastingRequired,
    turnaroundHours,
    partners,
    labOffers,
  ];
}
