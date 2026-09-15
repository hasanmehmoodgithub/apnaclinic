# Promo code

## Purpose

Shared **promo code** validate + input for checkout. Users enter a code, the aggregator returns the discount, and the hosting module updates payable total.

## Routes / entry

No dedicated route. Hosted inside checkout UIs:

- Doctor consultation checkout (`AppRoutes.consultationCheckout`) via `PromoCodeCubit` + `PromoCodeFieldWidget` (`service=CONSULTATION`).
- Pharmacy checkout (`AppRoutes.pharmacyCheckout`) via the same cubit/widget (`service=PHARMACY`, `amount` = cart subtotal). Applied code is sent as `promo_code` on order checkout.
- Lab checkout (`AppRoutes.labTestCheckout`) via the same cubit/widget (`service=LAB`, `amount` = original fee). Applied code is sent as `promoCode` on `POST lab/book-test`.

## Data & APIs

| Action | Method | `AppUrls` |
|--------|--------|-----------|
| Validate | POST | `promoCodeValidate` → `/acs-aggregator/api/v1/mobile/promo-code/validate` |

Body: `{ "code", "service", "amount" }` where `service` is `CONSULTATION` | `LAB` | `PHARMACY`.

Success `data`: `code`, `discountType`, `discountValue`, `originalAmount`, `discountAmount`, `payableAmount`.

## State

- `PromoCodeCubit` / `PromoCodeState` — draft input, `idle` / `validating` / `applied` / `invalid`. Applied uses API `payableAmount` and `discountAmount`. Invalid keeps a chip + “Invalid Promo Code”; clear (X) returns to the input.

## DI

- `promo_code_injection.dart` → `initPromoCodeInjector()` from `dependency_injection.dart`.

## Mocks

- `PromoCodeMockApi` when `MockConfig.enablePromoCodeMocks` is true (default **false**). Mock success codes: `SAVE20` (20%), `JC50OFF` (50%).
