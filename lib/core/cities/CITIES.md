# Cities (shared)

## Purpose

Shared city catalog and **Select City** dialog used by Lab, Surgery, Pharmacy, and any future module.

## API & cache

- **GET** `AppUrls.cities` → `/acs-aggregator/api/v1/mobile/cities`
- `CitiesRepository.loadCities()` fetches once per app session and caches in memory (concurrent calls deduped). Failure falls back to a hard-coded name list.
- Resolve aggregator id: `cityIdForName(name)`.

## Select City UI

- Entry: `showSelectCityDialog(context, { cities?, initialSelectedCity?, title?, searchHint? })` → `Future<String?>` (city name, or `null` if dismissed).
- UI: Lab-style centered dialog with search, radio list, loading / empty / no-results states (`lib/core/cities/presentation/`).
- When `cities` is omitted or empty, the dialog loads from `CitiesRepository` (uses cache when already loaded).

## Call sites

| Module | How |
|--------|-----|
| Lab | `LabTestScreen` → `showSelectCityDialog` → `LabTestCubit.selectCity` |
| Surgery | `openSurgeryCityPicker` → dialog → `SurgeryCubit.changeCity` |
| Pharmacy | Checkout city field → dialog → `PharmacyCubit.selectCheckoutCity` |

## DI

- `cities_injection.dart` — `CitiesRemoteDataSource`, `CitiesRepository` (lazy singletons).
