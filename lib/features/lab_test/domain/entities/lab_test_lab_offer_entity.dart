import 'package:equatable/equatable.dart';

class LabTestLabOfferEntity extends Equatable {
  const LabTestLabOfferEntity({
    required this.labId,
    required this.labName,
    required this.labSlug,
    required this.partnerId,
    required this.orderType,
    required this.price,
    required this.finalPrice,
    required this.discountPct,
    required this.supportsWalkIn,
    required this.homeSamplingFee,
    required this.supportsHomeSampling,
    this.labLogoUrl = '',
  });

  final int labId;
  final String labName;
  final String labSlug;
  final String partnerId;
  final String orderType;
  final int price;
  final int finalPrice;
  final String labLogoUrl;
  final int discountPct;
  final bool supportsWalkIn;
  final int homeSamplingFee;
  final bool supportsHomeSampling;

  int get effectivePrice => finalPrice;

  @override
  List<Object?> get props => [
    labId,
    labName,
    labSlug,
    partnerId,
    orderType,
    price,
    finalPrice,
    discountPct,
    supportsWalkIn,
    homeSamplingFee,
    supportsHomeSampling,
    labLogoUrl,
  ];
}
