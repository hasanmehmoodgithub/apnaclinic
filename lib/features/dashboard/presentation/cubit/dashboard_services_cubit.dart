import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/dependency_injection.dart';
import '../../../../core/enums/state_status.dart';
import '../../../../core/preference/app_pref.dart';
import '../../../../core/session/auth_session_refresh.dart';
import '../../../../core/session/profile_session_sync.dart';
import '../../../../core/utils/auth_guard.dart';
import '../../../profile_setup/domain/use_cases/get_profile_setup_content_use_case.dart';
import '../../domain/services/home_ai_enabled_session.dart';
import '../../domain/services/promotional_banner_session.dart';
import '../../domain/use_cases/check_app_update_use_case.dart';
import '../../domain/use_cases/get_dashboard_services_use_case.dart';
import 'dashboard_services_state.dart';

class DashboardCubit extends Cubit<DashboardServicesState> {
  DashboardCubit({
    required this.getOurServicesUseCase,
    required this.promotionalBannerSession,
    required this.checkAppUpdateUseCase,
    required this.getProfileSetupContentUseCase,
    required this.appPref,
    HomeAiEnabledSession? homeAiEnabledSession,
    ProfileSessionSync? profileSessionSync,
  })  : _homeAiEnabledSession =
            homeAiEnabledSession ?? sl<HomeAiEnabledSession>(),
        _profileSessionSync = profileSessionSync ?? sl<ProfileSessionSync>(),
        super(const DashboardServicesState()) {
    loadOurServices();
    checkAppUpdate();
    syncPromotionalBannerFromSession();
    syncUserProfileFromApi();
  }

  final GetOurServicesUseCase getOurServicesUseCase;
  final PromotionalBannerSession promotionalBannerSession;
  final CheckAppUpdateUseCase checkAppUpdateUseCase;
  final GetProfileSetupContentUseCase getProfileSetupContentUseCase;
  final AppPref appPref;
  final HomeAiEnabledSession _homeAiEnabledSession;
  final ProfileSessionSync _profileSessionSync;

  void _safeEmit(DashboardServicesState newState) {
    if (isClosed) return;
    emit(newState);
  }

  Future<void> loadOurServices() async {
    _safeEmit(
      state.copyWith(
        ourServicesLoadingStateStatus: StateStatus.loading,
        servicesErrorMessage: null,
      ),
    );

    final result = await getOurServicesUseCase.call();
    if (isClosed) return;
    result.fold(
      (error) => _safeEmit(
        state.copyWith(
          ourServicesLoadingStateStatus: StateStatus.error,
          servicesErrorMessage: error,
        ),
      ),
      (data) {
        _homeAiEnabledSession.update(
          aiEnabled: data.aiEnabled,
          aiPrescriptionEnabled: data.aiPrescriptionEnabled,
        );
        _safeEmit(
          state.copyWith(
            ourServicesLoadingStateStatus: data.services.isEmpty
                ? StateStatus.empty
                : StateStatus.success,
            servicesList: data.services.where((e) => e.visibility).toList(),
            servicesErrorMessage: null,
            proBannerUrl: data.bannerUrl,
            aiEnabled: data.aiEnabled,
            aiPrescriptionEnabled: data.aiPrescriptionEnabled,
          ),
        );
      },
    );
  }

  /// Pull-to-refresh: services + profile (when logged in).
  Future<void> refreshHome() async {
    await Future.wait([
      loadOurServices(),
      syncUserProfileFromApi(),
    ]);
  }

  /// Hits CMS app-version on every dashboard open and emits an update prompt when needed.
  Future<void> checkAppUpdate() async {
    _safeEmit(
      state.copyWith(
        appVersionLoadingStateStatus: StateStatus.loading,
        appUpdatePrompt: null,
      ),
    );

    final result = await checkAppUpdateUseCase.call();
    if (isClosed) return;
    result.fold(
      (_) => _safeEmit(
        state.copyWith(
          appVersionLoadingStateStatus: StateStatus.error,
          appUpdatePrompt: null,
        ),
      ),
      (prompt) => _safeEmit(
        state.copyWith(
          appVersionLoadingStateStatus: prompt == null
              ? StateStatus.empty
              : StateStatus.success,
          appUpdatePrompt: prompt,
        ),
      ),
    );
  }

  Future<void> syncPromotionalBannerFromSession() async {
    final session = promotionalBannerSession;
    _safeEmit(
      state.copyWith(
        promotionalBannerLoadingStateStatus: StateStatus.loading,
        promotionalBannerErrorMessage: null,
      ),
    );

    await session.ensureLoaded();
    if (isClosed) return;

    _safeEmit(
      state.copyWith(
        promotionalBannerLoadingStateStatus: session.loadingStateStatus,
        promotionalBanner: session.nextBanner,
        promotionalBannerErrorMessage: session.errorMessage,
      ),
    );
  }

  /// Fetches user profile (GET …/users/{id}) and persists via [ProfileSetupRepository]; bumps [profileSyncNonce] on success so UI refreshes.
  Future<void> syncUserProfileFromApi() async {
    if (!AuthGuard.isLoggedIn(appPref)) return;
    if (_profileSessionSync.shouldSkipNetworkFetch(appPref)) {
      _safeEmit(
        state.copyWith(profileSyncNonce: state.profileSyncNonce + 1),
      );
      return;
    }

    final result = await getProfileSetupContentUseCase.call();
    if (isClosed) return;
    result.fold(
      (_) {},
      (_) {
        sl<AuthSessionRefresh>().notifyProfileUpdated();
        _safeEmit(
          state.copyWith(profileSyncNonce: state.profileSyncNonce + 1),
        );
      },
    );
  }
}
