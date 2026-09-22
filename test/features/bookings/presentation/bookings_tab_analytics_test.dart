import 'package:apnaclinic/core/analytics/analytics_event_keys.dart';
import 'package:apnaclinic/core/analytics/analytics_service.dart';
import 'package:apnaclinic/core/di/dependency_injection.dart';
import 'package:apnaclinic/features/bookings/presentation/bookings_analytics.dart';
import 'package:apnaclinic/features/bookings/presentation/constants/bookings_tabs.dart';
import 'package:apnaclinic/features/bookings/presentation/widgets/bookings_tab_visibility_listener.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class _MockAnalyticsService implements AnalyticsService {
  final List<String> loggedEvents = [];

  @override
  Future<void> logEvent(String name, [Map<String, Object>? parameters]) async {
    loggedEvents.add(name);
  }

  @override
  Future<void> logScreenView({required String screenName, String? screenClass}) async {}

  @override
  Future<void> setUserId(String? userId) async {}

  @override
  Future<void> setUserProperty({required String name, required String? value}) async {}
}

void main() {
  late _MockAnalyticsService mockAnalytics;

  setUp(() {
    mockAnalytics = _MockAnalyticsService();
    if (sl.isRegistered<AnalyticsService>()) {
      sl.unregister<AnalyticsService>();
    }
    sl.registerSingleton<AnalyticsService>(mockAnalytics);
  });

  tearDown(() {
    if (sl.isRegistered<AnalyticsService>()) {
      sl.unregister<AnalyticsService>();
    }
  });

  group('BookingsAnalytics tab events', () {
    test('logMyBookingInstantDoc logs my_booking_instant_doc event', () async {
      BookingsAnalytics.logMyBookingInstantDoc();
      await Future<void>.delayed(Duration.zero);
      expect(mockAnalytics.loggedEvents, contains(AnalyticsEventKeys.myBookingInstantDoc));
      expect(mockAnalytics.loggedEvents.last, equals('my_booking_instant_doc'));
    });

    test('logMyBookingConsultation logs my_booking_consultation event', () async {
      BookingsAnalytics.logMyBookingConsultation();
      await Future<void>.delayed(Duration.zero);
      expect(mockAnalytics.loggedEvents, contains(AnalyticsEventKeys.myBookingConsultation));
      expect(mockAnalytics.loggedEvents.last, equals('my_booking_consultation'));
    });

    test('logMyBookingPharmacy logs my_booking_pharmacy event', () async {
      BookingsAnalytics.logMyBookingPharmacy();
      await Future<void>.delayed(Duration.zero);
      expect(mockAnalytics.loggedEvents, contains(AnalyticsEventKeys.myBookingPharmacy));
      expect(mockAnalytics.loggedEvents.last, equals('my_booking_pharmacy'));
    });

    test('logMyBookingLab logs my_booking_lab event', () async {
      BookingsAnalytics.logMyBookingLab();
      await Future<void>.delayed(Duration.zero);
      expect(mockAnalytics.loggedEvents, contains(AnalyticsEventKeys.myBookingLab));
      expect(mockAnalytics.loggedEvents.last, equals('my_booking_lab'));
    });

    test('logMyBookingSurgery logs my_booking_surgery event', () async {
      BookingsAnalytics.logMyBookingSurgery();
      await Future<void>.delayed(Duration.zero);
      expect(mockAnalytics.loggedEvents, contains(AnalyticsEventKeys.myBookingSurgery));
      expect(mockAnalytics.loggedEvents.last, equals('my_booking_surgery'));
    });

    test('logBookingTabByIndex logs correct event for all tab indices', () async {
      BookingsAnalytics.logBookingTabByIndex(BookingsTabs.instantDoctor);
      BookingsAnalytics.logBookingTabByIndex(BookingsTabs.pharmacy);
      BookingsAnalytics.logBookingTabByIndex(BookingsTabs.doctorConsultation);
      BookingsAnalytics.logBookingTabByIndex(BookingsTabs.labTest);
      BookingsAnalytics.logBookingTabByIndex(BookingsTabs.surgery);

      await Future<void>.delayed(Duration.zero);

      expect(mockAnalytics.loggedEvents, [
        'my_booking_instant_doc',
        'my_booking_pharmacy',
        'my_booking_consultation',
        'my_booking_lab',
        'my_booking_surgery',
      ]);
    });

    testWidgets('fires tab analytics event every time respected tab is opened or changed',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DefaultTabController(
              length: 5,
              child: Column(
                children: [
                  const TabBar(
                    tabs: [
                      Tab(text: 'Instant Doctor'),
                      Tab(text: 'Pharmacy'),
                      Tab(text: 'Consultation'),
                      Tab(text: 'Lab'),
                      Tab(text: 'Surgery'),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        BookingsTabVisibilityListener(
                          tabIndex: BookingsTabs.instantDoctor,
                          onVisible: BookingsAnalytics.logMyBookingInstantDoc,
                          child: const Text('Instant Doctor Content'),
                        ),
                        BookingsTabVisibilityListener(
                          tabIndex: BookingsTabs.pharmacy,
                          onVisible: BookingsAnalytics.logMyBookingPharmacy,
                          child: const Text('Pharmacy Content'),
                        ),
                        BookingsTabVisibilityListener(
                          tabIndex: BookingsTabs.doctorConsultation,
                          onVisible: BookingsAnalytics.logMyBookingConsultation,
                          child: const Text('Consultation Content'),
                        ),
                        BookingsTabVisibilityListener(
                          tabIndex: BookingsTabs.labTest,
                          onVisible: BookingsAnalytics.logMyBookingLab,
                          child: const Text('Lab Content'),
                        ),
                        BookingsTabVisibilityListener(
                          tabIndex: BookingsTabs.surgery,
                          onVisible: BookingsAnalytics.logMyBookingSurgery,
                          child: const Text('Surgery Content'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Initially on tab 0 (Instant Doctor)
      expect(mockAnalytics.loggedEvents, contains('my_booking_instant_doc'));
      expect(mockAnalytics.loggedEvents.length, 1);

      // Tap on Pharmacy tab
      await tester.tap(find.text('Pharmacy'));
      await tester.pumpAndSettle();

      expect(mockAnalytics.loggedEvents, contains('my_booking_pharmacy'));
      expect(mockAnalytics.loggedEvents.length, 2);

      // Tap on Consultation tab
      await tester.tap(find.text('Consultation'));
      await tester.pumpAndSettle();

      expect(mockAnalytics.loggedEvents, contains('my_booking_consultation'));
      expect(mockAnalytics.loggedEvents.length, 3);

      // Tap on Lab tab
      await tester.tap(find.text('Lab'));
      await tester.pumpAndSettle();

      expect(mockAnalytics.loggedEvents, contains('my_booking_lab'));
      expect(mockAnalytics.loggedEvents.length, 4);

      // Tap on Surgery tab
      await tester.tap(find.text('Surgery'));
      await tester.pumpAndSettle();

      expect(mockAnalytics.loggedEvents, contains('my_booking_surgery'));
      expect(mockAnalytics.loggedEvents.length, 5);

      // Tap back on Pharmacy tab
      await tester.tap(find.text('Pharmacy'));
      await tester.pumpAndSettle();

      expect(mockAnalytics.loggedEvents.length, 6);
      expect(mockAnalytics.loggedEvents.last, 'my_booking_pharmacy');
    });
  });
}
