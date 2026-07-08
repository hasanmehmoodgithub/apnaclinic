import 'package:equatable/equatable.dart';

class InstantDoctorProductEntity extends Equatable {
  const InstantDoctorProductEntity({
    required this.productId,
    required this.productCode,
    required this.productType,
    required this.productTitle,
    required this.priceDisplay,
    required this.benefits,
    required this.redirectUrl,
  });

  final int productId;
  final String productCode;
  final String productType;
  final String productTitle;
  final String priceDisplay;
  final List<String> benefits;
  final String redirectUrl;

  @override
  List<Object?> get props => [
    productId,
    productCode,
    productType,
    productTitle,
    priceDisplay,
    benefits,
    redirectUrl,
  ];
}
