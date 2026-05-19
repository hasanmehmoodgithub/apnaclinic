import '../models/auth_response_model.dart';
import '../../domain/use_cases/request_otp_use_case.dart';
import '../../domain/use_cases/verify_otp_use_case.dart';

abstract class AuthRemoteDataSource {
  Future<AuthResponseModel> requestOtp(RequestOtpParams params);

  Future<AuthResponseModel> verifyOtp(VerifyOtpParams params);

  Future<void> logout(String userId);
}
