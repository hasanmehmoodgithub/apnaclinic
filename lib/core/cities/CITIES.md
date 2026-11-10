# Cities (shared)

## Purpose

Shared city catalog and **Select City** dialog used by Lab, Surgery, Pharmacy checkout display helpers, and any future module.

## API & cache

- **GET** `AppUrls.cities` → `/acs-aggregator/api/v1/mobile/cities`
- `CitiesRepository.loadCities()` fetches once per app session and caches in memory (concurrent calls deduped). Failure falls back to a hard-coded name list.
- Resolve aggregator id: `cityIdForName(name)`.

## Pharmacy partner cities (do not use this list)

Pharmacy multi-partner routing uses **`AppUrls.pharmacyCities`** (`GET …/mobile/partner/pharmacy/cities`) via `GetPharmacyCitiesUseCase` — only cities with a pharmacy partner. See `lib/features/pharmacy/FEATURE.md`.

## Select City UI

- Entry: `showSelectCityDialog(context, { cities?, cityEntities?, initialSelectedCity?, title?, searchHint?, barrierDismissible? })` → `Future<SelectedCityResult?>` (`id` + `name`, or `null` if dismissed).
- UI: Lab-style centered dialog with search, radio list, loading / empty / no-results states (`lib/core/cities/presentation/`).
- When `cities` / `cityEntities` are omitted or empty, the dialog loads from `CitiesRepository` (uses cache when already loaded).
- `barrierDismissible` defaults to `true`; when `false`, close button is hidden and system back does not dismiss.

## Call sites

| Module | How |
|--------|-----|
| Lab | `LabTestScreen` → `showSelectCityDialog` → `LabTestCubit.selectCity` (uses `.name`) |
| Surgery | `openSurgeryCityPicker` → dialog → `SurgeryCubit.changeCity` (uses `.name`) |
| Pharmacy hub | Dedicated `showPharmacyCitySelectDialog` / `openPharmacyCityPicker` (partner cities API) |
| Pharmacy checkout | City field locked to stored pharmacy city (not the general cities list) |

## DI

- `cities_injection.dart` — `CitiesRemoteDataSource`, `CitiesRepository` (lazy singletons).
