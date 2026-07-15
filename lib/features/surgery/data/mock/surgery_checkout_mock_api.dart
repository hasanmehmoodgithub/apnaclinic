import '../../../../core/config/mock_config.dart';

class SurgeryCheckoutMockApi {
  static bool useMockResponses = MockConfig.enableSurgeryMocks;

  Future<Map<String, dynamic>> submitSurgeryBooking({
    required int doctorId,
    required int surgeryId,
    required int packageId,
    required int cityId,
    required String patientName,
    required int age,
    required String gender,
    required String phone,
    required String emergencyPhone,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 600));

    return {
      'success': true,
      'code': 200,
      'message': 'Surgery booking submitted successfully',
      'data': {
        'bookingId': 'SB-2026-0001',
        'doctorId': doctorId,
        'surgeryId': surgeryId,
        'packageId': packageId,
        'cityId': cityId,
        'patient': {
          'name': patientName,
          'age': age,
          'gender': gender,
          'phone': phone,
          'emergencyPhone': emergencyPhone,
        },
        'submittedAt': DateTime.now().toIso8601String(),
      },
    };
  }

  Future<Map<String, dynamic>> bookSurgery({
    required int leadId,
    required String paymentMethod,
    required String msisdn,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 600));

    return {
      'success': true,
      'code': 200,
      'message': 'Surgery booked successfully',
      'data': {
        'leadId': leadId,
        'paymentMethod': paymentMethod,
        'msisdn': msisdn,
      },
    };
  }
}
