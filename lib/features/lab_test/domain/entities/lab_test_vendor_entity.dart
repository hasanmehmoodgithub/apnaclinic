import 'package:equatable/equatable.dart';

class LabTestVendorEntity extends Equatable {
  const LabTestVendorEntity({
    required this.id,
    required this.name,
    required this.logoUrl,
    this.markUrl,
    this.publicId,
    this.slug = '',
    this.supportsHomeSampling = true,
    this.supportsWalkIn = true,
    this.homeSamplingFee,
    this.rating,
    this.estimatedReportHours,
  });

  final String id;
  final String name;
  final String logoUrl;
  final String? markUrl;
  final String? publicId;
  final String slug;
  final bool supportsHomeSampling;
  final bool supportsWalkIn;
  final String? homeSamplingFee;
  final String? rating;
  final int? estimatedReportHours;

  @override
  List<Object?> get props => [
    id,
    name,
    logoUrl,
    markUrl,
    publicId,
    slug,
    supportsHomeSampling,
    supportsWalkIn,
    homeSamplingFee,
    rating,
    estimatedReportHours,
  ];
}
