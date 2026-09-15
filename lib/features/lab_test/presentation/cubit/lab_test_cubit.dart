import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/cities/domain/repositories/cities_repository.dart';
import '../../../../core/enums/state_status.dart';
import '../../../../core/preference/app_pref.dart';
import '../../../../core/preference/app_pref_keys.dart';
import '../../domain/entities/lab_test_item_entity.dart';
import '../../domain/entities/lab_test_vendor_entity.dart';
import '../../domain/use_cases/get_lab_test_catalog_use_case.dart';
import '../../domain/use_cases/get_labs_use_case.dart';
import '../lab_test_analytics.dart';
import '../lab_test_route_args.dart';
import 'lab_test_state.dart';

class LabTestCubit extends Cubit<LabTestState> {
  LabTestCubit({
    required this.getLabTestCatalogUseCase,
    required this.getLabsUseCase,
    required this.appPref,
    required this.citiesRepository,
    this.autoBootstrap = true,
  }) : super(const LabTestState()) {
    if (autoBootstrap) bootstrap();
  }

  static const int _pageSize = 20;

  final GetLabTestCatalogUseCase getLabTestCatalogUseCase;
  final GetLabsUseCase getLabsUseCase;
  final AppPref appPref;
  final CitiesRepository citiesRepository;
  final bool autoBootstrap;

  /// Set by [submitSearch] so city/browse loads do not fire search analytics.
  bool _pendingSearchPerformedLog = false;

