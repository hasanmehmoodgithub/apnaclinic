# Consultation feature

## Purpose

Doctor consultation category browse, doctor results, booking, and checkout.

## Routes / entry

- `AppRoutes.consultation` — category grid (`DoctorConsultationScreen`); tiles use surgery `Assets.iconsD1` / `Assets.iconsD2` background vectors on `ConsultationUiConfig.cardBackground`. **AI card** heading “Not sure which doctor to consult?” / subheading “Apna Clinic AI will help you find the right doctor” → **Start now!** requires login (`AuthGuard.requireLogin`); guests go to `AppRoutes.authLogin`. Logged-in users are asked for microphone permission, then open `AppRoutes.aiScreening` (blocked with snackbar if denied).
- `AppRoutes.aiScreening` — in-app WebView of `ConsultationUiConfig.apnaDoctorAiUrl` / `AppUrls.apnaDoctorAi` (`https://medai.mediq.com.pk/hudav2/`); no intro UI. WebView media permission requests are granted after the OS mic prompt. Back (header or system) shows exit confirm dialog (`showAiScreeningExitDialog`); Exit pops, Cancel stays.
- `AppRoutes.consultationDoctors` — doctor results; extra: `DoctorConsultationResultsArgs` (`selectedCategory`, `mainCategoryId`, preloaded `categoryOptions` from category grid — avoids duplicate categories API call). Book Now requires login (`AppPref.getLoginStatus()`); guests go to `AppRoutes.authLogin`.
- `AppRoutes.consultationCheckout` — payment screen; extra: `DoctorConsultationCheckoutArgs` (doctor, issue, selected slot, attachments, prefetched `paymentOptions`). Providers are loaded on **Get Appointment** via `GET payment-provider?module=consultation` before navigation. Submits booking via `POST` `AppUrls.doctorConsultationBooking` (`multipart/form-data`).
- `AppRoutes.consultationSummary` — booking summary after payment method selection; extra: `DoctorConsultationSummaryArgs`. **JazzCash** → account sheet then summary (selected msisdn). **Card** → summary with card method info (account `N/A`, profile phone as booking msisdn). Proceed submits booking; Cancel returns to checkout. After confirm, the success dialog cannot be dismissed (back/outside tap); **View Bookings** opens Bookings → Doctor Consultation (`BookingsTabs.doctorConsultation`).

## Data & APIs

- **GET** `AppUrls.doctorCategories` — `https://apnaclinic-aggregator.apps.jpocp.jazz.com.pk/api/v1/mobile/doctor-categories` (override `AGGREGATOR_BASE_URL`).
  - Response `data[]`: `id`, `title`, `displayLabel`, `iconPath`, `displayOrder`, `isActive`.
  - Maps to `ConsultationCategoryEntity`; inactive entries filtered; sorted by `displayOrder`.
- **GET** `AppUrls.doctorConsultationDoctors(mainCategoryId, partnerId?, search?, page, limit)` — `/api/v1/mobile/doctor-consultation/doctors?mainCategoryId=&partnerId=&search=&page=&limit=`.
  - Response `data.data[]`: `id`, `publicId`, `displayName`, `specialtyName`, `yearsOfExperience`, `profileImageUrl`, `consultationFee`, `discountPercent`, `isFree`, `ratingScore` (string or number), `bio`, `education`, `qualifications`, `partner`.
  - Response `data.partners[]`: `tenantId`, `tenant` (slug e.g. `oladoc`/`mediq`/`apna-clinic`, or UUID), `logoUrl` — used for Filter sheet (`partnerId` = `tenantId`). Name from `tenant` slug when present (UUIDs ignored); known tenants fall back to local Oladoc/MedIQ logos when `logoUrl` is null.
  - Maps to `ResultsDoctorItem` via `ConsultationDoctorModel`. Null `yearsOfExperience` / `bio` / `education` / empty `qualifications` omit those UI lines; `ratingScore` `0.00` hides rating text. Partner name/logo from `partner.tenantId` (+ catalog) when API omits name/`logoUrl`. `apiDoctorId` keeps numeric `id` for slots API.
