# Pharmacy feature

## Purpose

Browse medicines, cart, checkout, and view pharmacy order details.

## Routes / entry

- `AppRoutes.pharmacyMain` — pharmacy dashboard (medicines home).
- `AppRoutes.pharmacyCart`, `AppRoutes.pharmacyCheckout`, `AppRoutes.pharmacyBookingDetails`.

## Order placed flow

After checkout confirm + order-placed dialog: `pharmacyGoToOrderDetailsAfterPlace` → `home` → `pharmacyMain` → `pharmacyBookingDetails`. Back: details → pharmacy main → home shell. `pharmacyPopOrGoHome` on hub/details headers if the stack is empty.
