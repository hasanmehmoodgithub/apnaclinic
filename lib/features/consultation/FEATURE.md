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
  - Response `data.partners[]`: `tenantId`, `logoUrl` (optional `name`) — used to populate the results **Filter** partner sheet (`partnerId` = `tenantId`). Known tenants fall back to local Oladoc/MedIQ logos when `logoUrl` is null.
  - Maps to `ResultsDoctorItem` via `ConsultationDoctorModel` (`bio` → description, `education` when `qualifications` is empty, `partner.logoUrl` for logo; partner name only if API sends `partner.name` / `displayName`). `apiDoctorId` keeps numeric `id` for slots API.
- **GET** `AppUrls.paymentProviders` — `/api/v1/mobile/payment-provider` (active providers with `name`, `code`, `iconUrl`).
- **POST** `AppUrls.doctorConsultationBooking` — `/api/v1/mobile/doctor-consultation/book-consultation` (`multipart/form-data`).
  - Fields: `doctorId`, `tenantId`, `consultationFee`, `patientId`, `patientRelation` (`self`), `slotDate`, `slotStartTime`/`slotEndTime` in 12h AM/PM (e.g. `05:00 PM`), `paymentMethod` (e.g. `JAZZCASH`), `msisdn`, `issue`, optional `attachments` file(s).
  - Multipart same as profile setup: `FormData.fromMap` with text fields + `MultipartFile.fromFile`; POST with `Content-Type: multipart/form-data` (ApiService adds boundary).
  - `tenantId` from doctor `partner.tenantId` (not JWT); `patientId` from JWT/`AppPref`; JazzCash `msisdn` from selected saved account (profile phones via `GetAccountsListUseCase`; default/`isDefault` pre-selected in JazzCash sheet); slot values from selected availability chip.
- **GET** `AppUrls.doctorConsultationBookings(page, limit)` — `/api/v1/mobile/doctor-consultation?page=&limit=` (subscriber's booked consultations).
  - Response `data`: `{ data: [], page, limit, total }`.
  - Item: `doctorInfo` (`doctorid`, `displayName`, `yearsOfExperience`, `profileImageUrl`, `consultationFee`, `discountPercent`, `isFree`, `education`, `specialtyName`, `ratings`, `pmdcVerified`, `partner`), `patientRelation`, `slot*`, `success`, `partnerRefNo`, `issue`, `attachments` (URL strings), `patientReview` (`rating`/`review`/`date`, nullable).
  - Maps to `ConsultationBookingListItemEntity` → bookings UI via `DoctorConsultationBookingMapper`.
- **POST** `AppUrls.doctorConsultationFeedback` — `/api/v1/mobile/doctor-consultation/feedback` JSON `{ refNo, rating, review }`.
  - Used from booking details when `patientReview` is null (not cancelled); `refNo` is `partnerRefNo` (fallback booking id).
- **GET** `AppUrls.doctorConsultationSlots(doctorId, hospitalId?)` — `/api/v1/mobile/doctor-consultation/doctor/{doctorId}` (optional `?hospitalId=` when doctors list provides it).
  - Response `data.doctorInfo`: `ratings`, `pmdcVerified`, `verifiedPatientsCount`, `patientsSatisfiedPercentage`, `timeslots[]` (`date`, `slots[]` with `startTime`/`endTime` in 12h e.g. `12:40 PM`), `patientReviews` (`totalCount`, `filteredCount`, `reviews[]` with `rating`/`date`/`comment`/`patientName` — flexible keys).
  - Book-doctor screen shows Patient's Reviews under Description (first review + See More → Feedback bottom sheet).
  - Parser keeps slot times in 12h AM/PM (e.g. `03:50 PM`) for display and booking submit; legacy `data[]` with `start_time`/`end_time` still supported.
  - Missing dates between the first and last `timeslots` entry are filled as empty days (disabled in UI). First date with slots is auto-selected on load; month label reflects the selected date.
  - Uses `ResultsDoctorItem.partnerDoctorId` when present, else numeric `apiDoctorId` (`id` from doctors list).
  - Book-doctor screen uses API values only (doctors list + slots `doctorInfo`); empty or zero fields are hidden instead of hardcoded fallbacks.
- `HeaderInterceptor` adds `x-api-key` and `x-tenant-id` (when logged in) on aggregator host.

## State

- `ConsultationCubit` — loads categories via `GetConsultationCategoriesUseCase`.
- `DoctorConsultationResultsScreen` — paginated doctors via `GetConsultationDoctorsUseCase` (`page`/`limit` on scroll, `search` debounced from search field); **Filter** opens `ConsultationSelectPartnerSheetWidget` with partners from doctors response (`data.partners`) and reloads with optional `partnerId` (`tenantId`). Active filter shows a red dot on the filter icon; sheet header shows **Clear** when a partner is selected.
- `DoctorConsultationBookDoctorScreen` — loads slots via `GetConsultationDoctorSlotsUseCase` using `ResultsDoctorItem.partnerDoctorId` or `apiDoctorId`. Documents section supports multiple attachments (gallery/file multi-select; camera appends) with per-item delete.
- `DoctorConsultationCheckoutCubit` — loads payment providers via `GetPaymentProvidersUseCase`; submits booking via `SubmitConsultationBookingUseCase`. JazzCash Continue opens `DoctorConsultationJazzCashAccountsSheetWidget` (loads saved phones via `GetAccountsListUseCase`; default account pre-selected). **Add Account** opens shared `AddAccountScreen` (`AddAccountLaunchSource.consultationCheckout`); on save, sheet reloads all accounts and selects the new number.
- `DoctorConsultationBookingsCubit` (bookings tab) — loads paginated bookings via `GetConsultationBookingsUseCase`.
- Booking details — submits feedback via `SubmitConsultationFeedbackUseCase`.

## DI

- `consultation_injection.dart` — `ConsultationRemoteDataSourceImpl`, repository, category/doctor/slots/payment-provider/booking/feedback/bookings-list use cases, `DoctorConsultationCheckoutCubit`, `DoctorConsultationBookingsCubit`.

## Mocks

- `ConsultationCategoriesMockApi` / `ConsultationDoctorsMockApi` / `ConsultationDoctorSlotsMockApi` / `ConsultationBookingMockApi` / `ConsultationBookingsListMockApi` / `PaymentProvidersMockApi` — when `MockConfig.enableConsultationMocks` is true (currently off; uses real API).
- Book-doctor screen displays the same `ResultsDoctorItem` passed from results (no separate detail fetch).
