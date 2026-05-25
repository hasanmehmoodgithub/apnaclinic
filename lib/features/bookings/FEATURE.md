# Bookings feature

## Purpose

Tabbed bookings hub (doctor consultation, surgery, lab test, pharmacy) with list cards and detail screens.

## Routes / entry

- `BookingsDashboardScreen` — bottom nav tab; `AppRoutes` booking detail routes per type.

## UI

- `DoctorConsultationBookingCardWidget` — consultation list card; status/fee row spans full card width (avoids overlap on narrow screens); doctor summary uses `Wrap` for name, rating, and date/time pills.

## Mocks

- `DoctorConsultationBookingsMockApi` — consultation list/details mock data.
