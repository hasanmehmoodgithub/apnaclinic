# Notification feature

## Purpose

In-app notification list and Firebase Cloud Messaging (FCM) push notifications.

## Routes / entry

- `AppRoutes.notifications` — notification inbox screen.
- Home app bar badge reads unread count from `NotificationCubit`.

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

- `AppUrls.notifications` — placeholder REST path; still uses mock when `MockConfig.enableMocks` is true.
- Wire backend inbox API when available; FCM can refresh list via `HomeScreen` push listener.

## DI

- `notification_injection.dart` — repository, use case, `NotificationCubit`.
- `NotificationService` registered in core DI (`dependency_injection.dart`).

## Mocks

- `NotificationMockApi` when `MockConfig.enableMocks` is true (default).
