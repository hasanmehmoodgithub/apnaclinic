# Consultation feature

## Purpose

Doctor consultation category browse, doctor results, booking, and checkout.

## Routes / entry

- `AppRoutes.consultation` — category grid (`DoctorConsultationScreen`); tiles use surgery `Assets.iconsD1` / `Assets.iconsD2` background vectors on `ConsultationUiConfig.cardBackground`.
- `AppRoutes.consultationDoctors` — doctor results; extra: `DoctorConsultationResultsArgs` (`selectedCategory`, `mainCategoryId`, preloaded `categoryOptions` from category grid — avoids duplicate categories API call). Book Now requires login (`AppPref.getLoginStatus()`); guests go to `AppRoutes.authLogin`.
- `AppRoutes.consultationCheckout` — payment screen; extra: `DoctorConsultationCheckoutArgs` (doctor, issue, selected slot, attachments). Submits booking via `POST` `AppUrls.doctorConsultationBooking` (`multipart/form-data`).
- `AppRoutes.consultationSummary` — booking summary after JazzCash account selection; extra: `DoctorConsultationSummaryArgs`. Proceed submits booking; Cancel returns to checkout.

## Data & APIs

- **GET** `AppUrls.doctorCategories` — `https://apnaclinic-aggregator.apps.jpocp.jazz.com.pk/api/v1/mobile/doctor-categories` (override `AGGREGATOR_BASE_URL`).
  - Response `data[]`: `id`, `title`, `displayLabel`, `iconPath`, `displayOrder`, `isActive`.
  - Maps to `ConsultationCategoryEntity`; inactive entries filtered; sorted by `displayOrder`.
- **GET** `AppUrls.doctorConsultationDoctors(mainCategoryId, partnerId?, search?, page, limit)` — `/api/v1/mobile/doctor-consultation/doctors?mainCategoryId=&partnerId=&search=&page=&limit=`.
  - Response `data.data[]`: `id`, `publicId`, `displayName`, `specialtyName`, `yearsOfExperience`, `profileImageUrl`, `consultationFee`, `discountPercent`, `isFree`, `ratingScore` (string or number), `bio`, `education`, `qualifications`, `partner`.
  - Maps to `ResultsDoctorItem` via `ConsultationDoctorModel` (`bio` → description, `education` when `qualifications` is empty, `partner.logoUrl` for logo; partner name only if API sends `partner.name` / `displayName`). `apiDoctorId` keeps numeric `id` for slots API.
- **GET** `AppUrls.paymentProviders` — `/api/v1/mobile/payment-provider` (active providers with `name`, `code`, `iconUrl`).
- **POST** `AppUrls.doctorConsultationBooking` — `/api/v1/mobile/doctor-consultation/book-consultation` (`multipart/form-data`).
  - Fields: `doctorId`, `tenantId`, `consultationFee`, `patientId`, `patientRelation`, `slotDate`, `slotStartTime`, `slotEndTime`, `paymentMethod` (e.g. `JAZZCASH`), `msisdn`, `attachments[]` (files).
  - `tenantId` from doctor `partner.tenantId` (not JWT); `patientId` from JWT/`AppPref`; JazzCash `msisdn` from selected saved account (profile phones via `GetAccountsListUseCase`; default/`isDefault` pre-selected in JazzCash sheet); slot values from selected availability chip.
- **GET** `AppUrls.doctorConsultationBookings(page, limit)` — `/api/v1/mobile/doctor-consultation?page=&limit=` (subscriber's booked consultations).
  - Response `data`: `{ data: [], page, limit, total }`; items map to `ConsultationBookingListItemEntity` (flexible doctor/slot/fee fields).
- **GET** `AppUrls.doctorConsultationSlots(doctorId, hospitalId?)` — `/api/v1/mobile/doctor-consultation/slots/{doctorId}` (optional `?hospitalId=` when doctors list provides it).
  - Response `data[]`: `date`, `slots[]` with `start_time`, `end_time`.
  - Uses `ResultsDoctorItem.partnerDoctorId` when present, else numeric `apiDoctorId` (`id` from doctors list).
  - Upstream errors like “Doctor hospital not found” are mapped to a user-friendly availability message.
- `HeaderInterceptor` adds `x-api-key` and `x-tenant-id` (when logged in) on aggregator host.

## State

- `ConsultationCubit` — loads categories via `GetConsultationCategoriesUseCase`.
- `DoctorConsultationResultsScreen` — paginated doctors via `GetConsultationDoctorsUseCase` (`page`/`limit` on scroll, `search` debounced from search field); **Filter** opens `ConsultationSelectPartnerSheetWidget` (static partners id `1` Oladoc, `2` MedIQ) and reloads doctors with optional `partnerId`.
- `DoctorConsultationBookDoctorScreen` — loads slots via `GetConsultationDoctorSlotsUseCase` using `ResultsDoctorItem.apiDoctorId`. Documents section supports multiple attachments (gallery/file multi-select; camera appends) with per-item delete.
- `DoctorConsultationCheckoutCubit` — loads payment providers via `GetPaymentProvidersUseCase`; submits booking via `SubmitConsultationBookingUseCase`. JazzCash Continue opens `DoctorConsultationJazzCashAccountsSheetWidget` (loads saved phones via `GetAccountsListUseCase`; default account pre-selected). **Add Account** opens shared `AddAccountScreen` (`AddAccountLaunchSource.consultationCheckout`); on save, sheet reloads all accounts and selects the new number.
- `DoctorConsultationBookingsCubit` (bookings tab) — loads paginated bookings via `GetConsultationBookingsUseCase`.

## DI

- `consultation_injection.dart` — `ConsultationRemoteDataSourceImpl`, repository, category/doctor/slots/payment-provider/booking/bookings-list use cases, `DoctorConsultationCheckoutCubit`, `DoctorConsultationBookingsCubit`.

## Mocks

- `ConsultationCategoriesMockApi` / `ConsultationDoctorsMockApi` / `ConsultationDoctorSlotsMockApi` / `ConsultationBookingMockApi` / `ConsultationBookingsListMockApi` / `PaymentProvidersMockApi` — when `MockConfig.enableConsultationMocks` is true (default false).
- Book-doctor screen displays the same `ResultsDoctorItem` passed from results (no separate detail fetch).
