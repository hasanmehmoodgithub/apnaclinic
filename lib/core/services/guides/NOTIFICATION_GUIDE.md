# 🔔 Notification Service Guide

Complete guide for Firebase Cloud Messaging (FCM) notifications with custom routing.

---

## 📖 Overview

The Notification Service handles:
- ✅ **Foreground notifications** - When app is open (shows local notification)
- ✅ **Background notifications** - When app is in background
- ✅ **Terminated notifications** - When app is closed
- ✅ **Local notifications** - Show notifications using flutter_local_notifications
- ✅ **Custom routing** - Navigate to specific screens based on notification data
- ✅ **FCM token management** - Get and refresh tokens
- ✅ **Topic subscription** - Subscribe/unsubscribe to topics
- ✅ **Auto-test subscription** - Automatically subscribes to `TestNotification` in debug mode (`kDebugMode`)

---

## 🚀 Setup

### Step 1: Add Dependencies

Already added to `pubspec.yaml`:
```yaml
firebase_core: ^3.6.0
firebase_messaging: ^15.1.3
flutter_local_notifications: ^18.0.1
```

### Step 2: Initialize Firebase

1. **Install Firebase CLI:**
   ```bash
   npm install -g firebase-tools
   ```

2. **Login to Firebase:**
   ```bash
   firebase login
   ```

3. **Configure Firebase:**
   ```bash
   flutter pub add firebase_core
   flutterfire configure
   ```

4. **Uncomment in `main.dart`:**
   ```dart
   import 'package:firebase_core/firebase_core.dart';
   import 'firebase_options.dart';
   
   await Firebase.initializeApp(
     options: DefaultFirebaseOptions.currentPlatform,
   );
   ```

### Step 3: Android Setup

**File:** `android/app/build.gradle`

```gradle
android {
    defaultConfig {
        // Add this
        minSdkVersion 21
    }
}
```

**File:** `android/app/src/main/AndroidManifest.xml`

```xml
<manifest>
    <application>
        <!-- Add this -->
        <meta-data
            android:name="com.google.firebase.messaging.default_notification_channel_id"
            android:value="high_importance_channel" />
    </application>
</manifest>
```

### Step 4: iOS Setup

**File:** `ios/Runner/Info.plist`

```xml
<key>FirebaseAppDelegateProxyEnabled</key>
<false/>
```

---

## 📱 Usage

### Initialize Service

Already initialized in `main.dart`:

```dart
final notificationService = NotificationService();
await notificationService.initialize();
notificationService.setupBackgroundMessageHandler();
```

### Get FCM Token

```dart
final notificationService = NotificationService();
final token = notificationService.fcmToken;
print('FCM Token: $token');
```

### Listen to Notifications

Already set up in `FlutterSampleApp`:

```dart
NotificationService().notificationStream.listen((payload) {
  print('Notification received: ${payload.title}');
  print('Route: ${payload.route}');
  print('Data: ${payload.data}');
});
```

### Navigate to Custom Route

The service automatically navigates based on notification data. Prefer booking fields so details screens receive typed args:

```json
{
  "notification": {
    "title": "Booking confirmed",
    "body": "Your consultation is confirmed"
  },
  "data": {
    "serviceType": "CONSULTATION",
    "unified_order_id": "12345"
  }
}
```

Or a hub / inbox path:

```json
{
  "data": {
    "route": "notifications"
  }
}
```

### Manual Navigation

```dart
final notificationService = NotificationService();
notificationService.navigateToRoute(
  'profile',
  data: {'userId': '123'},
);
```

### Subscribe to Topic

```dart
final notificationService = NotificationService();
await notificationService.subscribeToTopic('news');
```

### Unsubscribe from Topic

```dart
final notificationService = NotificationService();
await notificationService.unsubscribeFromTopic('news');
```

### Auto-Subscribe to Test Topic 🧪

**Automatic Testing Subscription:**

The service **automatically subscribes** to `TestNotification` when the app is running in **debug mode** (`kDebugMode`).

This allows you to easily test notifications by sending to the `TestNotification` topic from Firebase Console without manual subscription.

**Example:**
```dart
// Automatically called during initialization
if (kDebugMode) {
  await subscribeToTopic('TestNotification');
}
```

**Testing:**
1. Run a debug build (`flutter run`, not a release/profile APK)
2. Go to Firebase Console → Cloud Messaging
3. Send notification to topic: `TestNotification`
4. Debug devices will receive the notification

**Note:** Profile and release builds do NOT auto-subscribe to test topics.

---

## 🎯 Notification States

### 1. Foreground (App Open)

**Handler:** `FirebaseMessaging.onMessage`

Automatically handled in `NotificationService._setupForegroundHandler()`

**Example:**
```dart
FirebaseMessaging.onMessage.listen((RemoteMessage message) {
  // Notification received while app is open
  // Automatically navigates if route is specified
});
```

### 2. Background (App in Background)

**Handler:** `FirebaseMessaging.onMessageOpenedApp`

Automatically handled in `NotificationService.setupBackgroundMessageHandler()`

**Example:**
```dart
FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
  // App opened from background via notification
  // Automatically navigates to route
});
```

### 3. Terminated (App Closed)

**Handler:** `FirebaseMessaging.getInitialMessage()`

Automatically handled in `NotificationService._handleInitialMessage()`

**Example:**
```dart
final initialMessage = await FirebaseMessaging.getInitialMessage();
if (initialMessage != null) {
  // App opened from terminated state
  // Automatically navigates after app initializes
}
```

---

## 🔧 Custom Routing

### Notification Payload Format

FCM `data` should include a `serviceType` and booking id so the app can open the matching details screen (same as the in-app inbox). All `data` values must be strings.

