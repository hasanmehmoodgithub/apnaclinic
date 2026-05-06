import '../../../../generated/assets.dart';
import '../models/doctor_consultation_checkout_model.dart';

class DoctorConsultationCheckoutMockApi {
  Future<DoctorConsultationCheckoutModel> getCheckout() async {
    await Future<void>.delayed(const Duration(milliseconds: 700));
    return DoctorConsultationCheckoutModel(
      consultationFee: 500,
      discount: 150,
      paymentOptions: const [
        DoctorConsultationPaymentOptionModel(
          id: 'jazz_cash',
          title: 'Jazz Cash',
          description: 'Amount will be charged from your jazz cash account.',
          iconAsset: Assets.iconsJazzCash,
        ),
        DoctorConsultationPaymentOptionModel(
          id: 'debit_card',
          title: 'Debit / Credit Card',
          description: 'Amount will be charged from your card.',
          iconAsset: Assets.iconsDebitCard,
        ),
      ],
      selectedPaymentMethodId: 'jazz_cash',
    );
  }
}
