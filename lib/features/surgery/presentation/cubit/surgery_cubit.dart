import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/enums/state_status.dart';
import '../../domain/entities/surgery_procedure_entity.dart';
import '../../domain/use_cases/get_surgery_content_use_case.dart';
import 'surgery_state.dart';

class SurgeryCubit extends Cubit<SurgeryState> {
  SurgeryCubit({required this.getSurgeryContentUseCase})
      : super(const SurgeryState()) {
    loadSurgeryContent();
  }

  final GetSurgeryContentUseCase getSurgeryContentUseCase;

  Future<void> loadSurgeryContent({bool refresh = false}) async {
    emit(
      state.copyWith(
        loadingStateStatus: refresh ? StateStatus.refreshing : StateStatus.loading,
        errorMessage: null,
      ),
    );

    final result = await getSurgeryContentUseCase(const GetSurgeryContentParams());
    if (isClosed) return;

    result.fold(
      (error) => emit(
        state.copyWith(
          loadingStateStatus: StateStatus.error,
          errorMessage: error,
        ),
      ),
      (content) => emit(
        state.copyWith(
          loadingStateStatus: StateStatus.success,
          content: content,
          selectedCity: content.defaultCity,
          errorMessage: null,
        ),
      ),
    );
  }

  void changeCity(String city) {
    emit(state.copyWith(selectedCity: city));
  }

  void updateSearchQuery(String query) {
    emit(state.copyWith(searchQuery: query));
  }

  void toggleProcedure(String id) {
    final selected = {...state.selectedProcedureIds};
    if (selected.contains(id)) {
      selected.remove(id);
    } else {
      selected.add(id);
    }
    emit(state.copyWith(selectedProcedureIds: selected));
  }

  List<SurgeryProcedureEntity> get filteredProcedures {
    final query = state.searchQuery.trim().toLowerCase();
    if (query.isEmpty) return state.content.procedures;
    return state.content.procedures
        .where((item) => item.name.toLowerCase().contains(query))
        .toList();
  }
}