- **GET** `AppUrls.paymentProviders(module:)` — `/api/v1/mobile/payment-provider?module=` where `module` is `consultation` | `lab` | `surgery` | `pharmacy` (active providers with `name`, `code`, `iconUrl`).
- **POST** `AppUrls.doctorConsultationBooking` — `/api/v1/mobile/doctor-consultation/book-consultation` (`multipart/form-data`).
  - Fields: `doctorId`, `tenantId`, `consultationFee` (**full/original fee**, not the discounted payable), `patientId`, `patientRelation` (`self`), `slotDate`, `slotStartTime`/`slotEndTime` in 12h AM/PM (e.g. `05:00 PM`), `paymentMethod` (e.g. `JAZZCASH`), `msisdn`, `issue` (`N/A` when the book-doctor field is left empty), optional `attachments` file(s). Issue on the book-doctor screen is optional (placeholder “Explain how are you feeling?”).
  - Multipart same as profile setup: `FormData.fromMap` with text fields + `MultipartFile.fromFile`; POST with `Content-Type: multipart/form-data` (ApiService adds boundary).
  - `tenantId` from doctor `partner.tenantId` (not JWT); `patientId` from JWT/`AppPref`; JazzCash `msisdn` from selected saved account (`ProfileSessionSync` / `AppPref` phone; default/`isDefault` pre-selected in JazzCash sheet); slot values from selected availability chip.
