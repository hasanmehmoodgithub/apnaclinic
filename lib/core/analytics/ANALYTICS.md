# Analytics

Full UI + parameter report for product and engineering:
[ANALYTICS_EVENTS.html](ANALYTICS_EVENTS.html) (open in a browser).

Use `AnalyticsService.logEvent` for every event. Do not add feature-specific
methods on the service. Firebase is the first backend; add more in DI later.
AppsFlyer is not in the app; restore with [APPSFLYER.md](../services/APPSFLYER.md).

Firebase receives events **only when `FlavorConfig.isProduction`**.
Development and staging still print `developer.log` (`event:` / `screen:`) so
you can verify locally. `AnalyticsRouteObserver` (on `GoRouter`) calls
`logScreenView` on push / pop / replace.

## Layout
- `analytics_event_keys.dart` — event and parameter names
- `analytics_service.dart` — `logEvent` / screen / user id, fans out to providers
- `analytics_route_observer.dart` — screen views from navigation
- `providers/firebase_analytics_provider.dart` — Firebase (no-op until `FirebaseBootstrap`)
- `first_install_analytics.dart` — one-shot `first_install` on first device open

## First install

`FirstInstallAnalytics.logIfFirstTime()` runs from `main.dart` after DI.
`AppPref.isFirstTime()` defaults to `true`; after the event it is set to
`false` and is **not** cleared on logout.

| Event | When | Params |
|---|---|---|
| `first_install` | First app open on this device | `device` (model), `platform` (`android` / `ios`) |

## DI
```dart
sl.registerLazySingleton<AnalyticsService>(
  () => AnalyticsServiceImpl([
    FirebaseAnalyticsProvider(),
  ]),
);
```

## Usage
```dart
unawaited(
  sl<AnalyticsService>().logEvent(
    AnalyticsEventKeys.onboardingStep(2),
    {AnalyticsParamKeys.stepNumber: 2},
  ),
);
```

Add new names in `AnalyticsEventKeys` / `AnalyticsParamKeys`, then call `logEvent`.
Each `logEvent` / `logScreenView` writes a `developer.log` (`AnalyticsService`)
before fan-out. Fan-out to Firebase runs only on the production flavor.
Events before Firebase init are dropped. Do not put PII in parameters except
where a tracking spec requires it (`pharmacy_order_confirmed`,
`lab_booking_confirmed`, `surgery_booked`, `prescription_downloaded`, and
`instant_doc_prescription_download` include `user_name` and `msisdn`).

## Consultation AI chat
| Event | When | Param |
|---|---|---|
| `ai_chat_started` | AI screening WebView opens | — |
| `ai_chat_ended` | User confirms Exit | `call_duration` |
## Search
| Event | When | Params |
|---|---|---|
| `search_screen` | Search screen opens | — |
| `search_performed` | Submit | `keyword`, `medium` (`Type` / `Voice` / `Recent` / `Popular`) |
| `search_result_clicked` | Result tap | `type` (`medicine_name` / `doctor` / `lab` / `surgery_doctor`) |

## Instant Doctor
| Event | When | Params |
|---|---|---|
| `instant_doctor_module` | Instant Doctor tab opens | `source_screen` (`banner` / `bottom_tab`) |
| `instant_doc_subscribe_clicked` | Subscribe tap | `partner` |
| `fb_mobile_subscribe` | Subscribe OTP succeeds | `partner`, `msisdn` |
| `start_consultation_clicked` | Consultation WebView opens | `partner`, `msisdn` |
| `instant_doc_booking_opened` | My Bookings Instant Doctor View Details | `booking_id` |
| `instant_doc_prescription_view` | Prescription text/PDF shown in sheet | `booking_id` |
| `instant_doc_prescription_download` | Prescription PDF download / open | `booking_id`, `user_name`, `msisdn` |

## Pharmacy
| Event | When | Params |
|---|---|---|
| `pharmacy_module` | Hub opens, or product detail from global search | `source` (`home` / `search` / `banner`) |
| `pharmacy_search_clicked` | Pharmacy search field or search icon tap | — |
| `pharmacy_search_performed` | Non-empty pharmacy search returns | `keyword`, `result_items` |
| `medicine_item_clicked` | Medicine card tap (hub or related) | `product_id`, `product_name`, `prescription_required` (`Yes` / `No`) |
| `pharmacy_item_description` | Product detail API succeeds | same product params |
| `pharmacy_add_to_cart` | Add-to-cart API succeeds | `af_content_type`=`Pharmacy`, product params |
| `pharmacy_cart_Viewed` | Cart screen opens | `af_content_type`=`Pharmacy Cart` |
| `pharmacy_checkout` | Checkout screen opens | `af_content_type`=`Pharmacy`, `number_of_products` |
| `pharmacy_confirm_payment` | User confirms checkout (after JazzCash MSISDN if needed) | `payment_method` (`COD` / `JC` / `Card`) |
| `pharmacy_order_confirmed` | Order placed and card WebView succeeds when required | `order_id`, `user_name`, `msisdn`, `cart_items`, `sub_total`, `order_value`, `promo_applied`, `promo` (when a code is applied), `timestamp`, `delivery_charges`, `payment_method`, `payment_status` |

