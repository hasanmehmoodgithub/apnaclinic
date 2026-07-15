# Bookings feature

## Purpose

Tabbed bookings hub (doctor consultation, surgery, lab test, pharmacy) with list cards and detail screens.

## Routes / entry

- `BookingsDashboardScreen` — bottom nav tab; menu tile switches to this tab; `AppRoutes` booking detail routes per type.
- `AppRoutes.doctorConsultationBookingDetails` — consultation booking details; extra: `DoctorConsultationBookingDetailsArgs` (`bookingId`, optional preloaded `booking` from list).

## Data & APIs

- Doctor consultation list: **GET** `AppUrls.doctorConsultationBookings(page, limit)` via `GetConsultationBookingsUseCase` (consultation module). Maps API items to `DoctorConsultationBookingDetailsModel` in `DoctorConsultationBookingMapper`.
  - Item fields: `doctorInfo` (`doctorid`, `displayName`, `specialtyName`, `profileImageUrl`, fees/`discountPercent`/`isFree`, `ratings`, `pmdcVerified`, `partner`), `patientRelation`, `slotDate`/`slotStartTime`/`slotEndTime`, `success` (`PAID` → confirmed), `partnerRefNo` (booking id), `meetingLink`, `issue`, `attachments`, `doctorPerscriptions` (API spelling; mapped as `doctorPrescriptions`), `patientReview` (`rating`/`review`/`date`).
- Join Now enabled only while current time is within slot `[start, end]` (confirmed + `meetingLink`); disabled before start and after end.
- Patient’s Review / Feedback submit form is available only after slot end (submitted review always shown if present).
- Submit feedback (when no existing review, non-cancelled): **POST** `AppUrls.doctorConsultationFeedback` via `SubmitConsultationFeedbackUseCase` — body `{ refNo, rating, review }` (`refNo` = `partnerRefNo` / booking id).
- Surgery leads list: **GET** `AppUrls.surgeryLeads(page, limit)` via `GetSurgeryLeadsUseCase` (surgery module). Mapped by `SurgeryBookingListMapper`:
  - Status: API `status` (`PENDING` → Pending, `PAID` → Paid); **Proceed Checkout** shown only when API `paymentAllowed` is `true`.
  - Pricing: `fee`, `discount`, `total` (legacy `discountFee`/`quotedPrice`/`finalPrice` still parsed).
  - Appointment: shows API `scheduledDate` only (day/month/weekday/time). If null → “Awaiting confirmation.” + Applied On (no fake created date as schedule). Patient includes `gender`; phones as local `03…`.
  - Card: `surgeryType` + `subSurgeryType`; doctor + specialty/education; clinic `hospitalName` (not partner name); partner logo from `provider` id/name/logo. List and details reuse the same `SurgeryDetailsItem` via `SurgeryBookingCardWidget` (details omits View Details).
  - Navigation: `SurgeryBookingDetailsArgs(leadId, item, initialStatus)` with `ValueKey(leadId)` so the tapped lead is opened.
- Surgery pay / book: **POST** `AppUrls.surgeryBookSurgery` via `BookSurgeryUseCase` from booking details **Proceed Checkout** (visible only when `paymentAllowed`). Opens `PaymentMethodSheet` loading active providers from `GetPaymentProvidersUseCase` (`AppUrls.paymentProviders`, same as doctor consultation) with API `iconUrl` and local JazzCash/card fallbacks → JazzCash account sheet when JazzCash → body `{ leadId, paymentMethod, msisdn }`.
- Surgery details title: `bookingsSurgeryDetailsTitle` (“Details”).

## State

- `DoctorConsultationBookingsCubit` — paginated consultation bookings list (page 1, limit 20; infinite scroll load-more). Initial load uses `BookingsListShimmerWidget`. Empty list shows `EmptyBookingWidget` with “No Booking Available”.
- `DoctorConsultationBookingDetailsCubit` — shows preloaded booking from list args; falls back to mock details when no booking payload; submits feedback and updates local `patientReview` on success.

## UI

- `DoctorConsultationBookingCardWidget` — consultation list card; whole card opens booking details on tap; **View Details** button uses the same navigation.
- `DoctorConsultationBookingDetailsContentWidget` — thin composer for details body; sections: header (doctor + date card), patient/issue fields, review or feedback form, documents (name + Download under icon), billing, join CTA. Rating badge uses shared `AppRoundedRatingWidget` (whole numbers without decimals).
- `DoctorConsultationBookingFeedbackFormWidget` — rating + review + submit when `patientReview` is missing (hidden for cancelled); layout matches submitted review card (title, “Your Feedback” + date, stars + score chip, `#F7F7F7` text area).

## Mocks

- `DoctorConsultationBookingsMockApi` — consultation details fallback mock data when booking not passed in navigation args.
