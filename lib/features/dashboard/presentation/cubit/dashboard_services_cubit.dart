import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/enums/state_status.dart';
import '../../domain/use_cases/get_dashboard_services_use_case.dart';
import 'dashboard_services_state.dart';

class DashboardServicesCubit extends Cubit<DashboardServicesState> {
  DashboardServicesCubit({required this.getDashboardServicesUseCase})
      : super(const DashboardServicesState()) {
    loadServices();
  }

  final GetOurServicesUseCase getDashboardServicesUseCase;

  Future<void> loadServices() async {
    emit(
      state.copyWith(
        ourServicesLoadingStateStatus: StateStatus.loading,
        servicesErrorMessage: null,
      ),
    );

    final result = await getDashboardServicesUseCase.call();
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
}

