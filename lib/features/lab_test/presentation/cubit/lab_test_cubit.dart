import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/cities/domain/repositories/cities_repository.dart';
import '../../../../core/enums/state_status.dart';
import '../../../../core/preference/app_pref.dart';
import '../../../../core/preference/app_pref_keys.dart';
import '../../domain/entities/lab_test_item_entity.dart';
import '../../domain/use_cases/get_lab_test_catalog_use_case.dart';
import 'lab_test_state.dart';

class LabTestCubit extends Cubit<LabTestState> {
  LabTestCubit({
    required this.getLabTestCatalogUseCase,
    required this.appPref,
    required this.citiesRepository,
  }) : super(const LabTestState()) {
    bootstrap();
  }

  final GetLabTestCatalogUseCase getLabTestCatalogUseCase;
  final AppPref appPref;
  final CitiesRepository citiesRepository;

  /// Loads cities, restores saved city from prefs, then calls lab tests API.
  Future<void> bootstrap() async {
    final savedRaw = appPref.getString(AppPrefKeys.labTestSelectedCity)?.trim();

    emit(
      state.copyWith(
        catalogLoadingStateStatus: StateStatus.loading,
        clearErrorMessage: true,
      ),
    );

    final citiesResult = await getLabTestCatalogUseCase(
      const GetLabTestCatalogParams.citiesOnly(),
    );
    if (isClosed) return;

    await citiesResult.fold(
      (error) async {
        emit(
          state.copyWith(
            catalogLoadingStateStatus: StateStatus.error,
            errorMessage: error,
          ),
        );
      },
      (catalog) async {
        final cities = catalog.cities;
        final resolvedCity = _resolveCityName(savedRaw);

        emit(
          state.copyWith(
            cities: cities,
            requirementLines: catalog.requirementLines,
            partners: catalog.partners,
            clearErrorMessage: true,
          ),
        );

        if (resolvedCity != null) {
          emit(state.copyWith(selectedCity: resolvedCity));
          await loadCatalog(cityName: resolvedCity);
          return;
        }

        emit(
          state.copyWith(
            catalogLoadingStateStatus: StateStatus.idle,
            clearSelectedCity: true,
          ),
        );
      },
    );
  }

  Future<void> loadCatalog({
    required String cityName,
    bool refresh = false,
    String? search,
  }) async {
    final resolvedCity = _resolveCityName(cityName) ?? cityName.trim();
    if (resolvedCity.isEmpty) return;

    emit(
      state.copyWith(
        catalogLoadingStateStatus: refresh
            ? StateStatus.refreshing
            : StateStatus.loading,
        selectedCity: resolvedCity,
        clearErrorMessage: true,
      ),
    );

    final result = await getLabTestCatalogUseCase(
      GetLabTestCatalogParams.forCity(
        cityName: resolvedCity,
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

  /// Runs catalog search when the user taps the search button (or submits).
  Future<void> submitSearch(String value) async {
    final query = value.trim();
    emit(state.copyWith(searchQuery: query));

    final city = state.selectedCity;
    if (city == null || city.isEmpty) {
      emit(
        state.copyWith(
          filteredItems: _filter(state.items, query),
        ),
      );
      return;
    }

    await loadCatalog(
      cityName: city,
      search: query.isEmpty ? null : query,
    );
  }

  Future<void> selectCity(String city) async {
    if (city.isEmpty) return;

    final resolvedCity = _resolveCityName(city) ?? city.trim();
    await appPref.setString(AppPrefKeys.labTestSelectedCity, resolvedCity);

    await loadCatalog(
      cityName: resolvedCity,
      search: state.searchQuery.trim().isEmpty
          ? null
          : state.searchQuery.trim(),
    );
  }

  bool isCityInList(String city) => _resolveCityName(city) != null;

  String? _resolveCityName(String? raw) {
    if (raw == null || raw.trim().isEmpty) return null;

    final trimmed = raw.trim();
    if (citiesRepository.cityIdForName(trimmed) == null) return null;

    final normalized = trimmed.toLowerCase();
    for (final name in citiesRepository.cityNames) {
      if (name.trim().toLowerCase() == normalized) {
        return name;
      }
    }

    return trimmed;
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
