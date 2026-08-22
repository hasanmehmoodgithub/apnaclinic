# Notification feature

## Purpose

In-app notification list and Firebase Cloud Messaging (FCM) push notifications.

## Routes / entry

- `AppRoutes.notifications` — notification inbox screen.
- Home app bar red dot shows only when the user is logged in and `NotificationCubit` has unread items (`isRead == false`). Opening the inbox refreshes the shared cubit, so the dot clears as soon as there are no unread notifications.

## Push (Firebase)

- OS notification permission: `NotificationService.ensurePermissionsOnStart()` on first app frame (works without Firebase).
- FCM: `main.dart` via `FirebaseBootstrap` + `NotificationService.initializeFcm()` when Firebase is configured.
- Foreground: FCM → local notification via `flutter_local_notifications`.
- Background / terminated: `firebaseMessagingBackgroundHandler`; tap opens route from `data.route` / `data.deepLink`.
- FCM token stored in `AppPref` (`AppPrefKeys.fcmToken`); cleared on logout.
- Login: `NotificationService.ensureFcmTokenForLogin()` runs before verify OTP (lazy Firebase/FCM init if startup missed).
- Dev/staging/debug auto-subscribes to topic `TestNotification`.

## Setup required (one-time)

`lib/firebase_options.dart` is populated from `google-services.json` / `GoogleService-Info.plist` (project `notificationtes-dc9f6`). Re-run `flutterfire configure` if you add platforms or rotate keys.

1. Firebase project with Android + iOS apps (config files already in repo).
2. iOS: enable **Push Notifications** capability in Xcode; use a **physical device** for reliable FCM tokens (simulator may return empty APNS/FCM).
3. Full app restart after config changes (not hot restart).

## In-app list API

- **GET** `AppUrls.notifications(page, limit)` → `/acs-notification/api/v1/notifications?page=&limit=` via `GetNotificationsUseCase`.
  - Response: `{ success, message, data: { items[], page, limit, total, totalPages } }` (also accepts a top-level `items` list).
  - Item: `publicId`, `type`, `serviceType` (`CONSULTATION` / `LAB` / `SURGERY` / `PHARMACY`), `priority`, `title`, `body`, `deepLink` (`data.unified_order_id`, `data.entity_id` / `entity_kind` / `service_type`, `entity.id`/`kind`/`publicId`, `endpoint` — may be null), `isRead`, `readAt`, `createdAt`.
- **PUT** `AppUrls.notificationMarkRead(publicId)` → `/acs-notification/api/v1/notifications/{publicId}/read` via `MarkNotificationReadUseCase` (body `{}`).
- Tap flow: if unread → heart loader → mark read → navigate by `serviceType` + **`deepLink.data.unified_order_id`**; if already `isRead` → navigate only (no mark-read API). Falls back to `entity.id` / `entity_id` when `unified_order_id` is missing.
  - When routing fails (missing booking id, unsupported `serviceType`, etc.) → `AlertDialogCard` shows the notification title/body (or fallback l10n).
  - `CONSULTATION` → `doctorConsultationBookingDetails` (`bookingId` = unified order id).
  - `SURGERY` → `surgeryBookingDetails` (`leadId` = unified order id).
  - `LAB` → `labTestViewDetails` (`orderId` = unified order id, e.g. `62`).
  - `PHARMACY` → `pharmacyBookingDetails` with **`deepLink.entity.publicId`** (pharmacy order UUID). Falls back to unified order id if `publicId` is missing.
- Analytics: tap and FCM may fire `prescription_available` / `pharmacy_status_changed` when `type` matches (see bookings `FEATURE.md`).

## State

- `NotificationCubit` — loads inbox only when `AuthGuard.isLoggedIn()`; guests skip the list API. `markAsRead` is also login-gated. List is ordered by `createdAt` (newest first), not unread-first. Home creates the shared cubit and loads after login; push-driven refresh is skipped while logged out.
- Analytics: `notifications_screen_open` when opening inbox from home; `notifications_clicked` (`notification_id` = `publicId`) on list item tap.

## DI

- `notification_injection.dart` — repository, get/mark-read use cases, shared `NotificationCubit` singleton (home badge + inbox).
- `NotificationService` registered in core DI (`dependency_injection.dart`).

## Mocks

- `NotificationMockApi` when `MockConfig.enableNotificationMocks` is true (currently off; uses real API).
