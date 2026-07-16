import '../../../../core/config/mock_config.dart';

class LabOrdersMockApi {
  static bool useMockResponses = MockConfig.enableLabTestMocks;

  Future<Map<String, dynamic>> getLabOrdersSuccessResponse({
    int page = 1,
    int limit = 20,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 250));

    final orders = <Map<String, dynamic>>[
      {
        'orderId': 1,
        'publicId': '7adcea8f-dc64-4cf6-9aa0-761171ccad6f',
        'orderType': 'WALK_IN',
        'status': 'PLACED',
        'reportStatus': 'NOT_AVAILABLE',
        'paymentMethod': 'CARD',
        'partnerRef': null,
        'discountCode': null,
        'lab': {
          'id': 1,
          'name': 'Chughtai Lab',
          'logoUrl':
              'http://bucket-route-minio.apps.jpocp.jazz.com.pk/apna-clinic/d23b9145-c84c-45ce-97ae-4c2ab662a8dd.svg',
        },
        'partner': {
          'id': 2,
          'name': 'Oladoc',
          'logoUrl':
              'http://bucket-route-minio.apps.jpocp.jazz.com.pk/apna-clinic/019f6574-0e42-711a-beff-919f80951036.png',
        },
        'patient': {
          'name': 'Iram Iram',
          'age': 39,
          'gender': 'Female',
          'phone': '03035613453',
        },
        'tests': [
          {'name': 'Complete Blood Count (CBC)', 'price': 800, 'status': 'PENDING'},
        ],
        'pricing': {
          'subtotal': 800,
          'discount': 160,
          'homeSamplingFee': 0,
          'total': 640,
          'currency': 'PKR',
        },
        'reports': [],
        'invoice':
            'https://medicalguidelines.msf.org/sites/default/files/2026-05/guideline-170-en.pdf',
        'placedAt': '2026-07-16 06:31',
        'createdAt': '2026-07-16 11:31',
      },
      {
        'orderId': 2,
        'publicId': 'b1a2c3d4-1111-2222-3333-444455556666',
        'orderType': 'HOME_SAMPLING',
        'status': 'COMPLETED',
        'reportStatus': 'AVAILABLE',
        'paymentMethod': 'CASH',
        'partnerRef': null,
        'discountCode': 'SAVE10',
        'lab': {
          'id': 2,
          'name': 'Islamabad Diagnostic Centre',
          'logoUrl':
              'http://bucket-route-minio.apps.jpocp.jazz.com.pk/apna-clinic/d23b9145-c84c-45ce-97ae-4c2ab662a8dd.svg',
        },
        'partner': {
          'id': 2,
          'name': 'Oladoc',
          'logoUrl':
              'http://bucket-route-minio.apps.jpocp.jazz.com.pk/apna-clinic/019f6574-0e42-711a-beff-919f80951036.png',
        },
        'patient': {
          'name': 'Ahmed Raza',
          'age': 28,
          'gender': 'Male',
          'phone': '03011234567',
        },
        'tests': [
          {'name': 'Lipid Profile', 'price': 2400, 'status': 'COMPLETED'},
        ],
        'pricing': {
          'subtotal': 2400,
          'discount': 480,
          'homeSamplingFee': 200,
          'total': 2120,
          'currency': 'PKR',
        },
        'reports': ['https://example.com/reports/lipid-profile.pdf'],
        'invoice':
            'https://medicalguidelines.msf.org/sites/default/files/2026-05/guideline-170-en.pdf',
        'placedAt': '2025-02-11 09:15',
        'createdAt': '2025-02-11 09:15',
      },
    ];

    final startIndex = ((page - 1) * limit).clamp(0, orders.length);
    final endIndex = (startIndex + limit).clamp(0, orders.length);
    final pageItems = orders.sublist(startIndex, endIndex);

    return {
      'success': true,
      'message': 'Lab orders retrieved',
      'code': 200,
      'data': {
        'data': pageItems,
        'page': page,
        'limit': limit,
        'total': orders.length,
      },
      'timestamp': DateTime.now().toUtc().toIso8601String(),
    };
  }
}
