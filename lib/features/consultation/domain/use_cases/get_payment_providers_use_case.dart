import '../../../../core/functional/functional_export.dart';
import '../../../../core/use_case/base_use_case.dart';
import '../entities/payment_provider_entity.dart';
import '../repositories/consultation_repository.dart';

/// Module query values for [AppUrls.paymentProviders].
abstract final class PaymentProviderModule {
  static const consultation = 'consultation';
  static const pharmacy = 'pharmacy';
  static const labTesting = 'lab-testing';
  static const surgery = 'surgery';

  /// Same as [labTesting].
  static const lab = labTesting;
}

class GetPaymentProvidersParams {
  const GetPaymentProvidersParams({required this.module});

  final String module;
}

class GetPaymentProvidersUseCase
    implements UseCase<List<PaymentProviderEntity>, GetPaymentProvidersParams> {
  GetPaymentProvidersUseCase({required this.repository});

  final ConsultationRepository repository;

  @override
  Future<Either<ErrorMsg, List<PaymentProviderEntity>>> call(
    GetPaymentProvidersParams params,
  ) {
    return repository.getPaymentProviders(module: params.module);
  }
}
