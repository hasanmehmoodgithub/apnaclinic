import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/enums/state_status.dart';
import '../../domain/use_cases/get_pro_catalog_use_case.dart';
import 'pro_state.dart';

class ProCubit extends Cubit<ProState> {
  ProCubit({required this.getCatalogUseCase}) : super(const ProState());

  final GetProCatalogUseCase getCatalogUseCase;

  Future<void> loadCatalog({bool refresh = false}) async {
    emit(
      state.copyWith(
        loadingStateStatus:
            refresh ? StateStatus.refreshing : StateStatus.loading,
        errorMessage: null,
      ),
    );

    final result = await getCatalogUseCase();
    if (isClosed) return;
    result.fold(
      (error) {
        emit(
          state.copyWith(
            loadingStateStatus: StateStatus.error,
            errorMessage: error,
          ),
        );
      },
      (catalog) {
        final selected = state.selectedPlanId ?? catalog.defaultSelectedPlanId;
        emit(
          state.copyWith(
            loadingStateStatus: StateStatus.success,
            catalog: catalog,
            selectedPlanId: selected,
            errorMessage: null,
          ),
        );
      },
    );
  }

  void selectPlan(String planId) {
    if (planId == state.selectedPlanId) return;
    emit(state.copyWith(selectedPlanId: planId));
  }
}
