import '../../../../core/functional/functional_export.dart';
import '../entities/auth_entity.dart';
import '../use_cases/logout_use_case.dart';
import '../use_cases/request_otp_use_case.dart';
import '../use_cases/verify_otp_use_case.dart';

abstract class AuthRepository {
  Future<Either<ErrorMsg, AuthEntity>> requestOtp(RequestOtpParams params);

  Future<Either<ErrorMsg, AuthEntity>> verifyOtp(VerifyOtpParams params);

  Future<Either<ErrorMsg, void>> logout(LogoutParams params);
}
