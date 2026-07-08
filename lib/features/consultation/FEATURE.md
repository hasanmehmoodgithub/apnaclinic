# Consultation feature

## Purpose

Doctor consultation category browse, doctor results, booking, and checkout.

## Routes / entry

- `AppRoutes.consultation` — category grid (`DoctorConsultationScreen`); tiles use surgery `Assets.iconsD1` / `Assets.iconsD2` background vectors on `ConsultationUiConfig.cardBackground`.
- `AppRoutes.consultationDoctors` — doctor results; extra: `DoctorConsultationResultsArgs` (`selectedCategory`, `mainCategoryId`, preloaded `categoryOptions` from category grid — avoids duplicate categories API call). Book Now requires login (`AppPref.getLoginStatus()`); guests go to `AppRoutes.authLogin`.
- `AppRoutes.consultationCheckout` — payment screen; extra: `DoctorConsultationCheckoutArgs` (doctor, issue, selected slot, attachments). Submits booking via `POST` `AppUrls.doctorConsultationBooking` (`multipart/form-data`).

## Data & APIs

- **GET** `AppUrls.doctorCategories` — `https://apnaclinic-aggregator.apps.jpocp.jazz.com.pk/api/v1/mobile/doctor-categories` (override `AGGREGATOR_BASE_URL`).
  - Response `data[]`: `id`, `title`, `displayLabel`, `iconPath`, `displayOrder`, `isActive`.
  - Maps to `ConsultationCategoryEntity`; inactive entries filtered; sorted by `displayOrder`.
- **GET** `AppUrls.doctorConsultationDoctors(mainCategoryId)` — `/api/v1/mobile/doctor-consultation/doctors?mainCategoryId=`.
  - Response `data.data[]`: `id`, `publicId`, `displayName`, `specialtyName`, `yearsOfExperience`, `profileImageUrl`, `consultationFee`, `discountPercent`, `isFree`, `ratingScore` (string or number), `bio`, `education`, `qualifications`, `partner`.
  - Maps to `ResultsDoctorItem` via `ConsultationDoctorModel` (`bio` → description, `education` when `qualifications` is empty, `partner.logoUrl` for logo; partner name only if API sends `partner.name` / `displayName`). `apiDoctorId` keeps numeric `id` for slots API.
- **GET** `AppUrls.paymentProviders` — `/api/v1/mobile/payment-provider` (active providers with `name`, `code`, `iconUrl`).
- **POST** `AppUrls.doctorConsultationBooking` — `/api/v1/mobile/doctor-consultation/booking` (`multipart/form-data`).
  - Fields: `doctorId`, `tenantId`, `consultationFee`, `patientId`, `patientRelation`, `slotDate`, `slotStartTime`, `slotEndTime`, `paymentMethod` (e.g. `JAZZCASH`), `msisdn`, `attachments[]` (files).
  - `tenantId` from doctor `partner.tenantId` (not JWT); `patientId` from JWT/`AppPref`; JazzCash `msisdn` from selected saved account (profile phones via `GetAccountsListUseCase`; default/`isDefault` pre-selected in JazzCash sheet); slot values from selected availability chip.
- **GET** `AppUrls.doctorConsultationSlots(doctorId, hospitalId?)` — `/api/v1/mobile/doctor-consultation/slots/{doctorId}` (optional `?hospitalId=` when doctors list provides it).
  - Response `data[]`: `date`, `slots[]` with `start_time`, `end_time`.
  - Uses `ResultsDoctorItem.partnerDoctorId` when present, else numeric `apiDoctorId` (`id` from doctors list).
  - Upstream errors like “Doctor hospital not found” are mapped to a user-friendly availability message.
- `HeaderInterceptor` adds `x-api-key` and `x-tenant-id` (when logged in) on aggregator host.

## State

- `ConsultationCubit` — loads categories via `GetConsultationCategoriesUseCase`.
- `DoctorConsultationResultsScreen` — loads doctors via `GetConsultationDoctorsUseCase` using `mainCategoryId`.
- `DoctorConsultationBookDoctorScreen` — loads slots via `GetConsultationDoctorSlotsUseCase` using `ResultsDoctorItem.apiDoctorId`. Documents section supports multiple attachments (gallery/file multi-select; camera appends) with per-item delete.
- `DoctorConsultationCheckoutCubit` — loads payment providers via `GetPaymentProvidersUseCase`; submits booking via `SubmitConsultationBookingUseCase`.

## DI

- `consultation_injection.dart` — `ConsultationRemoteDataSourceImpl`, repository, category/doctor/slots/payment-provider/booking use cases, `DoctorConsultationCheckoutCubit`, cubit.

## Mocks

- `ConsultationCategoriesMockApi` / `ConsultationDoctorsMockApi` / `ConsultationDoctorSlotsMockApi` / `ConsultationBookingMockApi` / `PaymentProvidersMockApi` — when `MockConfig.enableConsultationMocks` is true (default false).
- Book-doctor screen displays the same `ResultsDoctorItem` passed from results (no separate detail fetch).