  /// Loads cities, restores saved city from prefs, then loads labs for that city.
  Future<void> bootstrap() async {
    final savedRaw = appPref.getString(AppPrefKeys.labTestSelectedCity)?.trim();

    emit(
      state.copyWith(
        labsLoadingStateStatus: StateStatus.loading,
        catalogLoadingStateStatus: StateStatus.idle,
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
            labsLoadingStateStatus: StateStatus.error,
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
          await loadLabs(cityName: resolvedCity);
          return;
        }

        emit(
          state.copyWith(
            labsLoadingStateStatus: StateStatus.idle,
            clearSelectedCity: true,
            clearSelectedLab: true,
          ),
        );
      },
    );
  }

  Future<void> startSelectTest(LabTestSelectTestArgs args) async {
    emit(
      state.copyWith(
        selectedCity: args.city,
        selectedLab: args.lab,
        requirementLines: args.requirementLines,
        searchQuery: '',
        clearErrorMessage: true,
      ),
    );
    await loadCatalog(cityName: args.city, lab: args.lab);
  }

  Future<void> loadLabs({required String cityName}) async {
    final resolvedCity = _resolveCityName(cityName) ?? cityName.trim();
    if (resolvedCity.isEmpty) return;

    emit(
      state.copyWith(
        labsLoadingStateStatus: StateStatus.loading,
        selectedCity: resolvedCity,
        labs: const [],
        clearSelectedLab: true,
        items: const [],
        filteredItems: const [],
        catalogLoadingStateStatus: StateStatus.idle,
        clearErrorMessage: true,
      ),
    );

    final result = await getLabsUseCase(GetLabsParams(cityName: resolvedCity));
    if (isClosed) return;

    result.fold(
      (error) => emit(
        state.copyWith(
          labsLoadingStateStatus: StateStatus.error,
          errorMessage: error,
        ),
      ),
      (labs) => emit(
        state.copyWith(
          labsLoadingStateStatus:
              labs.isEmpty ? StateStatus.empty : StateStatus.success,
          labs: labs,
          clearErrorMessage: true,
        ),
      ),
    );
  }

  Future<void> loadCatalog({
    required String cityName,
    bool refresh = false,
    String? search,
    LabTestVendorEntity? lab,
  }) async {
    final resolvedCity = _resolveCityName(cityName) ?? cityName.trim();
    if (resolvedCity.isEmpty) {
      _pendingSearchPerformedLog = false;
      return;
    }

    final selectedLab = lab ?? state.selectedLab;
    emit(
      state.copyWith(
        catalogLoadingStateStatus: refresh
            ? StateStatus.refreshing
            : StateStatus.loading,
        selectedCity: resolvedCity,
        selectedLab: selectedLab,
        isLoadingMore: false,
        currentPage: 1,
        totalPages: 1,
        totalItems: 0,
        clearErrorMessage: true,
      ),
    );

    final result = await getLabTestCatalogUseCase(
      GetLabTestCatalogParams.forCity(
        cityName: resolvedCity,
        page: 1,
        limit: _pageSize,
        search: search,
        labId: selectedLab?.id,
      ),
    );
    if (isClosed) return;

    final shouldLogSearch = _pendingSearchPerformedLog;
    _pendingSearchPerformedLog = false;
    final keyword = (search ?? state.searchQuery).trim();

    result.fold(
      (error) {
        emit(
          state.copyWith(
            catalogLoadingStateStatus: StateStatus.error,
            errorMessage: error,
            isLoadingMore: false,
          ),
        );
        if (shouldLogSearch) {
          LabTestAnalytics.logSearchPerformed(
            keyword: keyword,
            resultItems: 0,
          );
        }
      },
      (catalog) {
        final items = catalog.items;
        emit(
          state.copyWith(
            catalogLoadingStateStatus: items.isEmpty
                ? StateStatus.empty
                : StateStatus.success,
            cities: catalog.cities.isEmpty ? state.cities : catalog.cities,
            items: items,
            filteredItems: items,
            requirementLines: catalog.requirementLines,
            partners: catalog.partners,
            vendors: catalog.vendors,
            pricing: catalog.pricing,
            currentPage: catalog.page,
            totalPages: catalog.totalPages,
            totalItems: catalog.total,
            isLoadingMore: false,
            clearErrorMessage: true,
          ),
        );
        if (shouldLogSearch) {
          LabTestAnalytics.logSearchPerformed(
            keyword: keyword,
            resultItems: catalog.total,
          );
        }
      },
    );
  }

  Future<void> loadMoreCatalog() async {
    if (state.isLoadingMore || !state.hasMoreItems) return;
    final city = state.selectedCity;
    if (city == null || city.isEmpty) return;
    if (state.catalogLoadingStateStatus != StateStatus.success &&
        state.catalogLoadingStateStatus != StateStatus.empty) {
      return;
    }

    emit(state.copyWith(isLoadingMore: true, clearErrorMessage: true));

    final nextPage = state.currentPage + 1;
    final result = await getLabTestCatalogUseCase(
      GetLabTestCatalogParams.forCity(
        cityName: city,
        page: nextPage,
        limit: _pageSize,
        search: state.searchQuery.trim().isEmpty
            ? null
            : state.searchQuery.trim(),
        labId: state.selectedLab?.id,
      ),
    );
    if (isClosed) return;

    result.fold(
      (error) => emit(
        state.copyWith(
          isLoadingMore: false,
          errorMessage: error,
        ),
      ),
      (catalog) {
        final mergedItems = _mergeItems(state.items, catalog.items);
        final mergedVendors = _mergeVendors(state.vendors, catalog.vendors);
        emit(
          state.copyWith(
            catalogLoadingStateStatus: mergedItems.isEmpty
                ? StateStatus.empty
                : StateStatus.success,
            items: mergedItems,
            filteredItems: mergedItems,
            vendors: mergedVendors,
            pricing: catalog.pricing ?? state.pricing,
            currentPage: catalog.page,
            totalPages: catalog.totalPages,
            totalItems: catalog.total,
            isLoadingMore: false,
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
    if (query.isNotEmpty) {
      _pendingSearchPerformedLog = true;
    }

    final city = state.selectedCity;
    if (city == null || city.isEmpty) {
      final filtered = _filter(state.items, query);
      emit(state.copyWith(filteredItems: filtered));
      if (_pendingSearchPerformedLog) {
        _pendingSearchPerformedLog = false;
        LabTestAnalytics.logSearchPerformed(
          keyword: query,
          resultItems: filtered.length,
        );
      }
      return;
    }

    await loadCatalog(
      cityName: city,
      search: query.isEmpty ? null : query,
      lab: state.selectedLab,
    );
  }

  Future<void> selectCity(String city) async {
    if (city.isEmpty) return;

    final resolvedCity = _resolveCityName(city) ?? city.trim();
    await appPref.setString(AppPrefKeys.labTestSelectedCity, resolvedCity);
    LabTestAnalytics.logCityChange(resolvedCity);

    await loadLabs(cityName: resolvedCity);
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

  static List<LabTestItemEntity> _mergeItems(
    List<LabTestItemEntity> existing,
    List<LabTestItemEntity> next,
  ) {
    if (next.isEmpty) return existing;
    final seen = <String>{for (final item in existing) item.id};
    final merged = List<LabTestItemEntity>.from(existing);
    for (final item in next) {
      if (seen.add(item.id)) {
        merged.add(item);
      }
    }
    return merged;
  }

  static List<LabTestVendorEntity> _mergeVendors(
    List<LabTestVendorEntity> existing,
    List<LabTestVendorEntity> next,
  ) {
    if (next.isEmpty) return existing;
    final byId = <String, LabTestVendorEntity>{
      for (final vendor in existing) vendor.id: vendor,
    };
    for (final vendor in next) {
      byId.putIfAbsent(vendor.id, () => vendor);
    }
    return byId.values.toList(growable: false);
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
