# Promo code

## Purpose

Shared **promo code** validate + input for checkout. Users enter a code, the aggregator returns the discount, and the hosting module updates payable total. Validate runs only when the user presses keyboard Done on the promo field. Pharmacy Confirm, lab Book, and consultation Continue do not call validate. If a code is typed but not applied, those buttons stay on the screen and show `promoCodeApplyRequired`.

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

## Analytics

Firebase via `PromoCodeAnalytics` / `AnalyticsService` (mobile app only). CRM admin events (`promo_code_created` / `promo_code_edited` / `promo_code_deactivated`) are **not** logged in the Flutter app.

| Event | When | Params |
|---|---|---|
| `promo_code_entered` | User submits a code to validate | `code`, `service` (`CONSULTATION` / `LAB` / `PHARMACY`) |
| `promo_code_applied` | Validate succeeds | `code`, `service`, `discount_type`, `discount_value`, `user_type` (`free` for now; Pro membership is not sent) |
| `promo_code_rejected` | Validate fails | `code`, `service`, `reason` (`expired` / `not_started` / `ineligible_service` / `ineligible_user_type` / `invalid_code`) |

Order-confirmed events also include `promo_code_used` (Yes/No), `promo_code` (when used), and `user_type` (`free`):

- `pharmacy_order_confirmed`
- `doctor_consultation_booked`
- `lab_booking_confirmed` / `lab_test_booked`

Reject `reason` is inferred from the API/error message when the backend does not send a structured code.
