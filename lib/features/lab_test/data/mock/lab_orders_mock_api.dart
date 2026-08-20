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
        'orderId': 60,
        'orderType': 'WALK_IN',
        'status': 'Confirmed',
        'reportStatus': 'NOT_AVAILABLE',
        'paymentMethod': 'CARD',
        'partnerRef': null,
        'discountCode': null,
        'lab': {'id': 33, 'name': 'Chughtai Lab', 'logoUrl': null},
        'partner': {
          'id': 13,
          'name': 'MedIQ',
          'logoUrl':
              'http://localhost:9000/main/019f5f96-27ef-73f7-8952-7afbd0cb367b.png',
        },
        'patient': {
          'name': 'hasan aaa',
          'age': 20,
          'gender': 'Male',
          'phone': '03012123411',
        },
        'tests': [
          {
            'name': 'glycosylated hemoglobin (hba1c)',
            'price': 2100,
            'status': 'PENDING',
          },
        ],
        'pricing': {
          'subtotal': 2100,
          'discount': 0,
          'homeSamplingFee': 0,
          'total': 2100,
          'currency': 'PKR',
        },
        'reports': [],
        'placedAt': '2026-08-20 19:00',
        'createdAt': '2026-08-20 19:00',
      },
      {
        'orderId': 59,
        'orderType': 'WALK_IN',
        'status': 'Payment Pending',
        'reportStatus': 'NOT_AVAILABLE',
        'paymentMethod': 'CARD',
        'partnerRef': null,
        'discountCode': null,
        'lab': {'id': 36, 'name': 'Excel Lab', 'logoUrl': null},
        'partner': {
          'id': 13,
          'name': 'MedIQ',
          'logoUrl':
              'http://localhost:9000/main/019f5f96-27ef-73f7-8952-7afbd0cb367b.png',
        },
        'patient': {
          'name': 'hasan aaa',
          'age': 20,
          'gender': 'Male',
          'phone': '03012123411',
        },
        'tests': [
          {
            'name': '24 hrs holter monitor',
            'price': 6900,
            'status': 'PENDING',
          },
        ],
        'pricing': {
          'subtotal': 6900,
          'discount': 0,
          'homeSamplingFee': 0,
          'total': 6900,
          'currency': 'PKR',
        },
        'reports': [],
        'placedAt': '2026-08-20 18:55',
        'createdAt': '2026-08-20 18:55',
      },
      {
        'orderId': 58,
        'orderType': 'HOME_SAMPLING',
        'status': 'Confirmed',
        'reportStatus': 'NOT_AVAILABLE',
        'paymentMethod': 'JAZZCASH',
        'partnerRef': null,
        'discountCode': null,
        'lab': {'id': 33, 'name': 'Chughtai Lab', 'logoUrl': null},
        'partner': {
          'id': 13,
          'name': 'MedIQ',
          'logoUrl':
              'http://localhost:9000/main/019f5f96-27ef-73f7-8952-7afbd0cb367b.png',
        },
        'patient': {
          'name': 'hasan aaa',
          'age': 20,
          'gender': 'Male',
          'phone': '923012123411',
        },
        'tests': [
          {
            'name':
                '1666 gtt / gct (75 grams glucose tolerance test ( for pregnantpatient) (fasting 75gm glucose 1 hours 2 hours)',
            'price': 1500,
            'status': 'PENDING',
          },
        ],
        'pricing': {
          'subtotal': 1500,
          'discount': 0,
          'homeSamplingFee': 0,
          'total': 1500,
          'currency': 'PKR',
        },
        'reports': [],
        'placedAt': '2026-08-20 17:45',
        'createdAt': '2026-08-20 17:45',
      },
      {
        'orderId': 9,
        'orderType': 'HOME_SAMPLING',
        'status': 'Confirmed',
        'reportStatus': 'NOT_AVAILABLE',
        'paymentMethod': 'COD',
        'partnerRef': '202P7NF7',
        'discountCode': '19910955',
        'lab': {'id': 1, 'name': 'Chughtai Lab', 'logoUrl': null},
        'partner': {
          'id': 12,
          'name': 'Oladoc',
          'logoUrl':
              'http://localhost:9000/main/019f5fa5-8c28-7759-91cb-4fb7c93bad91.png',
        },
        'patient': {
          'name': 'Bilal Ali',
          'age': 26,
          'gender': 'Female',
          'phone': '03012123411',
        },
        'tests': [
          {
            'name': 'Blood Sugar (Fasting)',
            'price': 500,
            'status': 'PENDING',
          },
        ],
        'pricing': {
          'subtotal': 500,
          'discount': 100,
          'homeSamplingFee': 0,
          'total': 400,
          'currency': 'PKR',
        },
        'reports': [],
        'placedAt': '2026-07-21 21:00',
        'createdAt': '2026-07-21 21:00',
      },
    ];

    final startIndex = ((page - 1) * limit).clamp(0, orders.length);
    final endIndex = (startIndex + limit).clamp(0, orders.length);
    final pageItems = orders.sublist(startIndex, endIndex);

    return {
      'success': true,
      'message': 'Lab orders retrieved',
      'data': {
        'data': pageItems,
        'page': page,
        'limit': limit,
        'total': orders.length,
      },
    };
  }

  Future<Map<String, dynamic>> getLabOrderDetailSuccessResponse({
    required String orderId,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    final list = await getLabOrdersSuccessResponse(page: 1, limit: 50);
    final data = list['data'];
    final items = data is Map ? data['data'] : null;
    Map<String, dynamic>? matched;
    if (items is List) {
      for (final item in items) {
        if (item is! Map) continue;
        final map = Map<String, dynamic>.from(item);
        final id = (map['orderId'] ?? '').toString();
        if (id == orderId) {
          matched = map;
          break;
        }
      }
      if (matched == null && items.isNotEmpty && items.first is Map) {
        matched = Map<String, dynamic>.from(items.first as Map);
      }
    }
    matched ??= {
      'orderId': int.tryParse(orderId) ?? orderId,
      'orderType': 'WALK_IN',
      'status': 'Confirmed',
      'reportStatus': 'NOT_AVAILABLE',
      'paymentMethod': 'CARD',
      'partnerRef': null,
      'discountCode': null,
      'lab': {'id': 33, 'name': 'Chughtai Lab', 'logoUrl': null},
      'partner': {'id': 13, 'name': 'MedIQ', 'logoUrl': null},
      'patient': {
        'name': 'Sample Patient',
        'age': 30,
        'gender': 'Male',
        'phone': '03001234567',
      },
      'tests': [
        {'name': 'Complete Blood Count (CBC)', 'price': 800, 'status': 'PENDING'},
      ],
      'pricing': {
        'subtotal': 800,
        'discount': 0,
        'homeSamplingFee': 0,
        'total': 800,
        'currency': 'PKR',
      },
      'reports': [],
      'placedAt': '2026-08-20 19:00',
      'createdAt': '2026-08-20 19:00',
    };

    return {
      'success': true,
      'message': 'Lab order retrieved',
      'data': matched,
    };
  }
}
