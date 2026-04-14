import '../../../../core/preference/app_pref.dart';
import '../../../auth/domain/models/auth_result.dart';
import '../../../auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({required AppPref appPref}) : _appPref = appPref;

  final AppPref _appPref;

  @override
  Future<AuthResult> requestOtp({required String phoneNumber}) async {
    await Future<void>.delayed(const Duration(milliseconds: 600));

    if (phoneNumber.length < 10) {
      return const AuthResult(
        success: false,
        message: 'Please enter a valid mobile number.',
      );
    }

    return const AuthResult(success: true);
  }

  @override
  Future<AuthResult> verifyOtp({
    required String phoneNumber,
    required String otp,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 700));

    if (otp.length != 4) {
      return const AuthResult(
        success: false,
        message: 'Please enter a valid OTP code.',
      );
    }

    // Placeholder for API-ready auth integration.
    await _appPref.setLoginStatus(true);
    await _appPref.setUserId(phoneNumber);
    await _appPref.setString('profile_phone', phoneNumber);
    await _appPref.setToken('mock-token');

    return const AuthResult(success: true);
  }
}
