import 'dart:async';
import 'dart:convert';
import 'dart:developer' as developer;

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../features/auth/domain/use_cases/update_fcm_device_token_use_case.dart';
import '../../features/bookings/presentation/bookings_analytics.dart';
import '../../features/notification/presentation/notification_navigation.dart';
import '../../firebase_options.dart';
import '../di/dependency_injection.dart';
import '../firebase/firebase_bootstrap.dart';
import '../preference/app_pref.dart';
import '../preference/app_pref_keys.dart';
import '../router/app_router.dart';
import '../router/app_routes.dart';
import 'notification_background_handler.dart';

class NotificationPayload {
  const NotificationPayload({
    this.title,
    this.body,
    this.route,
    this.data = const {},
  });

  final String? title;
  final String? body;
  final String? route;
  final Map<String, dynamic> data;

  factory NotificationPayload.fromRemoteMessage(RemoteMessage message) {
    final data = Map<String, dynamic>.from(message.data);
    return NotificationPayload(
      title: message.notification?.title ?? data['title']?.toString(),
      body: message.notification?.body ?? data['body']?.toString(),
      route: _routeFromData(data),
      data: data,
    );
  }

  /// Encodes route + data so a foreground local-notification tap can still
  /// open the correct screen (keeps nested `deepLink` JSON intact).
  String toLocalPayload() {
    return jsonEncode({
      if (route != null && route!.isNotEmpty) 'route': route,
      'data': _jsonSafe(data),
    });
  }

  static dynamic _jsonSafe(dynamic value) {
    if (value is Map) {
      return value.map(
        (key, nested) => MapEntry(key.toString(), _jsonSafe(nested)),
      );
    }
    if (value is List) {
      return value.map(_jsonSafe).toList();
    }
    return value;
  }

  static NotificationPayload? fromLocalPayload(String? raw) {
    final text = raw?.trim() ?? '';
    if (text.isEmpty) return null;

    try {
      final decoded = jsonDecode(text);
      if (decoded is Map) {
        final map = Map<String, dynamic>.from(decoded);
        final nested = map['data'];
        final data = nested is Map
            ? Map<String, dynamic>.from(nested)
            : map;
        return NotificationPayload(
          route: _routeFromData({...data, ...map}),
          data: data,
        );
      }
    } catch (_) {
      if (!text.startsWith('{')) {
        return NotificationPayload(route: text);
      }
    }
    return null;
  }

  static String? _routeFromData(Map<String, dynamic> data) {
    for (final key in const ['route', 'screen', 'deepLink', 'deep_link']) {
      final value = data[key]?.toString().trim() ?? '';
      if (value.isEmpty || value.startsWith('{')) continue;
      return value;
    }
    return null;
  }
}

/// Firebase Cloud Messaging + local notifications (foreground display).
class NotificationService {
  NotificationService({required AppPref appPref}) : _appPref = appPref;

  final AppPref _appPref;
  FirebaseMessaging? _firebaseMessaging;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();
  final StreamController<NotificationPayload> _notificationController =
      StreamController<NotificationPayload>.broadcast();

  Stream<NotificationPayload> get notificationStream =>
      _notificationController.stream;

  String? _fcmToken;
  bool _permissionsPrepared = false;
  bool _initialized = false;
  bool _openedAppBound = false;
  bool _deviceTokenUploadInFlight = false;

  bool get permissionsPrepared => _permissionsPrepared;

  bool get isInitialized => _initialized;

  String? get fcmToken => _fcmToken;

  /// Ensures Firebase/FCM are ready and returns the best token for login API.
  Future<String?> ensureFcmTokenForLogin() async {
    final existing = _fcmToken?.trim();
    if (existing != null && existing.isNotEmpty) return existing;

    final stored = _readStoredToken();
    if (stored != null) return stored;

    if (!DefaultFirebaseOptions.isConfigured) {
      developer.log(
        'FCM token unavailable: firebase_options not configured',
        name: 'NotificationService',
      );
      return null;
    }

    if (!FirebaseBootstrap.isInitialized) {
      final ready = await FirebaseBootstrap.initialize();
      if (!ready) return null;
    }

    if (!_initialized) {
      await initializeFcm();
    } else {
      await _getFCMToken();
    }

    final token = _fcmToken?.trim();
    return (token != null && token.isNotEmpty) ? token : _readStoredToken();
  }

  String? _readStoredToken() {
    final stored = _appPref.getString(AppPrefKeys.fcmToken)?.trim();
    return (stored != null && stored.isNotEmpty) ? stored : null;
  }

