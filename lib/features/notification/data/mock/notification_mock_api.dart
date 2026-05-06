import '../../../../core/config/mock_config.dart';

class NotificationMockApi {
  static bool useMockResponses = MockConfig.enableMocks;

  Future<Map<String, dynamic>> getNotificationsSuccessResponse() async {
    await Future<void>.delayed(const Duration(milliseconds: 700));
    return {
      'success': true,
      'message': 'Notifications fetched successfully',
      'notifications': [
        {
          'id': 'n1',
          'title': 'Consultation Reminder',
          'message':
              'Your online consultation is scheduled for tomorrow at 10:00 AM.',
          'time': '4:56 pm',
          'date': 'Today, 16 April',
          'type': 'consultation',
          'isRead': false,
        },
        {
          'id': 'n2',
          'title': 'Medicine Order Placed',
          'message': 'Your medicine order has been placed successfully.',
          'time': '4:56 pm',
          'date': 'Today, 16 April',
          'type': 'medicine',
          'isRead': false,
        },
        {
          'id': 'n3',
          'title': 'Surgery Payment Due',
          'message':
              'Please complete payment for your surgery booking today.',
          'time': '4:56 pm',
          'date': 'Yesterday, 15 April',
          'type': 'surgery',
          'isRead': false,
        },
        {
          'id': 'n4',
          'title': 'Your Test Results Are Ready!',
          'message':
              'Your blood test results are ready. View them in lab tests.',
          'time': '4:56 pm',
          'date': 'Yesterday, 15 April',
          'type': 'lab',
          'isRead': false,
        },
        {
          'id': 'n5',
          'title': 'Appointment Confirmed with Dr. Arham',
          'message': 'Your appointment is booked for 24 March at 9:00 AM.',
          'time': '4:56 pm',
          'date': '16 April',
          'type': 'consultation',
          'isRead': false,
        },
      ],
    };
  }
}
