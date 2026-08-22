import '../../../../core/config/mock_config.dart';

class SurgeryLeadsMockApi {
  static bool useMockResponses = MockConfig.enableSurgeryMocks;

  Future<Map<String, dynamic>> getSurgeryLeadsSuccessResponse({
    int page = 1,
    int limit = 20,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));

    final start = (page - 1) * limit;
    final end = (start + limit).clamp(0, _mockItems.length);
    final pageItems = start >= _mockItems.length
        ? const <Map<String, dynamic>>[]
        : _mockItems.sublist(start, end);

    return {
      'success': true,
      'message': 'Surgery leads retrieved',
      'code': 200,
      'data': {
        'items': pageItems,
        'total': _mockItems.length,
        'page': page,
        'limit': limit,
        'totalPages': limit <= 0
            ? 0
            : (_mockItems.isEmpty
                ? 0
                : ((_mockItems.length + limit - 1) ~/ limit)),
      },
      'timestamp': DateTime.now().toUtc().toIso8601String(),
    };
  }

  Future<Map<String, dynamic>> getSurgeryLeadSuccessResponse({
    required int leadId,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 400));

    Map<String, dynamic>? match;
    for (final item in _mockItems) {
      if (item['leadId'] == leadId) {
        match = item;
        break;
      }
    }
    final lead = Map<String, dynamic>.from(
      match ??
          {
            ..._mockItems.first,
            'leadId': leadId,
          },
    );
    final provider = lead['provider'];
    if (provider is Map && provider['logoUrl'] == null) {
      lead['provider'] = {
        ...Map<String, dynamic>.from(provider),
        'logoUrl':
            'http://bucket-route-minio.apps.jpocp.jazz.com.pk/apna-clinic/019f6574-0e42-711a-beff-919f80951036.png',
      };
    }

    return {
      'success': true,
      'message': 'Surgery lead retrieved',
      'code': 200,
      'data': lead,
      'timestamp': DateTime.now().toUtc().toIso8601String(),
    };
  }

  static const List<Map<String, dynamic>> _mockItems = [
    {
      'leadId': 2,
      'surgeryId': 48,
      'surgeryType': 'Dental Implants (Full Mouth)',
      'subSurgeryType': 'Dental Implants (Full Mouth)',
      'provider': {'id': 2, 'name': 'Oladoc'},
      'doctor': {
        'id': 6766,
        'name': 'Dr. Aqsa Khawar',
        'specialty': 'Dentist',
        'education': null,
        'hospitalName': 'Dental Care Clinic',
      },
      'status': 'PENDING',
      'paymentAllowed': false,
      'leadCreatedDate': '2026-07-15',
      'leadCreatedTime': '02:51 PM',
      'leadCreatedAt': '2026-07-15 02:51 PM',
      'confirmedDate': null,
      'scheduledDate': null,
      'patient': {
        'name': 'Bilal Ahmad',
        'age': 26,
        'gender': 'MALE',
        'phone': '923355645857',
        'emergencyPhone': '923211234567',
      },
      'pricing': {
        'fee': 250000,
        'discount': 25000,
        'total': 225000,
        'currency': 'PKR',
      },
    },
    {
      'leadId': 1,
      'surgeryId': 48,
      'surgeryType': 'Dental Implants (Full Mouth)',
      'subSurgeryType': 'Dental Implants (Full Mouth)',
      'provider': {'id': 2, 'name': 'Oladoc'},
      'doctor': {
        'id': 6766,
        'name': 'Dr. Aqsa Khawar',
        'specialty': 'Dentist',
        'education': null,
        'hospitalName': 'Dental Care Clinic',
      },
      'status': 'PAID',
      'paymentAllowed': false,
      'leadCreatedDate': '2026-07-15',
      'leadCreatedTime': '11:27 AM',
      'leadCreatedAt': '2026-07-15 11:27 AM',
      'confirmedDate': '2026-07-15 07:13 AM',
      'scheduledDate': '2026-07-20',
      'scheduledStartTime': '8:00 PM',
      'scheduledEndTime': '11:00 PM',
      'patient': {
        'name': 'Bilal Ahmad',
        'age': 26,
        'gender': 'MALE',
        'phone': '923355645857',
        'emergencyPhone': '923211234567',
      },
      'pricing': {
        'fee': 250000,
        'discount': 40000,
        'total': 210000,
        'currency': 'PKR',
      },
    },
  ];
}
