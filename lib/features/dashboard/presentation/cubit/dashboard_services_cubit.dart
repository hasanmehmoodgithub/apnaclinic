import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/enums/state_status.dart';
import '../../domain/use_cases/promotional_banner_use_case.dart';
import '../../domain/use_cases/get_dashboard_services_use_case.dart';
import 'dashboard_services_state.dart';

class DashboardCubit extends Cubit<DashboardServicesState> {
  DashboardCubit({
    required this.getOurServicesUseCase,
    required this.getPromotionalBannerUseCase,
  })
      : super(const DashboardServicesState()) {
    loadOurServices();
    loadPromotionalBanner();
  }

  final GetOurServicesUseCase getOurServicesUseCase;
  final GetPromotionalBannerUseCase getPromotionalBannerUseCase;

  Future<void> loadOurServices() async {
    emit(
      state.copyWith(
        ourServicesLoadingStateStatus: StateStatus.loading,
        servicesErrorMessage: null,
      ),
    );

    final result = await getOurServicesUseCase.call();
    result.fold(
      (error) => emit(
        state.copyWith(
          ourServicesLoadingStateStatus: StateStatus.error,
          servicesErrorMessage: error,
        ),
      ),
      (data) => emit(
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
    emit(
      state.copyWith(
        promotionalBannerLoadingStateStatus: StateStatus.loading,
        promotionalBannerErrorMessage: null,
      ),
    );

    final result = await getPromotionalBannerUseCase.call();
    result.fold(
      (error) => emit(
        state.copyWith(
          promotionalBannerLoadingStateStatus: StateStatus.error,
          promotionalBannerErrorMessage: error,
        ),
      ),
      (banner) => emit(
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
}

