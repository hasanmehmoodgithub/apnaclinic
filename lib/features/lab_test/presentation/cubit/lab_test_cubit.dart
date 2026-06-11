import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/enums/state_status.dart';
import '../../domain/entities/lab_test_item_entity.dart';
import '../../domain/use_cases/get_lab_test_catalog_use_case.dart';
import 'lab_test_state.dart';

class LabTestCubit extends Cubit<LabTestState> {
  LabTestCubit({required this.getLabTestCatalogUseCase})
    : super(const LabTestState()) {
    loadCities();
  }

  final GetLabTestCatalogUseCase getLabTestCatalogUseCase;
  Timer? _searchDebounce;

  @override
  Future<void> close() {
    _searchDebounce?.cancel();
    return super.close();
  }

  Future<void> loadCities() async {
    emit(
      state.copyWith(
        catalogLoadingStateStatus: StateStatus.loading,
        clearErrorMessage: true,
      ),
    );

    final result = await getLabTestCatalogUseCase(
      const GetLabTestCatalogParams.citiesOnly(),
    );
    if (isClosed) return;

    result.fold(
      (error) => emit(
        state.copyWith(
          catalogLoadingStateStatus: StateStatus.error,
          errorMessage: error,
        ),
      ),
      (catalog) => emit(
        state.copyWith(
          catalogLoadingStateStatus: StateStatus.idle,
          cities: catalog.cities,
          requirementLines: catalog.requirementLines,
          partners: catalog.partners,
          clearErrorMessage: true,
        ),
      ),
    );
  }

  Future<void> loadCatalog({
    required String cityName,
    bool refresh = false,
    String? search,
  }) async {
    emit(
      state.copyWith(
        catalogLoadingStateStatus: refresh
            ? StateStatus.refreshing
            : StateStatus.loading,
        clearErrorMessage: true,
      ),
    );

    final result = await getLabTestCatalogUseCase(
      GetLabTestCatalogParams.forCity(
        cityName: cityName,
        search: search,
      ),
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
            filteredItems: items,
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
    emit(state.copyWith(searchQuery: value));
    _searchDebounce?.cancel();

    final city = state.selectedCity;
    if (city == null || city.isEmpty) {
      emit(
        state.copyWith(
          filteredItems: _filter(state.items, value),
        ),
      );
      return;
    }

    _searchDebounce = Timer(const Duration(milliseconds: 400), () {
      loadCatalog(cityName: city, search: value.trim());
    });
  }

  Future<void> selectCity(String city) async {
    if (city.isEmpty) return;

    final shouldReload =
        state.selectedCity != city ||
        state.items.isEmpty ||
        state.catalogLoadingStateStatus == StateStatus.idle;

    emit(state.copyWith(selectedCity: city, clearErrorMessage: true));

    if (shouldReload) {
      await loadCatalog(
        cityName: city,
        search: state.searchQuery.trim().isEmpty
            ? null
            : state.searchQuery.trim(),
      );
    }
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
