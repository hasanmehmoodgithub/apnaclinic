import '../../../../core/config/mock_config.dart';

class SurgeryCheckoutMockApi {
  static bool useMockResponses = MockConfig.enableSurgeryMocks;

  Future<Map<String, dynamic>> submitSurgeryBooking({
    required String patientName,
    required String age,
    required String contactNumber,
    required String emergencyContact,
    required String surgeryName,
    required String doctorName,
    required String hospitalName,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 600));

    return {
      'success': true,
      'message': 'Surgery booking submitted successfully',
      'data': {
        'bookingId': 'SB-2026-0001',
        'patientName': patientName,
        'age': age,
        'contactNumber': contactNumber,
        'emergencyContact': emergencyContact,
        'surgeryName': surgeryName,
        'doctorName': doctorName,
        'hospitalName': hospitalName,
        'submittedAt': DateTime.now().toIso8601String(),
      },
    };
  }
}
