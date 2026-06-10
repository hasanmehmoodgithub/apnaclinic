# Consultation feature

## Purpose

Doctor consultation category browse, doctor results, booking, and checkout.

## Routes / entry

- `AppRoutes.consultation` — category grid (`DoctorConsultationScreen`); tiles use surgery `Assets.iconsD1` / `Assets.iconsD2` background vectors on `ConsultationUiConfig.cardBackground`.
- `AppRoutes.consultationDoctors` — doctor results; extra: `category` (title), `mainCategoryId`. Book Now requires login (`AppPref.getLoginStatus()`); guests go to `AppRoutes.authLogin`.
- `AppRoutes.consultationBookDoctor` — booking screen; extra: `DoctorConsultationBookDoctorArgs` (`ResultsDoctorItem` from results list).

## Data & APIs

- **GET** `AppUrls.doctorCategories` — `https://apnaclinic-aggregator.apps.jpocp.jazz.com.pk/api/v1/mobile/doctor-categories` (override `AGGREGATOR_BASE_URL`).
  - Response `data[]`: `id`, `title`, `displayLabel`, `iconPath`, `displayOrder`, `isActive`.
  - Maps to `ConsultationCategoryEntity`; inactive entries filtered; sorted by `displayOrder`.
- **GET** `AppUrls.doctorConsultationDoctors(mainCategoryId)` — `/api/v1/mobile/doctor-consultation/doctors?mainCategoryId=`.
  - Response `data.data[]`: `id`, `publicId`, `displayName`, `specialtyName`, `yearsOfExperience`, `profileImageUrl`, `consultationFee`, `discountPercent`, `isFree`, `ratingScore` (string or number), `bio`, `education`, `qualifications`, `partner`.
  - Maps to `ResultsDoctorItem` via `ConsultationDoctorModel` (`bio` → description, `education` when `qualifications` is empty, `partner.logoUrl` for logo; partner name only if API sends `partner.name` / `displayName`).
- `HeaderInterceptor` adds `x-api-key` and `x-tenant-id` (when logged in) on aggregator host.

## State

- `ConsultationCubit` — loads categories via `GetConsultationCategoriesUseCase`.
- `DoctorConsultationResultsScreen` — loads doctors via `GetConsultationDoctorsUseCase` using `mainCategoryId`.

## DI

- `consultation_injection.dart` — `ConsultationRemoteDataSourceImpl`, repository, `GetConsultationCategoriesUseCase`, `GetConsultationDoctorsUseCase`, cubit.

## Mocks

- `ConsultationCategoriesMockApi` / `ConsultationDoctorsMockApi` — when `MockConfig.enableConsultationMocks` is true (default false).
- Book-doctor screen displays the same `ResultsDoctorItem` passed from results (no separate detail fetch).
