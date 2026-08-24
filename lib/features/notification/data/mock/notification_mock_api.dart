import '../../../../core/config/mock_config.dart';

class NotificationMockApi {
  static bool useMockResponses = MockConfig.enableNotificationMocks;

  Future<Map<String, dynamic>> getNotificationsSuccessResponse({
    int page = 1,
    int limit = 20,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    return {
      'success': true,
      'message': '',
      'data': {
        'items': [
          {
            'publicId': 'b1509cf9-afd9-42d9-a7bc-1822ce522c89',
            'type': 'BOOKING_CONFIRMED',
            'serviceType': 'LAB',
            'priority': 'NORMAL',
            'title': 'Lab Test Confirmed',
            'body': 'Your lab test booking is confirmed.',
            'deepLink': {
              'data': {
                'type': 'BOOKING_CONFIRMED',
                'audience': 'USER',
                'entity_id': '14',
                'entity_kind': 'LAB_ORDER',
                'service_type': 'LAB',
                'unified_order_id': '62',
              },
              'entity': {'id': 14, 'kind': 'LAB_ORDER'},
              'endpoint': 'mobile/lab-orders/14',
            },
            'isRead': true,
            'readAt': '2026-08-20T15:01:27.000Z',
            'createdAt': '2026-08-20T14:56:59.000Z',
          },
          {
            'publicId': 'b72ce9bc-51d8-45e4-8ffc-02d89160383a',
            'type': 'BOOKING_CONFIRMED',
            'serviceType': 'CONSULTATION',
            'priority': 'NORMAL',
            'title': 'Consultation Confirmed',
            'body': 'Your doctor consultation is confirmed.',
            'deepLink': {
              'data': {
                'type': 'BOOKING_CONFIRMED',
                'audience': 'USER',
                'entity_id': '31',
                'entity_kind': 'APPOINTMENT',
                'service_type': 'CONSULTATION',
                'unified_order_id': '55',
              },
              'entity': {'id': 31, 'kind': 'APPOINTMENT'},
              'endpoint': 'mobile/doctor-consultation/31',
            },
            'isRead': true,
            'readAt': '2026-08-20T14:38:34.000Z',
            'createdAt': '2026-08-20T12:27:16.000Z',
          },
          {
            'publicId': 'f0fed9e4-c5b9-41b8-8e7c-6a55f79e59ce',
            'type': 'BOOKING_CONFIRMED',
            'serviceType': 'PHARMACY',
            'priority': 'NORMAL',
            'title': 'Pharmacy Order Confirmed',
            'body': 'Your pharmacy order is confirmed.',
            'deepLink': {
              'data': {
                'type': 'BOOKING_CONFIRMED',
                'audience': 'USER',
                'endpoint': 'mobile/orders/e136ce81-e984-4df7-97dc-e1e3ef450bb1',
                'entity_id': '71',
                'entity_kind': 'PHARMACY_ORDER',
                'service_type': 'PHARMACY',
                'unified_order_id': '71',
              },
              'entity': {
                'id': 71,
                'kind': 'PHARMACY_ORDER',
                'publicId': 'e136ce81-e984-4df7-97dc-e1e3ef450bb1',
              },
              'endpoint': 'mobile/orders/e136ce81-e984-4df7-97dc-e1e3ef450bb1',
            },
            'isRead': true,
            'readAt': '2026-08-20T14:41:51.000Z',
            'createdAt': '2026-08-08T15:17:54.000Z',
          },
          {
            'publicId': 'mock-surgery-1',
            'type': 'BOOKING_CONFIRMED',
            'serviceType': 'SURGERY',
            'priority': 'NORMAL',
            'title': 'Surgery Booking Updated',
            'body': 'Your surgery booking details are ready.',
            'deepLink': {
              'data': {
                'entity_id': '12',
                'entity_kind': 'SURGERY_LEAD',
                'service_type': 'SURGERY',
                'unified_order_id': '12',
              },
              'entity': {'id': 12, 'kind': 'SURGERY_LEAD'},
              'endpoint': 'mobile/surgery/lead/12',
            },
            'isRead': false,
            'readAt': null,
            'createdAt': '2026-07-16T10:00:00.000Z',
          },
        ],
        'page': page,
        'limit': limit,
        'total': 4,
        'totalPages': 1,
      },
    };
  }

  Future<Map<String, dynamic>> markNotificationReadSuccessResponse({
    required String publicId,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    return {
      'success': true,
      'message': 'Notification marked as read',
      'publicId': publicId,
      'isRead': true,
    };
  }
}
