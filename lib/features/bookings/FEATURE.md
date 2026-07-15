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

## State

- `DoctorConsultationBookingsCubit` — paginated consultation bookings list (page 1, limit 20; infinite scroll load-more). Initial load uses `BookingsListShimmerWidget`. Empty list shows `EmptyBookingWidget` with “No Booking Available”.
- `DoctorConsultationBookingDetailsCubit` — shows preloaded booking from list args; falls back to mock details when no booking payload; submits feedback and updates local `patientReview` on success.

## UI

- `DoctorConsultationBookingCardWidget` — consultation list card; whole card opens booking details on tap; **View Details** button uses the same navigation.
- `DoctorConsultationBookingDetailsContentWidget` — thin composer for details body; sections: header (doctor + date card), patient/issue fields, review or feedback form, documents (name + Download under icon), billing, join CTA. Rating badge uses shared `AppRoundedRatingWidget` (whole numbers without decimals).
- `DoctorConsultationBookingFeedbackFormWidget` — rating + review + submit when `patientReview` is missing (hidden for cancelled); layout matches submitted review card (title, “Your Feedback” + date, stars + score chip, `#F7F7F7` text area).

## Mocks

- `DoctorConsultationBookingsMockApi` — consultation details fallback mock data when booking not passed in navigation args.
