import '../../../../core/functional/functional_export.dart';
import '../../../../core/use_case/base_use_case.dart';
import '../repositories/instant_doctor_repository.dart';
import 'send_instant_doctor_otp_params.dart';

class SendInstantDoctorOtpUseCase
    implements UseCaseVoid<SendInstantDoctorOtpParams> {
  SendInstantDoctorOtpUseCase({required this.repository});

  final InstantDoctorRepository repository;

  @override
  Future<Either<ErrorMsg, void>> call(SendInstantDoctorOtpParams params) {
    return repository.sendSubscriptionOtp(params);
  }
}
