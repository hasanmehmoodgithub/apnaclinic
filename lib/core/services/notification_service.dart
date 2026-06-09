import 'dart:async';
import 'dart:developer' as developer;

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../firebase/firebase_bootstrap.dart';
import '../flavor/flavor_config.dart';
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
    final route = (data['route'] ?? data['deepLink'] ?? data['screen'])
        ?.toString()
        .trim();
    return NotificationPayload(
      title: message.notification?.title ?? data['title']?.toString(),
      body: message.notification?.body ?? data['body']?.toString(),
      route: route?.isNotEmpty == true ? route : null,
      data: data,
    );
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
  bool _initialized = false;

  bool get isInitialized => _initialized;

  String? get fcmToken => _fcmToken;

  Future<void> initialize() async {
    if (_initialized) return;
    if (!FirebaseBootstrap.isInitialized) {
      developer.log(
        'NotificationService skipped: Firebase is not initialized.',
        name: 'NotificationService',
      );
      return;
    }

    try {
      _firebaseMessaging = FirebaseMessaging.instance;
      await _initializeLocalNotifications();
      await _requestPermissions();
      await _getFCMToken();
      _setupForegroundHandler();
      FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
      await _handleInitialMessage();
      _firebaseMessaging?.onTokenRefresh.listen(_persistToken);
      await _subscribeDebugTopicIfNeeded();
      _initialized = true;
      developer.log(
        'NotificationService initialized',
        name: 'NotificationService',
      );
    } catch (e, stackTrace) {
      developer.log(
        'NotificationService init failed: $e',
        name: 'NotificationService',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  void setupBackgroundMessageHandler() {
    if (!_initialized || _firebaseMessaging == null) return;

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      final payload = NotificationPayload.fromRemoteMessage(message);
      _notificationController.add(payload);
      _navigateToRoute(payload.route, payload.data);
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
        final route = response.payload?.trim();
        if (route != null && route.isNotEmpty) {
          _navigateToRoute(route, const {});
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

  Future<void> _requestPermissions() async {
    await _firebaseMessaging?.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    await _localNotifications
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >()
        ?.requestPermissions(alert: true, badge: true, sound: true);

    await _localNotifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestNotificationsPermission();
  }

  Future<void> _getFCMToken() async {
    try {
      _fcmToken = await _firebaseMessaging?.getToken();
      await _persistToken(_fcmToken);
    } catch (e) {
      developer.log('FCM token error: $e', name: 'NotificationService');
    }
  }

  Future<void> _persistToken(String? token) async {
    if (token == null || token.isEmpty) return;
    _fcmToken = token;
    await _appPref.setString(AppPrefKeys.fcmToken, token);
    developer.log('FCM token updated', name: 'NotificationService');
  }

  void _setupForegroundHandler() {
    FirebaseMessaging.onMessage.listen((message) async {
      final payload = NotificationPayload.fromRemoteMessage(message);
      _notificationController.add(payload);
      await _showLocalNotification(payload);
    });
  }

  Future<void> _handleInitialMessage() async {
    final initialMessage = await _firebaseMessaging?.getInitialMessage();
    if (initialMessage == null) return;

    final payload = NotificationPayload.fromRemoteMessage(initialMessage);
    _notificationController.add(payload);
    Future<void>.delayed(const Duration(milliseconds: 900), () {
      _navigateToRoute(payload.route, payload.data);
    });
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
      payload: payload.route ?? '',
    );
  }

  void _navigateToRoute(String? route, Map<String, dynamic> data) {
    if (route == null || route.isEmpty) return;

    var routePath = route.startsWith('/') ? route : AppRoutes.path(route);
    if (data.isNotEmpty) {
      routePath = Uri(
        path: routePath,
        queryParameters: data.map(
          (key, value) => MapEntry(key, value.toString()),
        ),
      ).toString();
    }

    try {
      AppRouter.router.go(routePath);
    } catch (e) {
      developer.log(
        'Notification navigation failed: $e',
        name: 'NotificationService',
      );
    }
  }

  Future<void> _subscribeDebugTopicIfNeeded() async {
    if (!kDebugMode &&
        !FlavorConfig.isDevelopment &&
        !FlavorConfig.isStaging) {
      return;
    }
    await subscribeToTopic('TestNotification');
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

  Future<void> deleteToken() async {
    if (_firebaseMessaging == null) return;
    try {
      await _firebaseMessaging!.deleteToken();
      _fcmToken = null;
      await _appPref.remove(AppPrefKeys.fcmToken);
    } catch (e) {
      developer.log('FCM delete token failed: $e', name: 'NotificationService');
    }
  }

  void dispose() {
    _notificationController.close();
  }
}
