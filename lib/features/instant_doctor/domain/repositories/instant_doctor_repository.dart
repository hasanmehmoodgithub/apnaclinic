import '../../../../core/functional/functional_export.dart';
import '../entities/instant_doctor_entity.dart';
import '../entities/instant_doctor_verify_otp_entity.dart';
import '../use_cases/get_instant_doctor_content_params.dart';
import '../use_cases/send_instant_doctor_otp_params.dart';
import '../use_cases/verify_instant_doctor_otp_params.dart';

abstract class InstantDoctorRepository {
  Future<Either<ErrorMsg, InstantDoctorEntity>> getInstantDoctorContent(
    GetInstantDoctorContentParams params,
  );

  Future<Either<ErrorMsg, void>> sendSubscriptionOtp(
    SendInstantDoctorOtpParams params,
  );

  Future<Either<ErrorMsg, InstantDoctorVerifyOtpEntity>> verifySubscriptionOtp(
    VerifyInstantDoctorOtpParams params,
  );
}
