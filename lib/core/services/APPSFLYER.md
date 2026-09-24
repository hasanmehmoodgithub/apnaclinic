# AppsFlyer

**Status:** Scaffolded with credentials on all flavors. Product events stay on Firebase; AF uses separate `logEvent` calls when product shares the conversion sheet.

Product analytics stay on Firebase via `AnalyticsService`. AppsFlyer is attribution + **its own** event list (`AppsFlyerService.logEvent` / `AppsFlyerEventKeys`) — not fan-out.

## Package

- `appsflyer_sdk: ^6.18.1` in `pubspec.yaml`

## Flavor credentials (`lib/core/flavor/`)

On every `AppFlavor` (`development`, `staging`, `production`):

- `appsFlyerDevKey` — empty = skip SDK start
- `appsFlyerIosAppId` — numeric Apple App Store id (required on iOS with Dev Key)

`FlavorConfig`: `appsFlyerDevKey`, `appsFlyerIosAppId`, `isAppsFlyerConfigured`

Enable:

1. AppsFlyer dashboard → App Settings → **Dev Key**
2. App Store Connect → Apple ID (numeric) for iOS
3. Set values on the relevant `AppFlavor`
4. Full app restart (not hot reload)

## Wiring

| Piece | Location |
|-------|----------|
| Wrapper | `lib/core/services/appsflyer_service.dart` |
| Event keys (AF-only) | `lib/core/services/appsflyer_event_keys.dart` |
| DI | `_initCore` → `AppsFlyerService` |
| Start | `main.dart` `unawaited(_initializeAppsFlyer())` after `runApp`; rebinds saved user id if logged in |
| Login | `AuthCubit._saveUserSession` → `setCustomerUserId` |
| Logout | `LocalLogoutService.clearAll` → `clearCustomerUserId` |

## Events

Do **not** add AppsFlyer to `AnalyticsServiceImpl` providers unless product changes approach.

| Event | When | Params |
|---|---|---|
| `instant_doctor_module` | Instant Doctor tab / entry opens | `source_screen` (`banner` / `bottom_tab`), `partner` (empty at open) |
| `af_purchase` | Instant Doctor subscribe OTP succeeds | `source_screen`, `partner` |
| `af_add_to_cart` | Pharmacy add-to-cart succeeds | `af_content_type`=`Pharmacy`, `product_id`, `product_name`, `prescription_required` |
| `af_content_view` | Pharmacy product detail loads | `af_content_type`=`Pharmacy` |
| `af_initiated_checkout` | Pharmacy checkout opens | `af_content_type`=`Pharmacy` |
| `af_purchase` | Pharmacy order confirmed | `content_type`, `af_content_type`, `order_id`, `user_name`, `user_type`, `msisdn`, `cart_items`, `sub_total`, `order_value`, `promo_applied`, `timestamp`, `wellness_order`, `promo`, `delivery_charges`, `payment_method`, `payment_status`, `JazzCash Auth Code`, `transaction_id` |
| `ai_chat_started` | AI screening WebView opens | `msisdn`, `call_duration` (`0s`) |
| `ai_chat_ended` | AI screening Exit confirmed | `msisdn`, `call_duration` (e.g. `35s`) |
| `consultancy_module` | Consultation hub / category / search / filter | `source`, `category_name`, `keyword`, `partner` (filled when known) |
| `doctor_profile` | Profile click, book-doctor open, or Get Appointment confirm | `doctor_id`, `doctor_name`, `category`, `timeslot` (on confirm) |
| `af_purchase` | Consultation booked (success or fail) | `content_type`/`af_content_type`=`Consultancy`, `booking_id`, `user_name`, `user_type`, `msisdn`, doctor fields, `consultation_timeslot`, `booking_timestamp`, `payment_method`, `payment_status`, `transaction_id`, `wellness_order`, `promo_applied`, `promo` |
| `af_add_to_cart` | Lab add to cart succeeds | `af_content_type`=`Lab`, `test_name`, `lab_name`, `partner_name`, `sample_type`, `sampling_mode` |
| `af_content_view` | Lab test selected (catalog / search) | `af_content_type`=`Lab` |
| `af_initiated_checkout` | Lab checkout opens | `af_content_type`=`Lab Checkout` |
| `af_purchase` | Lab booking confirmed | `content_type`/`af_content_type`=`Lab`, `booking_id`, `user_name`, `msisdn`, `number_of_tests`, `lab_name`, `partner`, `address`, `timestamp`, `payment_method`, `payment_status`, `transaction_id`, `promo_applied`, `promo` |
| `surgery_module` | Surgery hub open / city change | `source_screen`, `selected_city` |
| `af_initiated_checkout` | Surgery patient details opens | `af_content_type`=`Surgery`, `surgery_name`, `doctor_id`, `doctor_name` |
| `af_purchase` | Surgery lead submit succeeds | `content_type`/`af_content_type`=`Surgery`, `booking_id`, `user_type`, `user_name`, `msisdn`, `surgery_name`, `doctor_name`, `amount`, `promo_applied`, `promo_code`, `timestamp` |

Names live in `AppsFlyerEventKeys` / `AppsFlyerParamKeys`. Call `AppsFlyerService.logEvent` from feature cubits (not widgets).

Pharmacy `af_purchase` sends empty `wellness_order`, `JazzCash Auth Code`, and `transaction_id` until those fields exist on checkout/API. Consultation `af_purchase` sends empty `wellness_order`; `transaction_id` uses `publicId` when present. Lab `af_purchase` sends empty `address`; `transaction_id` uses `publicId` when present. Surgery `af_purchase` sends `promo_applied`=`No` / omits `promo_code` until promo exists on surgery lead flow.

## Constraints

- Do not block `runApp` on AppsFlyer init
- Empty credentials must skip start without crashing
- Keep custom AF events separate from Firebase `AnalyticsEventKeys`
