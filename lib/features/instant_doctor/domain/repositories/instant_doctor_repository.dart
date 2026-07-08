import '../../../../core/functional/functional_export.dart';
import '../entities/instant_doctor_entity.dart';
import '../use_cases/cancel_instant_doctor_subscription_params.dart';
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

  Future<Either<ErrorMsg, void>> verifySubscriptionOtp(
    VerifyInstantDoctorOtpParams params,
  );

  Future<Either<ErrorMsg, void>> cancelSubscription(
    CancelInstantDoctorSubscriptionParams params,
  );
}
