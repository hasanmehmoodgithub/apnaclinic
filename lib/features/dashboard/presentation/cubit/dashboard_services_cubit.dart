import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/enums/state_status.dart';
import '../../../../core/preference/app_pref.dart';
import '../../../profile_setup/domain/use_cases/get_profile_setup_content_use_case.dart';
import '../../domain/use_cases/promotional_banner_use_case.dart';
import '../../domain/use_cases/get_dashboard_services_use_case.dart';
import 'dashboard_services_state.dart';

class DashboardCubit extends Cubit<DashboardServicesState> {
  DashboardCubit({
    required this.getOurServicesUseCase,
    required this.getPromotionalBannerUseCase,
    required this.getProfileSetupContentUseCase,
    required this.appPref,
  }) : super(const DashboardServicesState()) {
    loadOurServices();
    loadPromotionalBanner();
    syncUserProfileFromApi();
  }

  final GetOurServicesUseCase getOurServicesUseCase;
  final GetPromotionalBannerUseCase getPromotionalBannerUseCase;
  final GetProfileSetupContentUseCase getProfileSetupContentUseCase;
  final AppPref appPref;

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
      (data) => _safeEmit(
        state.copyWith(
          ourServicesLoadingStateStatus: data.isEmpty
              ? StateStatus.empty
              : StateStatus.success,
          servicesList: data.where((e) => e.visibility).toList(),
          servicesErrorMessage: null,
        ),
      ),
    );
  }

  Future<void> loadPromotionalBanner() async {
    _safeEmit(
      state.copyWith(
        promotionalBannerLoadingStateStatus: StateStatus.loading,
        promotionalBannerErrorMessage: null,
      ),
    );

    final result = await getPromotionalBannerUseCase.call();
    if (isClosed) return;
    result.fold(
      (error) => _safeEmit(
        state.copyWith(
          promotionalBannerLoadingStateStatus: StateStatus.error,
          promotionalBannerErrorMessage: error,
        ),
      ),
      (banner) => _safeEmit(
        state.copyWith(
          promotionalBannerLoadingStateStatus: banner.showBanner
              ? StateStatus.success
              : StateStatus.empty,
          promotionalBanner: banner,
          promotionalBannerErrorMessage: null,
        ),
      ),
    );
  }

  /// Fetches user profile (GET …/users/{id}) and persists via [ProfileSetupRepository]; bumps [profileSyncNonce] on success so UI refreshes.
  Future<void> syncUserProfileFromApi() async {
    if (!appPref.getLoginStatus()) return;
    final result = await getProfileSetupContentUseCase.call();
    if (isClosed) return;
    result.fold(
      (_) {},
      (_) {
        _safeEmit(
          state.copyWith(profileSyncNonce: state.profileSyncNonce + 1),
        );
      },
    );
  }
}
