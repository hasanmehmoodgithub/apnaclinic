import 'doctor_consultation_checkout_args.dart';

class DoctorConsultationSummaryArgs {
  const DoctorConsultationSummaryArgs({
    required this.checkoutArgs,
    required this.paymentMethodCode,
    required this.paymentMethodName,
    this.paymentMethodIconUrl = '',
    required this.accountNumber,
    required this.msisdn,
    required this.consultationFee,
    required this.discount,
    required this.total,
    this.promoCode,
    this.promoDiscount = 0,
  });

  final DoctorConsultationCheckoutArgs checkoutArgs;
  final String paymentMethodCode;
  final String paymentMethodName;

  /// Payment-provider `iconUrl` from checkout (JazzCash / Card).
  final String paymentMethodIconUrl;
  final String accountNumber;
  final String msisdn;
  final int consultationFee;
  final int discount;
  final int total;

  /// Applied promo code from checkout; null/empty when none.
  final String? promoCode;

  /// Promo-code discount from validate API; 0 when none applied.
  final int promoDiscount;
}
