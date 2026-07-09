import 'doctor_consultation_checkout_args.dart';

class DoctorConsultationSummaryArgs {
  const DoctorConsultationSummaryArgs({
    required this.checkoutArgs,
    required this.paymentMethodCode,
    required this.paymentMethodName,
    required this.accountNumber,
    required this.msisdn,
    required this.consultationFee,
    required this.discount,
    required this.total,
  });

  final DoctorConsultationCheckoutArgs checkoutArgs;
  final String paymentMethodCode;
  final String paymentMethodName;
  final String accountNumber;
  final String msisdn;
  final int consultationFee;
  final int discount;
  final int total;
}
