import '../../../../core/functional/functional_export.dart';
import '../../../../core/use_case/base_use_case.dart';
import '../repositories/instant_doctor_repository.dart';
import 'cancel_instant_doctor_subscription_params.dart';

class CancelInstantDoctorSubscriptionUseCase
    implements UseCaseVoid<CancelInstantDoctorSubscriptionParams> {
  CancelInstantDoctorSubscriptionUseCase({required this.repository});

  final InstantDoctorRepository repository;

  @override
  Future<Either<ErrorMsg, void>> call(
    CancelInstantDoctorSubscriptionParams params,
  ) {
    return repository.cancelSubscription(params);
  }
}
