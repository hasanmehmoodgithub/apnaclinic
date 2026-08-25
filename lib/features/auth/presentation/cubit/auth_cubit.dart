
import 'dart:async';
import 'dart:developer' as developer;

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/analytics/analytics_event_keys.dart';
import '../../../../core/analytics/analytics_service.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../core/enums/app_enums.dart';
import '../../../../core/enums/state_status.dart';
import '../../../../core/preference/app_pref.dart';
import '../../../../core/preference/app_pref_keys.dart';
import '../../../../core/services/appsflyer_service.dart';
import '../../../../core/services/notification_service.dart';
import '../../../../core/session/auth_session_refresh.dart';
import '../../../../core/session/profile_session_sync.dart';
import '../../../../core/preference/user_local_model.dart';
import '../../../../core/utils/jwt_utils.dart';
import '../../../profile_setup/domain/use_cases/get_profile_setup_content_use_case.dart';
import '../../domain/entities/auth_entity.dart';
import '../../domain/use_cases/request_otp_use_case.dart';
import '../../domain/use_cases/verify_otp_use_case.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit({
    required RequestOtpUseCase requestOtpUseCase,
    required VerifyOtpUseCase verifyOtpUseCase,
    required GetProfileSetupContentUseCase getProfileSetupContentUseCase,
    required AppPref appPref,
    required AuthSessionRefresh sessionRefresh,
    required AnalyticsService analytics,
  }) : _requestOtpUseCase = requestOtpUseCase,
       _verifyOtpUseCase = verifyOtpUseCase,
       _getProfileSetupContentUseCase = getProfileSetupContentUseCase,
       _appPref = appPref,
       _sessionRefresh = sessionRefresh,
       _analytics = analytics,
       super(const AuthState());

  final RequestOtpUseCase _requestOtpUseCase;
  final VerifyOtpUseCase _verifyOtpUseCase;
  final GetProfileSetupContentUseCase _getProfileSetupContentUseCase;
  final AppPref _appPref;
  final AuthSessionRefresh _sessionRefresh;
  final AnalyticsService _analytics;
  Timer? _timer;

  String formatPhoneInput(String input) {
    var digits = input.replaceAll(RegExp(r'\D'), '');
    if (digits.startsWith('0')) {
      digits = digits.substring(1);
    }
    if (digits.startsWith('92') && digits.length > 10) {
      digits = digits.substring(2);
    }
    return '+92$digits';
  }

  String _normalizeLocalPhone(String? value) {
    final digits = (value ?? '').replaceAll(RegExp(r'\D'), '');
    if (digits.startsWith('92') && digits.length > 10) {
      return digits.substring(2);
    }
    if (digits.startsWith('0') && digits.length > 10) {
      return digits.substring(1);
    }
    return digits;
  }

  // ---------- UI interactions ----------
  bool onPhoneInputChanged(String value) {
    clearError();
    if (!state.otpRequested) return false;

    final currentDraftPhone = _normalizeLocalPhone(value);
    final requestedPhone = _normalizeLocalPhone(state.phoneNumber);
    if (currentDraftPhone == requestedPhone) return false;

    hideOtpSection();
    return true;
  }

  // ---------- Login flow ----------
  Future<AuthSubmitResult> submitLogin({
    required bool isFormValid,
    required String rawPhoneInput,
    required String otpCode,
  }) async {
    if (!isFormValid) return AuthSubmitResult.validationFailed;
    final phone = formatPhoneInput(rawPhoneInput.trim());

    if (!state.otpRequested) {
      final success = await requestOtp(phone);
      return success ? AuthSubmitResult.otpSent : AuthSubmitResult.failed;
    }

    if (otpCode.length != 4) return AuthSubmitResult.invalidOtp;

    final result = await verifyOtp(otpCode);
    if (!result.isSuccess) return AuthSubmitResult.failed;
    return result.goToHome
        ? AuthSubmitResult.verifiedGoHome
        : AuthSubmitResult.verifiedGoProfileSetup;
  }

  Future<bool> requestOtp(String phoneNumber) async {
    emit(
      state.copyWith(
        isLoading: true,
        phoneNumber: phoneNumber,
        requestOtpLoadingStateStatus: StateStatus.loading,
        errorMessage: null,
      ),
    );

    final result = await _requestOtpUseCase(
      RequestOtpParams(phoneNumber: phoneNumber, channel: 'SMS'),
    );
    if (isClosed) return false;
    return result.fold(
      (error) {
        emit(
          state.copyWith(
            isLoading: false,
            requestOtpLoadingStateStatus: StateStatus.error,
            errorMessage: error,
          ),
        );
        return false;
      },
      (entity) {
        _startOtpTimer(expiresInSeconds: entity.expiresInSeconds);
        emit(
          _otpRequestedSuccessState(expiresInSeconds: entity.expiresInSeconds),
        );
        unawaited(_analytics.logEvent(AnalyticsEventKeys.otpSent));
        return true;
      },
    );
  }

  Future<VerifyOtpOutcome> verifyOtp(String otp) async {
    emit(
      state.copyWith(
        isLoading: true,
        verifyOtpLoadingStateStatus: StateStatus.loading,
        errorMessage: null,
      ),
    );

    final fcmToken = await _resolveFcmToken();
    final result = await _verifyOtpUseCase(
      VerifyOtpParams(
        phoneNumber: state.phoneNumber,
        otp: otp,
        fcmToken: fcmToken,
      ),
    );
    if (isClosed) {
      return const VerifyOtpOutcome(isSuccess: false, goToHome: false);
    }
    return result.fold(
      (error) {
        emit(
          state.copyWith(
            isLoading: false,
            verifyOtpLoadingStateStatus: StateStatus.error,
            errorMessage: error,
          ),
        );
        return const VerifyOtpOutcome(isSuccess: false, goToHome: false);
      },
      (entity) async {
        await _saveUserSession(entity: entity);
        await _markLoginFcmToken(fcmToken);
        if (isClosed) {
          return const VerifyOtpOutcome(isSuccess: false, goToHome: false);
        }
        emit(
          state.copyWith(
            isLoading: false,
            verifyOtpLoadingStateStatus: StateStatus.success,
            errorMessage: null,
          ),
        );
        unawaited(_analytics.logEvent(AnalyticsEventKeys.otpVerified));
        return VerifyOtpOutcome(
          isSuccess: true,
          goToHome: entity.isOnboardingCompleted,
        );
      },
    );
  }

  void clearError() {
    if (state.errorMessage == null) return;
    emit(state.copyWith(errorMessage: null));
  }

  void setPhoneNumber(String phoneNumber) {
    if (phoneNumber.isEmpty || phoneNumber == state.phoneNumber) return;
    emit(
      state.copyWith(
        phoneNumber: phoneNumber,
        otpRequested: false,
        errorMessage: null,
      ),
    );
  }

  void hideOtpSection() {
    _timer?.cancel();
    emit(
      state.copyWith(
        otpRequested: false,
        otpSecondsRemaining: 30,
        errorMessage: null,
      ),
    );
  }

  void logAuthScreenViewed(String source) {
    unawaited(
      _analytics.logEvent(AnalyticsEventKeys.authenticationScreenViewed, {
        AnalyticsParamKeys.source: source,
      }),
    );
  }

  // ---------- Private helpers ----------
  AuthState _otpRequestedSuccessState({int? expiresInSeconds}) {
    return state.copyWith(
      isLoading: false,
      requestOtpLoadingStateStatus: StateStatus.success,
      otpSecondsRemaining: _resolveOtpExpirySeconds(expiresInSeconds),
      otpRequested: true,
      errorMessage: null,
    );
  }

  int _resolveOtpExpirySeconds(int? expiresInSeconds) {
    if (expiresInSeconds == null || expiresInSeconds <= 0) return 30;
    return expiresInSeconds;
  }

  Future<String?> _resolveFcmToken() async {
    developer.log('Resolving FCM token for login', name: 'AuthCubit');

    if (sl.isRegistered<NotificationService>()) {
      final service = sl<NotificationService>();
      developer.log(
        'NotificationService registered '
        '(initialized=${service.isInitialized}, '
        'permissionsPrepared=${service.permissionsPrepared})',
        name: 'AuthCubit',
      );
      final token = await service.ensureFcmTokenForLogin();
      if (token != null && token.isNotEmpty) {
        developer.log(
          'Using FCM token for login (length=${token.length})  (token=${token})',
          name: 'AuthCubit',
        );
        return token;
      }
      developer.log('FCM token still empty after ensure', name: 'AuthCubit');
    } else {
      developer.log('NotificationService not registered', name: 'AuthCubit');
    }

    final stored = _appPref.getString(AppPrefKeys.fcmToken)?.trim();
    if (stored != null && stored.isNotEmpty) {
      developer.log(
        'Using stored FCM token from prefs (length=${stored.length})',
        name: 'AuthCubit',
      );
      return stored;
    }

    developer.log('No FCM token available for login', name: 'AuthCubit');
    return null;
  }

  Future<void> _markLoginFcmToken(String? fcmToken) async {
    if (!sl.isRegistered<NotificationService>()) return;
    final service = sl<NotificationService>();
    final token = fcmToken?.trim();
    if (token != null && token.isNotEmpty) {
      await service.markDeviceTokenUploaded(token);
      return;
    }
    unawaited(service.syncDeviceTokenIfNeeded());
  }

  Future<void> _saveUserSession({required AuthEntity entity}) async {
    final tokenUserId = JwtUtils.claim<dynamic>(entity.token, 'sub');
    final resolvedUserId =
        entity.userId ??
        (tokenUserId != null ? tokenUserId.toString() : state.phoneNumber);

    await _appPref.setLoginStatus(true);
    sl<ProfileSessionSync>().invalidate();
    await _appPref.setUserId(resolvedUserId);
    if (sl.isRegistered<AppsFlyerService>()) {
      sl<AppsFlyerService>().setCustomerUserId(resolvedUserId);
    }
    await _appPref.setToken(entity.token ?? '');
    await _appPref.setRefreshToken(entity.refreshToken ?? '');
    await _appPref.setAccessTokenExpiresIn(entity.accessTokenExpiresIn ?? 0);
    await _appPref.setRefreshTokenExpiresIn(entity.refreshTokenExpiresIn ?? 0);
    await _appPref.setProfileCompleted(entity.isOnboardingCompleted);
    await _appPref.setUserLocalModel(
      UserLocalModel(
        firstName: entity.firstName ?? '',
        lastName: entity.lastName ?? '',
        phone: state.phoneNumber,
        gender: entity.gender ?? '',
        email: entity.email ?? '',
        address: entity.address ?? '',
        dateOfBirth: entity.dateOfBirth ?? '',
      ),
    );
    if (entity.isOnboardingCompleted) {
      // OTP payload often omits name; load GET /users/{id} before UI remounts.
      await _hydrateProfileAfterLogin();
    }

    // Only refresh the dashboard shell when profile is complete. Otherwise
    // HomeScreen remounts under the login route and opens the promo heart loader.
    if (entity.isOnboardingCompleted) {
      _sessionRefresh.notifyLoggedIn();
    }
  }

  Future<void> _hydrateProfileAfterLogin() async {
    final result = await _getProfileSetupContentUseCase.call();
    result.fold(
      (error) {
        developer.log(
          'Post-OTP profile hydrate failed: $error',
          name: 'AuthCubit',
        );
      },
      (_) {
        _sessionRefresh.notifyProfileUpdated();
      },
    );
  }

  void _startOtpTimer({int? expiresInSeconds}) {
    final startingSeconds = _resolveOtpExpirySeconds(expiresInSeconds);
    _timer?.cancel();
    emit(state.copyWith(otpSecondsRemaining: startingSeconds));
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final nextValue = state.otpSecondsRemaining - 1;
      if (nextValue <= 0) {
        emit(state.copyWith(otpSecondsRemaining: 0));
        timer.cancel();
      } else {
        emit(state.copyWith(otpSecondsRemaining: nextValue));
      }
    });
  }

  // ---------- Lifecycle ----------
  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}

class VerifyOtpOutcome {
  const VerifyOtpOutcome({required this.isSuccess, required this.goToHome});

  final bool isSuccess;
  final bool goToHome;
}
