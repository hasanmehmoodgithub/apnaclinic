import 'package:equatable/equatable.dart';

import 'instant_doctor_product_entity.dart';

class InstantDoctorProviderEntity extends Equatable {
  const InstantDoctorProviderEntity({
    required this.providerId,
    required this.providerName,
    required this.logoUrl,
    required this.isSubscribed,
    required this.product,
  });

  final int providerId;
  final String providerName;
  final String? logoUrl;
  final bool isSubscribed;
  final InstantDoctorProductEntity product;

  @override
  List<Object?> get props => [
    providerId,
    providerName,
    logoUrl,
    isSubscribed,
    product,
  ];
}