**Booking details (preferred — nested `deepLink`):**

```json
{
  "type": "BOOKING_CONFIRMED",
  "serviceType": "CONSULTATION",
  "deepLink": {
    "data": {
      "unified_order_id": "84213"
    }
  }
}
```

This opens consultation booking details for `84213`. Same pattern for `SURGERY` / `LAB`. **Pharmacy** uses `entity.publicId`, not `unified_order_id`:

```json
{
  "data": {
    "type": "BOOKING_CONFIRMED",
    "entity_id": "219888",
    "entity_kind": "PHARMACY_ORDER",
    "service_type": "PHARMACY",
    "unified_order_id": "219888"
  },
  "entity": {
    "id": 219888,
    "kind": "PHARMACY_ORDER",
    "publicId": "9ff000eb-4a49-461a-b9c1-7c6cb72d4460"
  },
  "endpoint": "mobile/orders/9ff000eb-4a49-461a-b9c1-7c6cb72d4460"
}
```

Tap opens pharmacy order details for `9ff000eb-4a49-461a-b9c1-7c6cb72d4460`. The same object may be nested under `deepLink` or sent as the FCM `data` map (values as JSON strings).

FCM `data` values must be strings, so `deepLink` may be sent as a JSON string:

```json
{
  "type": "BOOKING_CONFIRMED",
  "serviceType": "CONSULTATION",
  "deepLink": "{\"data\":{\"unified_order_id\":\"84213\"}}"
}
```

`serviceType` values: `CONSULTATION`, `SURGERY`, `LAB`, `PHARMACY`.

Id is read from `deepLink.data.unified_order_id` (also accepts `booking_id` / `entity_id`). **Pharmacy** uses `entity.publicId` (or the UUID in `endpoint`); never `unified_order_id`.

**Hub / named screen fallback:**

```json
{
  "data": {
    "route": "notifications"
  }
}
```

`route` / `screen` / `deepLink` can be a route name (`home`, `notifications`, `consultation`, `pharmacyMain`, `labTest`, `surgery`) or a path (`/notifications`).

### Tap behaviour

| App state | What happens |
|-----------|----------------|
| Foreground | Banner is shown locally. Tap opens the screen from encoded `data`. |
| Background | OS notification tap → `onMessageOpenedApp` → same routing. |
| Terminated | Cold start → `getInitialMessage()` after splash → same routing. |

### Route Mapping

The service navigates to routes defined in `AppRoutes`:

```dart
// Example routes
static const String profile = 'profile';
static const String home = 'home';
static const String settings = 'settings';
```

### Add Query Parameters

```json
{
  "data": {
    "route": "profile",
    "userId": "123",
    "tab": "settings"
  }
}
```

Will navigate to: `/profile?userId=123&tab=settings`

---

## 📝 Example: Send Notification from Server

### Using cURL

```bash
curl -X POST https://fcm.googleapis.com/fcm/send \
  -H "Authorization: key=YOUR_SERVER_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "to": "FCM_TOKEN",
    "notification": {
      "title": "New Message",
      "body": "You have a new message"
    },
    "data": {
      "route": "profile",
      "userId": "123"
    }
  }'
```

### Using Firebase Console

1. Go to Firebase Console
2. Select your project
3. Go to Cloud Messaging
4. Send test message
5. Add custom data:
   - Key: `route`
   - Value: `profile`

---

## 🎨 Local Notifications

### Already Implemented ✅

Local notifications are **already implemented** in the service! When a notification is received in the foreground, it automatically shows a local notification.

### Show Local Notification Manually

You can also show local notifications manually:

```dart
final notificationService = NotificationService();

// Show notification with route
await notificationService.showLocalNotification(
  title: 'New Message',
  body: 'You have a new message',
  route: 'profile',
  data: {'userId': '123'},
);

// Show notification without route
await notificationService.showLocalNotification(
  title: 'Reminder',
  body: 'Don\'t forget to complete your task',
);
```

### Notification Tap Handling

When a local notification is tapped, it automatically navigates to the route specified in the payload.

### Custom Notification Handler

Override notification handling in `FlutterSampleApp`:

```dart
void _handleNotification(NotificationPayload payload) {
  // Custom logic
  if (payload.data?['type'] == 'message') {
    // Handle message notification
  } else if (payload.data?['type'] == 'order') {
    // Handle order notification
  }
  
  // Navigate to route
  if (payload.route != null) {
    NotificationService().navigateToRoute(
      payload.route,
      data: payload.data,
    );
  }
}
```

---

## ✅ Checklist

- [ ] Firebase project created
- [ ] `firebase_options.dart` generated
- [ ] Firebase initialized in `main.dart`
- [ ] Notification service initialized
- [ ] Android manifest updated
- [ ] iOS Info.plist updated
- [ ] Routes added to `AppRoutes`
- [ ] Test notification sent
- [ ] Test foreground notification
- [ ] Test background notification
- [ ] Test terminated notification
- [ ] Test custom routing

---

## 🐛 Troubleshooting

### Token is null

- Check Firebase initialization
- Check permissions granted
- Check device internet connection

### Notifications not received

- Check FCM token is valid
- Check notification payload format
- Check Firebase project configuration
- Check device permissions

### Navigation not working

- Check route exists in `AppRoutes`
- Check route is added to `AppRouter`
- Check navigator key is set
- Check context is available

---

## 📚 Files

- **Service:** `lib/core/services/notification_service.dart`
- **Initialization:** `lib/main.dart`
- **App Widget:** `lib/features/app/presentation/screens/flutter_sample_app.dart`
- **Router:** `lib/core/router/app_router.dart`

---

**That's it! Your notification service is ready. 🔔**
