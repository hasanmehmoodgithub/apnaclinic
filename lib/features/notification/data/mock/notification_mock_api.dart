import '../../../../core/config/mock_config.dart';

class NotificationMockApi {
  static bool useMockResponses = MockConfig.enableNotificationMocks;

  Future<Map<String, dynamic>> getNotificationsSuccessResponse({
    int page = 1,
    int limit = 20,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    return {
      'items': [
        {
          'publicId': 'ad1ed3e0-f8db-48a9-845e-f8a94f16d591',
          'type': 'BOOKING_FAILED',
          'serviceType': 'LAB',
          'priority': 'HIGH',
          'title': 'Lab Test Not Confirmed',
          'body':
              'We could not confirm your lab test booking. Please contact support.',
          'deepLink': {
            'data': {
              'type': 'BOOKING_FAILED',
              'audience': 'USER',
              'priority': 'HIGH',
              'entity_id': '3',
              'entity_kind': 'LAB_ORDER',
              'service_type': 'LAB',
              'unified_order_id': '102',
            },
            'entity': {'id': 3, 'kind': 'LAB_ORDER'},
            'endpoint': 'mobile/lab-orders/3',
          },
          'isRead': false,
          'readAt': null,
          'createdAt': '2026-07-17T21:10:02.000Z',
        },
        {
          'publicId': '43cfe14a-1599-4303-a1fc-9a771367f59b',
          'type': 'BOOKING_CONFIRMED',
          'serviceType': 'CONSULTATION',
          'priority': 'NORMAL',
          'title': 'Consultation Confirmed',
          'body': 'Your doctor consultation is confirmed.',
          'deepLink': {
            'data': {
              'type': 'BOOKING_CONFIRMED',
              'audience': 'USER',
              'entity_id': '49',
              'entity_kind': 'APPOINTMENT',
              'service_type': 'CONSULTATION',
              'unified_order_id': '101',
            },
            'entity': {'id': 49, 'kind': 'APPOINTMENT'},
            'endpoint': 'mobile/doctor-consultation/49',
          },
          'isRead': true,
          'readAt': '2026-07-17T21:07:54.000Z',
          'createdAt': '2026-07-17T21:06:02.000Z',
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
            },
            'entity': {'id': 12, 'kind': 'SURGERY_LEAD'},
            'endpoint': 'mobile/surgery/lead/12',
          },
          'isRead': false,
          'readAt': null,
          'createdAt': '2026-07-16T10:00:00.000Z',
        },
        {
          'publicId': 'mock-pharmacy-1',
          'type': 'ORDER_PLACED',
          'serviceType': 'PHARMACY',
          'priority': 'NORMAL',
          'title': 'Pharmacy Order Placed',
          'body': 'Your pharmacy order has been placed successfully.',
          'deepLink': {
            'data': {
              'entity_id': '1223',
              'entity_kind': 'PHARMACY_ORDER',
              'service_type': 'PHARMACY',
            },
            'entity': {'id': 1223, 'kind': 'PHARMACY_ORDER'},
            'endpoint': 'mobile/pharmacy/orders/1223',
          },
          'isRead': false,
          'readAt': null,
          'createdAt': '2026-07-15T08:30:00.000Z',
        },
      ],
      'page': page,
      'limit': limit,
      'total': 4,
      'totalPages': 1,
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
