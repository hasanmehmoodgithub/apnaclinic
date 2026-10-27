import '../../../../core/preference/app_pref.dart';
import '../../../../core/utils/auth_guard.dart';
import '../../domain/utils/apna_clinic_ai_msisdn.dart';
import '../data_sources/apna_clinic_ai_local_data_source.dart';
import 'apna_clinic_ai_sdk_auth_context.dart';

/// Builds [ApnaClinicAiSdkAuthContext] from app login + device id.
class ApnaClinicAiSdkAuthResolver {
  const ApnaClinicAiSdkAuthResolver({
    required AppPref appPref,
    required ApnaClinicAiLocalDataSource localDataSource,
  }) : _appPref = appPref,
       _localDataSource = localDataSource;

  final AppPref _appPref;
  final ApnaClinicAiLocalDataSource _localDataSource;

  Future<ApnaClinicAiSdkAuthContext> resolve() async {
    final signedIn = AuthGuard.isLoggedIn(_appPref);
    final deviceId = await _localDataSource.deviceId();
    if (!signedIn) {
      return ApnaClinicAiSdkAuthContext(
        mode: 'guest',
        deviceId: deviceId,
      );
    }

    final user = _appPref.getUserLocalModel();
    final fullName = [
      user?.firstName.trim() ?? '',
      user?.lastName.trim() ?? '',
    ].where((part) => part.isNotEmpty).join(' ');
    final rawEmail = user?.email.trim() ?? '';

    return ApnaClinicAiSdkAuthContext(
      mode: 'signed_in',
      deviceId: deviceId,
      msisdn: normalizeApnaClinicAiMsisdn(user?.phone),
      name: fullName.isEmpty ? null : fullName,
      email: rawEmail.isEmpty ? null : rawEmail,
    );
  }
}