## Auth / profile
| Event | When | Params |
|---|---|---|
| `authentication_screen_viewed` | Login screen opens | `source` (`login` / `pharmacy` / `instant_doctor` / `consultancy` / `lab` / `surgery`) |
| `otp_sent` | OTP request succeeds | — |
| `otp_verified` | OTP verify succeeds | — |
| `profile_creation_screen` | Profile setup from login or Profile/menu | `source` (`authentication_screen` / `profile`) |
| `profile_created` | First-time profile save succeeds | — |

## Consultation
| Event | When | Params |
|---|---|---|
| `consultancy_module` | Category hub opens, or book-doctor from global search | `source` (`home` / `search` / `banner`) |
| `consultancy_search_clicked` | Category search field tap | — |
| `doctor_category_clicked` | Category tile or listing category change | `category_name` |
| `doctor_listing_screen` | Doctor listing opens / category changes | `category_name` |
| `doctor_search_clicked` | Doctor search field or search icon | — |
| `doctor_search_performed` | Non-empty doctor search | `keyword` |
| `doctor_filter_applied` | Partner filter selected | `partner` |
| `doctor_profile_clicked` | Doctor card / Book Now / search result | `doctor_id`, `doctor_name`, `category` |
| `doctor_profile_screen` | Book-doctor screen opens | same doctor params |
| `doctor_document_uploaded` | Attachment(s) accepted | — |
| `doctor_consultation_confirm` | Get Appointment continues to checkout | doctor params, `timeslot` |
| `doctor_consultation_booked` | Summary confirm succeeds or fails | `af_content_type`=`Consultancy`, `booking_id`, `user_name`, `msisdn`, doctor params, `consultation_timeslot`, `booking_timestamp`, `payment_method` (`JC`/`Card`), `payment_status` (`successful`/`failed`), `promo_applied`, `promo` (when a code is applied) |

## Lab
| Event | When | Params |
|---|---|---|
| `lab_module` | Lab hub opens | — |
| `lab_city_change` | User picks a city (dialog Continue) | `selected_city` |
| `lab_search_clicked` | Lab search field or search icon tap | — |
| `lab_search_performed` | Non-empty lab search returns | `keyword`, `result_items` |
| `lab_item_select` | Catalog card or global search lab result | `test_name`, `lab_name`, `sample_type` |
| `lab_add_to_cart` | Add to cart succeeds | `af_content_type`=`Lab`, `test_name`, `lab_name`, `partner_name`, `sample_type`, `sampling_mode` (`Home Sample` / `Walk In`) |
| `lab_cart_viewed` | Cart screen opens | `af_content_type`=`Lab Cart` |
| `lab_checkout` | Checkout screen opens | `af_content_type`=`Lab Checkout` |
| `lab_patient_details_edit` | User taps Edit on patient details | — |
| `lab_booking_confirmed` | Book API succeeds or fails (card WebView when required) | `af_content_type`=`Lab`, `booking_id`, `user_name`, `msisdn`, `number_of_tests`, `lab_name`, `timestamp`, `payment_method` (`JazzCash` / `Card` / `COD`), `payment_status` (`Successful` / `Failed`), `promo_applied`, `promo` |

## Surgery
| Event | When | Params |
|---|---|---|
| `surgery_module` | Surgery hub opens, or patient details from global search | `source_screen` (`Home` / `Search` / `Banner`) |
| `surgery_city_change` | User taps city dropdown | `selected_city` |
| `surgery_search_clicked` | Procedure search or doctor search field tap | — |
| `surgery_select_item` | Procedure tile or global search surgery result | `surgery_name` |
| `surgery_doctor_select` | Doctor card / Book Now, or search result | `doctor_id`, `doctor_name`, `surgery_name` |
| `surgery_checkout` | Patient details screen opens | `af_content_type`=`Surgery` |
| `surgery_booked` | Lead submit succeeds | `af_content_type`=`Surgery`, `booking_id`, `user_name`, `msisdn`, `surgery_name`, `doctor_name`, `amount`, `timestamp` |

## My Bookings
| Event | When | Params |
|---|---|---|
| `my_bookings_tab` | Bookings bottom tab is shown | — |
| `booking_viewed` | Booking details load | `type` (`consultancy` / `pharmacy` / `lab` / `surgery` / `instant_doctor`) |
| `instant_doc_booking_opened` | Instant Doctor View Details opens | `booking_id` |
| `instant_doc_prescription_view` | Instant Doctor prescription shown | `booking_id` |
| `instant_doc_prescription_download` | Instant Doctor prescription PDF download | `booking_id`, `user_name`, `msisdn` |
| `prescription_available` | Consultation details include doctor prescriptions, or prescription push | `booking_id`, `service` (`consultancy` / `instant_doctor`) |
| `prescription_downloaded` | User taps a consultation prescription file | `booking_id`, `service`, `user_name`, `msisdn` |
| `pharmacy_status_changed` | Pharmacy status push / inbox | `booking_id`, `status`, `changed_by` |
