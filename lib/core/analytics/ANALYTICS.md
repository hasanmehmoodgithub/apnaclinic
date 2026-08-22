# Analytics

Use `AnalyticsService.logEvent` for every event. Do not add feature-specific
methods on the service. Firebase is the first backend; add more in DI later.

## Layout
- `analytics_event_keys.dart` — event and parameter names
- `analytics_service.dart` — `logEvent` / screen / user id, fans out to providers
- `providers/firebase_analytics_provider.dart` — Firebase (no-op until `FirebaseBootstrap`)

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
Each `logEvent` writes a `developer.log` (`AnalyticsService`) before fan-out.
Events before Firebase init are dropped. Do not put PII in parameters.

## Home / dashboard
| Event | When | Params |
|---|---|---|
| `home_screen` | Home tab / screen opens | — |
| `pharmacy_tile_clicked` | Pharmacy service tile tap | — |
| `consultation_tile_clicked` | Consultation service tile tap | — |
| `lab_tile_clicked` | Lab service tile tap | — |
| `surgery_tile_clicked` | Surgery service tile tap | — |
| `search_clicked` | Home search / voice search entry | `source_screen` (`home screen`) |
| `notifications_screen_open` | Home notification icon → inbox | — |
| `my_bookings_clicked` | Menu My Bookings or Bookings bottom tab | — |
| `support_clicked` | Menu Support or Support bottom tab | — |
| `banner_clicked` | Promotional banner tap | `content_url` (image URL when present) |

`banner_name` is not sent — CMS banner model has no name field.

## Notifications
| Event | When | Params |
|---|---|---|
| `notifications_clicked` | Inbox list item tap | `notification_id` (`publicId`) |

## Consultation AI chat
| Event | When | Param |
|---|---|---|
| `ai_chat_started` | AI screening WebView opens | — |

## Search
| Event | When | Params |
|---|---|---|
| `search_screen` | Search screen opens | — |
| `search_performed` | Submit | `keyword`, `medium` (`Type` / `Voice` / `Recent` / `Popular`) |
| `search_result_clicked` | Result tap | `type` (`medicine_name` / `doctor` / `lab` / `surgery_doctor`) |

## Instant Doctor
| Event | When | Params |
|---|---|---|
| `instant_doctor_clicked` | Instant Doctor entry (banner / popup / nav) | `source` (`banner` / `popup` / `navigation_tab`) |
| `instant_doctor_module` | Same entry (legacy) | `source_screen` (`banner` / `bottom_tab`) |
| `instant_doc_subscribe_clicked` | Subscribe tap | `partner` |
| `fb_mobile_subscribe` | Subscribe OTP succeeds | `partner`, `msisdn` |
| `start_consultation_clicked` | Consultation WebView opens | `partner`, `msisdn` |
