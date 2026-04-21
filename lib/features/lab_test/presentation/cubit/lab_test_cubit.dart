import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/enums/state_status.dart';
import '../../domain/entities/lab_test_item_entity.dart';
import '../../domain/use_cases/get_lab_test_catalog_use_case.dart';
import 'lab_test_state.dart';

class LabTestCubit extends Cubit<LabTestState> {
  LabTestCubit({required this.getLabTestCatalogUseCase})
    : super(const LabTestState()) {
    loadCatalog();
  }

  final GetLabTestCatalogUseCase getLabTestCatalogUseCase;

  Future<void> loadCatalog({bool refresh = false}) async {
    emit(
      state.copyWith(
        catalogLoadingStateStatus: refresh
            ? StateStatus.refreshing
            : StateStatus.loading,
        clearErrorMessage: true,
      ),
    );

    final result = await getLabTestCatalogUseCase(
      const GetLabTestCatalogParams(),
    );
    if (isClosed) return;

    result.fold(
      (error) => emit(
        state.copyWith(
          catalogLoadingStateStatus: StateStatus.error,
          errorMessage: error,
        ),
      ),
      (catalog) {
        final items = catalog.items;
        emit(
          state.copyWith(
            catalogLoadingStateStatus: items.isEmpty
                ? StateStatus.empty
                : StateStatus.success,
            cities: catalog.cities,
            items: items,
            filteredItems: _filter(items, state.searchQuery),
            requirementLines: catalog.requirementLines,
            partners: catalog.partners,
            vendors: catalog.vendors,
            pricing: catalog.pricing,
            clearErrorMessage: true,
          ),
        );
      },
    );
  }

  void onSearchChanged(String value) {
    final normalized = value.trim();
    emit(
      state.copyWith(
        searchQuery: value,
        filteredItems: _filter(state.items, normalized),
      ),
    );
  }

  void selectCity(String city) {
    if (city.isEmpty) return;
    emit(state.copyWith(selectedCity: city));
  }

  static List<LabTestItemEntity> _filter(
    List<LabTestItemEntity> source,
    String query,
  ) {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return source;
    return source
        .where((item) => item.title.toLowerCase().contains(q))
        .toList();
  }
}
