import 'package:equatable/equatable.dart';

class PromoCodeValidationEntity extends Equatable {
  const PromoCodeValidationEntity({
    required this.code,
    required this.discountType,
    required this.discountValue,
    required this.originalAmount,
    required this.discountAmount,
    required this.payableAmount,
    this.freeDelivery = false,
    this.note = '',
  });

  final String code;
  final String discountType;
  final double discountValue;
  final int originalAmount;
  final int discountAmount;
  final int payableAmount;

  /// Pharmacy: when true, delivery is free for this applied promo.
  final bool freeDelivery;
  final String note;

  @override
  List<Object?> get props => [
        code,
        discountType,
        discountValue,
        originalAmount,
        discountAmount,
        payableAmount,
        freeDelivery,
        note,
      ];
}
