import 'package:equatable/equatable.dart';

class LabTestLabOfferEntity extends Equatable {
  const LabTestLabOfferEntity({
    required this.labId,
    required this.labName,
    required this.labSlug,
    required this.orderType,
    required this.price,
    this.finalPrice,
    required this.discountPct,
    required this.supportsWalkIn,
    required this.homeSamplingFee,
    required this.supportsHomeSampling,
  });

  final int labId;
  final String labName;
  final String labSlug;
  final String orderType;
  final int price;
  final int? finalPrice;
  final int discountPct;
  final bool supportsWalkIn;
  final int homeSamplingFee;
  final bool supportsHomeSampling;

  int get effectivePrice {
    if (finalPrice != null) return finalPrice!;
    if (discountPct > 0) {
      return (price * (100 - discountPct) / 100).round();
    }
    return price;
  }

  @override
  List<Object?> get props => [
    labId,
    labName,
    labSlug,
    orderType,
    price,
    finalPrice,
    discountPct,
    supportsWalkIn,
    homeSamplingFee,
    supportsHomeSampling,
  ];
}
