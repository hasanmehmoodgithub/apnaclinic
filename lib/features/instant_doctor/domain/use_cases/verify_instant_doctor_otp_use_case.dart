import '../../../../core/functional/functional_export.dart';
import '../../../../core/use_case/base_use_case.dart';
import '../repositories/instant_doctor_repository.dart';
import 'verify_instant_doctor_otp_params.dart';

class VerifyInstantDoctorOtpUseCase
    implements UseCaseVoid<VerifyInstantDoctorOtpParams> {
  VerifyInstantDoctorOtpUseCase({required this.repository});

  final InstantDoctorRepository repository;

  @override
  Future<Either<ErrorMsg, void>> call(VerifyInstantDoctorOtpParams params) {
    return repository.verifySubscriptionOtp(params);
  }
}
