import '../../../../core/functional/functional_export.dart';
import '../../../../core/use_case/base_use_case.dart';
import '../entities/payment_provider_entity.dart';
import '../repositories/consultation_repository.dart';

class GetPaymentProvidersUseCase
    implements UseCaseNoParams<List<PaymentProviderEntity>> {
  GetPaymentProvidersUseCase({required this.repository});

  final ConsultationRepository repository;

  @override
  Future<Either<ErrorMsg, List<PaymentProviderEntity>>> call() {
    return repository.getPaymentProviders();
  }
}