- **GET** `AppUrls.doctorConsultationBookings(page, limit)` — `/api/v1/mobile/doctor-consultation?page=&limit=` (subscriber's booked consultations).
  - Response `data`: `{ data: [], page, limit, total }`.
  - Item: `appointmentId`, `doctorInfo` (`doctorid`, `displayName`, `yearsOfExperience`, `profileImageUrl`, `consultationFee`, `discountPercent`, `isFree`, `education`, `specialtyName`, `ratings`, `pmdcVerified`, `partner`), `patientRelation`, `slot*`, `success`, `partnerRefNo`, `meetingLink`, `issue`, `attachments`, `doctorPerscriptions` (API typo; also accepts `doctorPrescriptions`), `patientReview` (`rating`/`review`/`date`, nullable).
  - `bookingId` resolves from `orderId` first (needed for detail GET), then `appointmentId`; `partnerRefNo` kept separately for feedback.
  - Maps to `ConsultationBookingListItemEntity` → bookings UI via `DoctorConsultationBookingMapper`. `success`: `PAID` → Confirmed, `PENDING_PAYMENT` → Pending, `FAILED` → Failed (list and details).
- **GET** `AppUrls.doctorConsultationBookingDetail(id)` — `/api/v1/mobile/doctor-consultation/{orderId}` — single consultation in `data` (same item shape as list). Used by Bookings **View Details** via `GetConsultationBookingUseCase`.
- **POST** `AppUrls.doctorConsultationFeedback` — `/api/v1/mobile/doctor-consultation/feedback` JSON `{ refNo, rating, review }`.
  - Used from booking details when `patientReview` is null (not cancelled); `refNo` is `partnerRefNo` (fallback booking id).
- **GET** `AppUrls.doctorConsultationSlots(doctorId, hospitalId?)` — `/api/v1/mobile/doctor-consultation/doctor/{doctorId}` (optional `?hospitalId=` when doctors list provides it).
  - Response `data.doctorInfo`: `ratings`, `pmdcVerified`, `verifiedPatientsCount`, `patientsSatisfiedPercentage`, `timeslots[]` (`date`, `slots[]` with `startTime`/`endTime` in 12h e.g. `12:40 PM`), `patientReviews` (`totalCount`, `filteredCount`, `reviews[]` with `rating`/`date`/`comment`/`patientName` — flexible keys).
  - Book-doctor screen shows Patient's Reviews under Description (first review + See More → Feedback bottom sheet). Ratings use shared `AppRoundedRatingWidget` (whole numbers without `.0`). While slots load, Verified Patients / Experience / Satisfied use shimmer cards (`isStatsLoading`).
  - Parser keeps slot times in 12h AM/PM (e.g. `03:50 PM`) for display and booking submit; legacy `data[]` with `start_time`/`end_time` still supported.
  - Missing dates between the first and last `timeslots` entry are filled as empty days (disabled in UI). First date with slots is auto-selected on load; month label reflects the selected date.
  - Uses `ResultsDoctorItem.partnerDoctorId` when present, else numeric `apiDoctorId` (`id` from doctors list).
  - Book-doctor screen uses API values only (doctors list + slots `doctorInfo`); empty or zero fields are hidden instead of hardcoded fallbacks.
- `HeaderInterceptor` adds `x-api-key` and `x-tenant-id` (when logged in) on aggregator host.

## State

- `ConsultationCubit` — loads categories via `GetConsultationCategoriesUseCase`.
- `DoctorConsultationResultsScreen` — paginated doctors via `GetConsultationDoctorsUseCase` (`page`/`limit` on scroll). Listed doctors are sorted by `ratingScore` descending (highest ratings first). Search runs on search-icon tap (or keyboard search); clear (X) appears beside the search icon when an active search is applied and reloads the full list. **Filter** opens `ConsultationSelectPartnerSheetWidget` with partners from doctors response (`data.partners`) and reloads with optional `partnerId` (`tenantId`). Active filter shows a red dot on the filter icon; sheet header shows **Clear** when a partner is selected.
- `DoctorConsultationBookDoctorScreen` — loads slots via `GetConsultationDoctorSlotsUseCase` using `ResultsDoctorItem.partnerDoctorId` or `apiDoctorId`. **Get Appointment** is disabled (faded, not tappable) until a time slot is selected. Documents section supports up to 5 attachments (gallery/file multi-select; camera appends) with per-item delete; UI shows 1 MB per-file and 5-file limits; larger or excess files are rejected with snackbars.
- `DoctorConsultationCheckoutCubit` — uses prefetched `paymentOptions` from args when present (skips provider API); otherwise loads via `GetPaymentProvidersUseCase(module: consultation)`. Submits booking via `SubmitConsultationBookingUseCase` → `PaymentInitiationResult`. Summary confirm: if `data.paymentUrl` is present, opens `AppRoutes.cardPayment` (`AndroidInterface` WebView) before the success dialog. JazzCash Continue opens `DoctorConsultationJazzCashAccountsSheetWidget` (Select Account only — no JazzCash info tile; reads phones from `ProfileSessionSync` / prefs, no GET on open; default pre-selected). **Add Account** opens shared `AddAccountScreen` (`AddAccountLaunchSource.consultationCheckout`); on save, sheet refreshes via `GetAccountsListUseCase` and selects the new number. Same sheet is reused by lab checkout and surgery booking pay.
- `DoctorConsultationBookingsCubit` (bookings tab) — loads paginated bookings via `GetConsultationBookingsUseCase`.
- Booking details — loads single booking via `GetConsultationBookingUseCase`; submits feedback via `SubmitConsultationFeedbackUseCase`.

## DI

- `consultation_injection.dart` — `ConsultationRemoteDataSourceImpl`, repository, category/doctor/slots/payment-provider/booking/feedback/bookings-list/booking-detail use cases, `DoctorConsultationCheckoutCubit`, `DoctorConsultationBookingsCubit`.

## Mocks

- `ConsultationCategoriesMockApi` / `ConsultationDoctorsMockApi` / `ConsultationDoctorSlotsMockApi` / `ConsultationBookingMockApi` / `ConsultationBookingsListMockApi` (list + detail) / `PaymentProvidersMockApi` — when `MockConfig.enableConsultationMocks` is true (currently off; uses real API).
- Book-doctor screen displays the same `ResultsDoctorItem` passed from results (no separate detail fetch).
