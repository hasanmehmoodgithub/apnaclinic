import '../models/auth_result.dart';

abstract class AuthRepository {
  Future<AuthResult> requestOtp({required String phoneNumber});

  Future<AuthResult> verifyOtp({
    required String phoneNumber,
    required String otp,
  });
}