  /// Local notification setup + OS permission prompt. Runs without Firebase.
  Future<void> ensurePermissionsOnStart() async {
    if (_permissionsPrepared) return;
    try {
      await _initializeLocalNotifications();
      await _requestLocalPermissions();
      _permissionsPrepared = true;
      developer.log(
        'Notification permissions requested',
        name: 'NotificationService',
      );
    } catch (e, stackTrace) {
      developer.log(
        'Notification permission setup failed: $e',
        name: 'NotificationService',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  /// FCM handlers and token — requires [FirebaseBootstrap.initialize] first.
  Future<void> initializeFcm() async {
    if (_initialized) return;
    if (!FirebaseBootstrap.isInitialized) {
      developer.log(
        'FCM skipped: Firebase is not initialized.',
        name: 'NotificationService',
      );
      return;
    }

    try {
      await ensurePermissionsOnStart();
      _firebaseMessaging = FirebaseMessaging.instance;
      await _requestFcmPermissions();
      await _getFCMToken();
      _setupForegroundHandler();
      _bindOpenedAppHandler();
      FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
      await _handleLaunchFromNotification();
      _firebaseMessaging?.onTokenRefresh.listen((token) {
        unawaited(_handleTokenRefresh(token));
      });
      await _subscribeDebugTopicIfNeeded();
      _initialized = true;
      developer.log('FCM initialized', name: 'NotificationService');
      unawaited(syncDeviceTokenIfNeeded());
    } catch (e, stackTrace) {
      developer.log(
        'FCM init failed: $e',
        name: 'NotificationService',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  void setupBackgroundMessageHandler() {
    if (!_initialized || _firebaseMessaging == null) return;
    _bindOpenedAppHandler();
  }

  void _bindOpenedAppHandler() {
    if (_openedAppBound) return;
    _openedAppBound = true;
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      unawaited(
        _openFromTap(NotificationPayload.fromRemoteMessage(message)),
      );
    });
  }

  Future<void> _initializeLocalNotifications() async {
    const initSettings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false,
      ),
    );

    await _localNotifications.initialize(
      settings: initSettings,
      onDidReceiveNotificationResponse: (response) {
        final payload = NotificationPayload.fromLocalPayload(response.payload);
        if (payload != null) {
          unawaited(_openFromTap(payload));
        }
      },
    );

    const androidChannel = AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notifications',
      description: 'Used for important Apna Clinic alerts.',
      importance: Importance.high,
    );

    await _localNotifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(androidChannel);
  }

  Future<void> _requestLocalPermissions() async {
    final iosPlugin = _localNotifications
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >();
    if (iosPlugin != null) {
      await iosPlugin.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
    }

    final androidPlugin = _localNotifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    if (androidPlugin != null) {
      await androidPlugin.requestNotificationsPermission();
    }
  }

  Future<void> _requestFcmPermissions() async {
    await _firebaseMessaging?.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  Future<void> _getFCMToken() async {
    try {
      if (defaultTargetPlatform == TargetPlatform.iOS) {
        final apnsToken = await _firebaseMessaging
            ?.getAPNSToken()
            .timeout(const Duration(seconds: 5), onTimeout: () => null);
        developer.log(
          'APNS token ${apnsToken != null ? "available" : "not yet available"}',
          name: 'NotificationService',
        );
      }
      _fcmToken = await _firebaseMessaging
          ?.getToken()
          .timeout(const Duration(seconds: 8), onTimeout: () => null);
      if (_fcmToken == null || _fcmToken!.isEmpty) {
        developer.log('FCM getToken returned empty', name: 'NotificationService');
      } else {
        developer.log(
          'FCM token acquired (length=${_fcmToken!.length})',
          name: 'NotificationService',
        );
      }
      await _persistToken(_fcmToken);
    } catch (e) {
      developer.log('FCM token error: $e', name: 'NotificationService');
    }
  }

  Future<void> _handleTokenRefresh(String token) async {
    await _persistToken(token);
    await syncDeviceTokenIfNeeded(token: token);
  }

  Future<void> _persistToken(String? token) async {
    if (token == null || token.isEmpty) return;
    _fcmToken = token;
    await _appPref.setString(AppPrefKeys.fcmToken, token);
    developer.log('FCM token updated', name: 'NotificationService');
  }

  /// Marks the token already sent on OTP verify so login does not also PUT.
  Future<void> markDeviceTokenUploaded(String token) async {
    final value = token.trim();
    if (value.isEmpty) return;
    _fcmToken = value;
    await _appPref.setString(AppPrefKeys.fcmToken, value);
    await _appPref.setString(AppPrefKeys.fcmTokenSentToBackend, value);
  }

  /// Uploads FCM only when logged in and the token differs from last upload.
  Future<void> syncDeviceTokenIfNeeded({String? token}) async {
    final value = (token ?? _fcmToken ?? _readStoredToken())?.trim();
    if (value == null || value.isEmpty) return;
    if (!_appPref.getLoginStatus()) return;

    final lastSent =
        _appPref.getString(AppPrefKeys.fcmTokenSentToBackend)?.trim();
    if (value == lastSent) return;
    if (_deviceTokenUploadInFlight) return;
    if (!sl.isRegistered<UpdateFcmDeviceTokenUseCase>()) return;

    _deviceTokenUploadInFlight = true;
    try {
      final result = await sl<UpdateFcmDeviceTokenUseCase>().call(
        UpdateFcmDeviceTokenParams(fcmToken: value),
      );
      await result.fold(
        (error) async {
          developer.log(
            'FCM device-token upload failed: $error',
            name: 'NotificationService',
          );
        },
        (_) async {
          await _appPref.setString(AppPrefKeys.fcmTokenSentToBackend, value);
          developer.log(
            'FCM device-token uploaded (length=${value.length})',
            name: 'NotificationService',
          );
        },
      );
    } catch (e) {
      developer.log(
        'FCM device-token upload error: $e',
        name: 'NotificationService',
      );
    } finally {
      _deviceTokenUploadInFlight = false;
    }
  }

  void _setupForegroundHandler() {
    FirebaseMessaging.onMessage.listen((message) async {
      final payload = NotificationPayload.fromRemoteMessage(message);
      _notificationController.add(payload);
      BookingsAnalytics.logFromFcmData(payload.data);
      await _showLocalNotification(payload);
    });
  }

  Future<void> _handleLaunchFromNotification() async {
    final initialMessage = await _firebaseMessaging?.getInitialMessage();
    if (initialMessage != null) {
      unawaited(
        _openFromTap(NotificationPayload.fromRemoteMessage(initialMessage)),
      );
      return;
    }

    final launchDetails =
        await _localNotifications.getNotificationAppLaunchDetails();
    if (launchDetails?.didNotificationLaunchApp != true) return;
    final payload = NotificationPayload.fromLocalPayload(
      launchDetails!.notificationResponse?.payload,
    );
    if (payload != null) {
      unawaited(_openFromTap(payload));
    }
  }

  Future<void> _showLocalNotification(NotificationPayload payload) async {
    const notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails(
        'high_importance_channel',
        'High Importance Notifications',
        channelDescription: 'Used for important Apna Clinic alerts.',
        importance: Importance.high,
        priority: Priority.high,
        icon: '@mipmap/ic_launcher',
      ),
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    );

    await _localNotifications.show(
      id: payload.hashCode,
      title: payload.title ?? 'Apna Clinic',
      body: payload.body ?? '',
      notificationDetails: notificationDetails,
      payload: payload.toLocalPayload(),
    );
  }

  Future<void> _openFromTap(NotificationPayload payload) async {
    _notificationController.add(payload);
    BookingsAnalytics.logFromFcmData(payload.data);
    await _waitUntilPastSplash();
    final opened = openPushNotificationLink(
      data: payload.data,
      route: payload.route,
    );
    if (!opened) {
      developer.log(
        'Notification tap had no screen to open '
        'route=${payload.route} data=${payload.data}',
        name: 'NotificationService',
      );
    }
  }

  Future<void> _waitUntilPastSplash() async {
    final deadline = DateTime.now().add(const Duration(seconds: 6));
    while (DateTime.now().isBefore(deadline)) {
      if (!_isSplashRoute(_currentRoutePath())) return;
      await Future<void>.delayed(const Duration(milliseconds: 250));
    }
  }

  String _currentRoutePath() {
    try {
      return AppRouter.router.state.uri.path;
    } catch (_) {
      return AppRouter.router.routerDelegate.currentConfiguration.uri.path;
    }
  }

  bool _isSplashRoute(String path) {
    final name = path.replaceFirst(RegExp(r'^/'), '');
    return name.isEmpty || name == AppRoutes.splash;
  }

  Future<void> _subscribeDebugTopicIfNeeded() async {
    if (!kDebugMode) return;
    try {
      await subscribeToTopic('TestNotification').timeout(
        const Duration(seconds: 5),
        onTimeout: () {
          developer.log(
            'Topic subscribe timed out (emulator / no Play Services)',
            name: 'NotificationService',
          );
        },
      );
    } catch (e) {
      developer.log('Topic subscribe failed: $e', name: 'NotificationService');
    }
  }

  Future<void> subscribeToTopic(String topic) async {
    try {
      await _firebaseMessaging?.subscribeToTopic(topic);
    } catch (e) {
      developer.log('Topic subscribe failed: $e', name: 'NotificationService');
    }
  }

  Future<void> unsubscribeFromTopic(String topic) async {
    try {
      await _firebaseMessaging?.unsubscribeFromTopic(topic);
    } catch (e) {
      developer.log('Topic unsubscribe failed: $e', name: 'NotificationService');
    }
  }

  /// Drops the in-memory token immediately (prefs/Firebase may follow).
  void discardLocalToken() {
    _fcmToken = null;
  }

  Future<void> deleteToken() async {
    discardLocalToken();
    await _appPref.remove(AppPrefKeys.fcmToken);
    await _appPref.remove(AppPrefKeys.fcmTokenSentToBackend);
    if (_firebaseMessaging == null) return;
    try {
      await _firebaseMessaging!.deleteToken();
    } catch (e) {
      developer.log('FCM delete token failed: $e', name: 'NotificationService');
    }
  }

  void dispose() {
    _notificationController.close();
  }
}
