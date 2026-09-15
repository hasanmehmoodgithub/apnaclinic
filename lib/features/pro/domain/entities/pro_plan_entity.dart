import 'package:equatable/equatable.dart';

class ProPlanEntity extends Equatable {
  const ProPlanEntity({
    required this.planId,
    required this.price,
    required this.currency,
    required this.currencySymbol,
    required this.durationValue,
    required this.durationUnit,
    required this.priceDisplay,
    required this.durationDisplay,
    required this.isRecommended,
    required this.isCurrent,
  });

  final String planId;
  final double price;
  final String currency;
  final String currencySymbol;
  final int durationValue;
  final String durationUnit;
  final String priceDisplay;
  final String durationDisplay;
  final bool isRecommended;
  final bool isCurrent;

  @override
  List<Object?> get props => [
        planId,
        price,
        currency,
        currencySymbol,
        durationValue,
        durationUnit,
        priceDisplay,
        durationDisplay,
        isRecommended,
        isCurrent,
      ];
}
