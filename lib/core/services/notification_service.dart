import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:go_router/go_router.dart';
import '../flavor/flavor_config.dart';
import '../router/app_router.dart';
import 'notification_background_handler.dart';

/// Notification payload structure
class NotificationPayload {
  final String? title;
  final String? body;
  final String? route; // Custom route to navigate
  final Map<String, dynamic>? data; // Additional data

  NotificationPayload({this.title, this.body, this.route, this.data});

  factory NotificationPayload.fromRemoteMessage(RemoteMessage message) {
    return NotificationPayload(
      title: message.notification?.title,
      body: message.notification?.body,
      route: message.data['route'] as String?,
      data: message.data,
    );
  }
}

/// Notification Service - Handles Firebase Cloud Messaging
/// Supports: Foreground, Background, and Terminated states
class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();
  final StreamController<NotificationPayload> _notificationController =
      StreamController<NotificationPayload>.broadcast();

  /// Stream of notifications
  Stream<NotificationPayload> get notificationStream =>
      _notificationController.stream;

  /// FCM token
  String? _fcmToken;

  /// Get FCM token
  String? get fcmToken => _fcmToken;

  /// Initialize notification service
  Future<void> initialize() async {
    try {
      // Initialize local notifications
      await _initializeLocalNotifications();

      // Request permissions
      await _requestPermissions();

      // Get FCM token
      await _getFCMToken();

      // Setup foreground message handler
      _setupForegroundHandler();

      // Setup background message handler (must be top-level function)
      FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

      // Handle notification when app is opened from terminated state
      _handleInitialMessage();

      // Listen for token refresh
      _firebaseMessaging.onTokenRefresh.listen((newToken) {
        _fcmToken = newToken;
        if (kDebugMode) {
          print('FCM Token refreshed: $newToken');
        }
      });

      // Auto-subscribe to test topic in debug/staging/development
      if (kDebugMode || FlavorConfig.isDevelopment || FlavorConfig.isStaging) {
        await subscribeToTopic('TestNotification');
        if (kDebugMode) {
          print('Auto-subscribed to TestNotification topic for testing');
        }
      }

      if (kDebugMode) {
        print('NotificationService initialized successfully');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error initializing NotificationService: $e');
      }
    }
  }

  /// Initialize local notifications
  Future<void> _initializeLocalNotifications() async {
    try {
      // Android initialization settings
      const androidSettings = AndroidInitializationSettings(
        '@mipmap/ic_launcher',
      );

      // iOS initialization settings
      const iosSettings = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      );

      // Initialization settings
      const initSettings = InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      );

      // Initialize plugin
      await _localNotifications.initialize(
        initSettings,
        onDidReceiveNotificationResponse: _onNotificationTapped,
      );

      // Create notification channel for Android
      await _createNotificationChannel();

      if (kDebugMode) {
        print('Local notifications initialized');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error initializing local notifications: $e');
      }
    }
  }

  /// Create notification channel for Android
  Future<void> _createNotificationChannel() async {
    const androidChannel = AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // name
      description: 'This channel is used for important notifications.',
      importance: Importance.high,
      playSound: true,
      enableVibration: true,
    );

    await _localNotifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(androidChannel);
  }

  /// Handle notification tap
  void _onNotificationTapped(NotificationResponse response) {
    if (kDebugMode) {
      print('Notification tapped: ${response.id}');
      print('Payload: ${response.payload}');
    }

    // Parse payload if it contains route information
    if (response.payload != null && response.payload!.isNotEmpty) {
      try {
        // If payload is JSON, parse it
        // Otherwise, treat it as route name
        final route = response.payload;
        if (route != null && route.isNotEmpty) {
          _navigateToRoute(route, null);
        }
      } catch (e) {
        if (kDebugMode) {
          print('Error parsing notification payload: $e');
        }
      }
    }
  }

  /// Request notification permissions
  Future<void> _requestPermissions() async {
    try {
      final settings = await _firebaseMessaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );

      if (kDebugMode) {
        print(
          'Notification permission status: ${settings.authorizationStatus}',
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error requesting notification permissions: $e');
      }
    }
  }

  /// Get FCM token
  Future<void> _getFCMToken() async {
    try {
      _fcmToken = await _firebaseMessaging.getToken();
      if (kDebugMode) {
        print('FCM Token: $_fcmToken');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error getting FCM token: $e');
      }
    }
  }

  /// Setup foreground message handler
  void _setupForegroundHandler() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      if (kDebugMode) {
        print('Foreground notification received: ${message.messageId}');
        print('Title: ${message.notification?.title}');
        print('Body: ${message.notification?.body}');
        print('Data: ${message.data}');
      }

      // Create payload
      final payload = NotificationPayload.fromRemoteMessage(message);

      // Emit to stream
      _notificationController.add(payload);

      // Show local notification
      await _showLocalNotification(payload);
    });
  }

  /// Handle notification when app is opened from terminated state
  Future<void> _handleInitialMessage() async {
    try {
      final initialMessage = await _firebaseMessaging.getInitialMessage();
      if (initialMessage != null) {
        if (kDebugMode) {
          print('App opened from terminated state via notification');
        }

        final payload = NotificationPayload.fromRemoteMessage(initialMessage);
        _notificationController.add(payload);

        // Navigate after a delay to ensure app is fully initialized
        Future.delayed(const Duration(seconds: 1), () {
          _navigateToRoute(payload.route, payload.data);
        });
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error handling initial message: $e');
      }
    }
  }

  /// Handle notification when app is in background
  /// This is called automatically by Firebase when app is opened from background
  void handleBackgroundMessage(RemoteMessage message) {
    if (kDebugMode) {
      print('Background notification received: ${message.messageId}');
      print('Title: ${message.notification?.title}');
      print('Body: ${message.notification?.body}');
      print('Data: ${message.data}');
    }

    final payload = NotificationPayload.fromRemoteMessage(message);
    _notificationController.add(payload);

    // Navigate to route
    Future.delayed(const Duration(milliseconds: 500), () {
      _navigateToRoute(payload.route, payload.data);
    });
  }

  /// Setup background message handler (called when app is opened from background)
  void setupBackgroundMessageHandler() {
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      if (kDebugMode) {
        print('App opened from background via notification');
      }

      handleBackgroundMessage(message);
    });
  }

  /// Show local notification
  Future<void> _showLocalNotification(NotificationPayload payload) async {
    try {
      const androidDetails = AndroidNotificationDetails(
        'high_importance_channel',
        'High Importance Notifications',
        channelDescription: 'This channel is used for important notifications.',
        importance: Importance.high,
        priority: Priority.high,
        playSound: true,
        enableVibration: true,
        icon: '@mipmap/ic_launcher',
      );

      const iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      const notificationDetails = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      // Use route as payload for navigation when tapped
      final payloadString = payload.route ?? '';

      await _localNotifications.show(
        payload.hashCode, // Unique ID
        payload.title ?? 'Notification',
        payload.body ?? '',
        notificationDetails,
        payload: payloadString, // Pass route as payload
      );

      if (kDebugMode) {
        print('Local notification shown: ${payload.title} - ${payload.body}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error showing local notification: $e');
      }
    }
  }

  /// Show local notification manually
  Future<void> showLocalNotification({
    required String title,
    required String body,
    String? route,
    Map<String, dynamic>? data,
  }) async {
    final payload = NotificationPayload(
      title: title,
      body: body,
      route: route,
      data: data,
    );
    await _showLocalNotification(payload);
  }

  /// Global navigator key for navigation
  static GlobalKey<NavigatorState>? navigatorKey;

  /// Set navigator key (call this in main.dart)
  static void setNavigatorKey(GlobalKey<NavigatorState> key) {
    navigatorKey = key;
  }

  /// Navigate to custom route based on notification data
  void _navigateToRoute(String? route, Map<String, dynamic>? data) {
    if (route == null || route.isEmpty) {
      if (kDebugMode) {
        print('No route specified in notification');
      }
      return;
    }

    try {
      // Use navigator key if available
      if (navigatorKey?.currentContext != null) {
        final context = navigatorKey!.currentContext!;

        // Build route path
        String routePath = route.startsWith('/') ? route : '/$route';

        // Add query parameters if data exists
        if (data != null && data.isNotEmpty) {
          final uri = Uri(
            path: routePath,
            queryParameters: data.map(
              (key, value) => MapEntry(key, value.toString()),
            ),
          );
          routePath = uri.toString();
        }

        if (kDebugMode) {
          print('Navigating to route: $routePath');
        }

        // Navigate using GoRouter
        context.go(routePath);
      } else {
        // Fallback: Use router directly
        try {
          String routePath = route.startsWith('/') ? route : '/$route';
          if (data != null && data.isNotEmpty) {
            final uri = Uri(
              path: routePath,
              queryParameters: data.map(
                (key, value) => MapEntry(key, value.toString()),
              ),
            );
            routePath = uri.toString();
          }
          AppRouter.router.go(routePath);
        } catch (e) {
          if (kDebugMode) {
            print('Error navigating to route: $e');
          }
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error navigating to route: $e');
      }
    }
  }

  /// Navigate to route manually (can be called from UI)
  void navigateToRoute(String? route, {Map<String, dynamic>? data}) {
    _navigateToRoute(route, data);
  }

  /// Subscribe to topic
  Future<void> subscribeToTopic(String topic) async {
    try {
      await _firebaseMessaging.subscribeToTopic(topic);
      if (kDebugMode) {
        print('Subscribed to topic: $topic');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error subscribing to topic: $e');
      }
    }
  }

  /// Unsubscribe from topic
  Future<void> unsubscribeFromTopic(String topic) async {
    try {
      await _firebaseMessaging.unsubscribeFromTopic(topic);
      if (kDebugMode) {
        print('Unsubscribed from topic: $topic');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error unsubscribing from topic: $e');
      }
    }
  }

  /// Delete FCM token
  Future<void> deleteToken() async {
    try {
      await _firebaseMessaging.deleteToken();
      _fcmToken = null;
      if (kDebugMode) {
        print('FCM token deleted');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error deleting FCM token: $e');
      }
    }
  }

  /// Dispose
  void dispose() {
    _notificationController.close();
  }
}
