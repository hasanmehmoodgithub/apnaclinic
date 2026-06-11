import '../../../../core/config/mock_config.dart';

class LabTestMockApi {
  static bool useMockResponses = MockConfig.enableMocks;

  Future<Map<String, dynamic>> getLabTestCatalogSuccessResponse() async {
    await Future<void>.delayed(const Duration(milliseconds: 600));
    return {
      'success': true,
      'message': 'Lab test catalog fetched successfully',
      'cities': ['Islamabad', 'Lahore', 'Peshawar', 'Rawalpindi', 'Karachi'],
      'items': [
        {
          'id': 'cbc_dengue',
          'title': 'Complete Blood Count (CBC)',
          'sampleType': 'Blood',
          'labsSummary':
              'Chughtai Lab, Naya labs, Excel Lab, Islamabad Diagnostic Center (IDC)',
          'requirement': null,
          'discountedFee': 'Rs. 640/-',
          'originalFee': 'Rs. 800/-',
        },
        {
          'id': 'lft',
          'title': 'Liver Function Test (LFT)',
          'sampleType': 'Blood',
          'labsSummary':
              'Nayab labs, Chughtai Lab, Islamabad Diagnostic Center (IDC), Excel Lab',
          'requirement': null,
          'discountedFee': 'Rs. 1,850/-',
          'originalFee': '4000',
        },
        {
          'id': 'lipid_profile',
          'title': 'Lipid Profile',
          'sampleType': 'Blood',
          'labsSummary': 'Chughtai Lab',
          'requirement': 'Fasting',
          'discountedFee': 'Rs. 1,920/-',
          'originalFee': 'Rs. 2,400/-',
        },
        {
          'id': 'rft',
          'title': 'Renal Function Test (RFT)',
          'sampleType': 'Blood',
          'labsSummary':
              'Nayab labs, Chughtai Lab, Islamabad Diagnostic Center (IDC)',
          'requirement': null,
          'discountedFee': 'Rs. 2,150/-',
          'originalFee': '3000',
        },
      ],
      'requirementLines': [
        'Fast for 9-12 Hours before Appointment time',
        'Avoid Stenious Physical Activ ity the day of the appointment',
        'Ensure that you are NOTtaking any antibiotic medication course',
      ],
      'partners': [
        {
          'id': 'mediq',
          'name': 'Mediq',
          'logoUrl': 'assets/svg/lab_test/MedIQ_Logo.svg',
        },
        {
          'id': 'oladoc',
          'name': 'Oladoc',
          'logoUrl': 'assets/svg/lab_test/oladoc_ogo.svg',
        },
      ],
      'vendors': [
        {
          'id': 'idc',
          'name': 'IDC',
          'logoUrl': 'assets/svg/lab_test/IDC_logo.svg',
        },
        {
          'id': 'chughtai',
          'name': 'Chughtai Lab',
          'logoUrl': 'assets/svg/lab_test/chughtai_lab_logo.svg',
        },
        {
          'id': 'naya',
          'name': 'Naya Lab',
          'logoUrl': 'assets/svg/lab_test/naya_lab_logo.svg',
        },
        {
          'id': 'excel',
          'name': 'Excel Labs',
          'logoUrl': 'assets/svg/lab_test/excel_lab_logo.svg',
          'markUrl': null,
        },
      ],
      'pricing': {
        'discountedFee': 'Rs. 15,000/-',
        'originalFee': 'Rs. 80,000/-',
        'discountPercent': 15,
        'discountAmount': '12000.0',
        'discountCode': '12345678',
        'totalAmount': '68,000',
      },
    };
  }

  Future<Map<String, dynamic>> getLabTestsSuccessResponse({
    required String cityId,
    int page = 1,
    int limit = 20,
    String? search,
    String? labId,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 600));

