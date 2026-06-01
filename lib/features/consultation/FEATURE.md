# Consultation feature

## Purpose

Doctor consultation category browse, doctor results, booking, and checkout.

## Data & APIs

- **GET** `AppUrls.doctorCategories` — `https://apnaclinic-aggregator.apps.jpocp.jazz.com.pk/api/v1/mobile/doctor-categories` (override `AGGREGATOR_BASE_URL`).
- Response `data[]`: `id`, `title`, `displayLabel`, `iconPath`, `displayOrder`, `isActive`.
- Maps to `ConsultationCategoryEntity`; inactive entries filtered; sorted by `displayOrder`.
- `HeaderInterceptor` adds `x-tenant-id` on aggregator host when logged in (same as CMS).

## State

- `ConsultationCubit` — loads categories via `GetConsultationCategoriesUseCase`.

## DI

- `consultation_injection.dart` — `ConsultationRemoteDataSourceImpl`, repository, cubit.

## Mocks

- `ConsultationCategoriesMockApi` — when `MockConfig.enableConsultationMocks` is true (default false).
