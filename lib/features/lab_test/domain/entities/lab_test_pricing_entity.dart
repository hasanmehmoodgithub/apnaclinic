import 'package:equatable/equatable.dart';

class LabTestPricingEntity extends Equatable {
  const LabTestPricingEntity({
    required this.discountedFee,
    required this.originalFee,
    required this.discountPercent,
    required this.discountAmount,
    required this.discountCode,
    required this.totalAmount,
  });

  final String discountedFee;
  final String originalFee;
  final int discountPercent;
  final String discountAmount;
  final String discountCode;
  final String totalAmount;

  @override
  List<Object?> get props => [
    discountedFee,
    originalFee,
    discountPercent,
    discountAmount,
    discountCode,
    totalAmount,
  ];
}
