# Bookings feature

## Purpose

Tabbed bookings hub (doctor consultation, surgery, lab test, pharmacy) with list cards and detail screens.

## Routes / entry

- `BookingsDashboardScreen` — bottom nav tab; menu tile switches to this tab; `AppRoutes` booking detail routes per type.
- `AppRoutes.doctorConsultationBookingDetails` — consultation booking details; extra: `DoctorConsultationBookingDetailsArgs` (`bookingId`, optional preloaded `booking` from list).

## Data & APIs

- Doctor consultation list: **GET** `AppUrls.doctorConsultationBookings(page, limit)` via `GetConsultationBookingsUseCase` (consultation module). Maps API items to `DoctorConsultationBookingDetailsModel` in `DoctorConsultationBookingMapper`.

## State

- `DoctorConsultationBookingsCubit` — paginated consultation bookings list (page 1, limit 20; infinite scroll load-more). Initial load uses `BookingsListShimmerWidget`. Empty list shows `EmptyBookingWidget` with “No Booking Available”.
- `DoctorConsultationBookingDetailsCubit` — shows preloaded booking from list args; falls back to mock details when no booking payload.

## UI

- `DoctorConsultationBookingCardWidget` — consultation list card; whole card opens booking details on tap; **View Details** button uses the same navigation.

## Mocks

- `DoctorConsultationBookingsMockApi` — consultation details fallback mock data when booking not passed in navigation args.