    final allItems = <Map<String, dynamic>>[
      {
        'testId': 1,
        'testName': 'Complete Blood Count (CBC)',
        'sampleType': 'BLOOD',
        'fastingRequired': false,
        'turnaroundHours': 6,
        'description':
            'Measures overall health and detects a wide range of disorders including anemia, infection and leukemia.',
        'labs': [
          {
            'labId': 7,
            'price': 880,
            'labName': 'IDC',
            'labSlug': 'idc',
            'orderType': 'HOME_SAMPLING',
            'finalPrice': null,
            'discountPct': 12,
            'supportsWalkIn': 1,
            'homeSamplingFee': 200,
            'supportsHomeSampling': 1,
          },
          {
            'labId': 7,
            'price': 680,
            'labName': 'IDC',
            'labSlug': 'idc',
            'orderType': 'WALK_IN',
            'finalPrice': null,
            'discountPct': 12,
            'supportsWalkIn': 1,
            'homeSamplingFee': 200,
            'supportsHomeSampling': 1,
          },
          {
            'labId': 1,
            'price': 1000,
            'labName': 'Chughtai Lab (CLL)',
            'labSlug': 'chughtai-lab',
            'orderType': 'HOME_SAMPLING',
            'finalPrice': null,
            'discountPct': 10,
            'supportsWalkIn': 1,
            'homeSamplingFee': 250,
            'supportsHomeSampling': 1,
          },
        ],
      },
      {
        'testId': 4,
        'testName': 'Blood Sugar (Fasting)',
        'sampleType': 'BLOOD',
        'fastingRequired': true,
        'turnaroundHours': 4,
        'description':
            'Measures blood glucose levels after fasting to screen for diabetes.',
        'labs': [
          {
            'labId': 5,
            'price': 320,
            'labName': 'United Diagnostics',
            'labSlug': 'united-diagnostics',
            'orderType': 'HOME_SAMPLING',
            'finalPrice': null,
            'discountPct': 10,
            'supportsWalkIn': 1,
            'homeSamplingFee': 150,
            'supportsHomeSampling': 1,
          },
          {
            'labId': 2,
            'price': 230,
            'labName': 'Excel Lab',
            'labSlug': 'excel-lab',
            'orderType': 'WALK_IN',
            'finalPrice': null,
            'discountPct': 10,
            'supportsWalkIn': 1,
            'homeSamplingFee': 200,
            'supportsHomeSampling': 1,
          },
        ],
      },
      {
        'testId': 5,
        'testName': 'Liver Function Test (LFT)',
        'sampleType': 'BLOOD',
        'fastingRequired': false,
        'turnaroundHours': 8,
        'description':
            'Evaluates liver health by measuring enzymes, proteins, and bilirubin levels.',
        'labs': [
          {
            'labId': 3,
            'price': 900,
            'labName': 'Nayab Labs',
            'labSlug': 'nayab-labs',
            'orderType': 'WALK_IN',
            'finalPrice': null,
            'discountPct': 10,
            'supportsWalkIn': 1,
            'homeSamplingFee': 300,
            'supportsHomeSampling': 1,
          },
        ],
      },
    ];

    var items = allItems;
    final normalizedSearch = search?.trim().toLowerCase();
    if (normalizedSearch != null && normalizedSearch.isNotEmpty) {
      items = allItems
          .where(
            (item) => (item['testName'] as String)
                .toLowerCase()
                .contains(normalizedSearch),
          )
          .toList(growable: false);
    }

    if (labId != null && labId.trim().isNotEmpty) {
      final parsedLabId = int.tryParse(labId);
      if (parsedLabId != null) {
        items = items
            .map((item) {
              final labs = (item['labs'] as List)
                  .where((lab) => (lab as Map)['labId'] == parsedLabId)
                  .toList(growable: false);
              return {...item, 'labs': labs};
            })
            .where((item) => (item['labs'] as List).isNotEmpty)
            .toList(growable: false);
      }
    }

    return {
      'success': true,
      'message': 'Tests retrieved',
      'code': 200,
      'data': {
        'items': items,
        'total': items.length,
        'page': page,
        'limit': limit,
        'totalPages': 1,
      },
      'timestamp': DateTime.now().toUtc().toIso8601String(),
    };
  }

  Future<Map<String, dynamic>> getLabTestViewDetailsSuccessResponse() async {
    await Future<void>.delayed(const Duration(milliseconds: 700));
    return {
      'success': true,
      'message': 'Lab test view details fetched successfully',
      'data': {
        'patientName': 'Zubair Abbasi',
        'orderNo': '155850',
        'bookingDate': '2026-04-21',
        'status': 'Confirmed',
        'note':
            'Your report will be ready in 24 hours after the sample is collected.',
      },
    };
  }
}
