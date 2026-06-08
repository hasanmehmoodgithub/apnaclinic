# Lab test feature

## Purpose

Browse lab tests, booking/cart flow, payment details checkout, and order view details.

## Routes / entry

- `AppRoutes.labTest`, `labTestBooking`, `labTestCart`, `labTestCheckout`, `labTestViewDetails`.

## UI

- `LabTestCheckoutBottomBarWidget` — payment details screen CTA uses shared `AppButtonWidget` (`labTestBookCta`).

## Data & APIs

- City picker uses **`CitiesRepository`** (prefetched at app open from `AppUrls.cities`); catalog API cities are ignored when the shared list is available.
