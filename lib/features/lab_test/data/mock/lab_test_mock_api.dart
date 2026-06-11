import '../../../../core/config/mock_config.dart';

class LabTestMockApi {
  static bool useMockResponses = MockConfig.enableLabTestMocks;

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

  Future<Map<String, dynamic>> getLabTestDetailSuccessResponse({
    required int testId,
    required String cityId,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 600));

    return {
      'success': true,
      'message': 'Test detail retrieved',
      'code': 200,
      'data': {
        'id': testId,
        'name': 'Hemoglobin (Hb)',
        'description':
            'Measures the amount of hemoglobin in blood to detect anemia or polycythemia.',
        'sampleType': 'BLOOD',
        'fastingRequired': false,
        'fastingHours': null,
        'prescriptionRequired': false,
        'turnaroundHours': 4,
        'partners': [
          {
            'partnerId': 1,
            'partnerName': 'MedIQ',
            'partnerLogoUrl': 'ff835808-dd12-40c0-b1ca-25c1e3c84942.svg',
            'labs': [
              {
                'labId': 4,
                'labName': 'Chughtai Lab (CLL)',
                'labSlug': 'chughtai-lab-mediq',
                'logoUrl':
                    'http://bucket-route-minio.apps.jpocp.jazz.com.pk/apna-clinic/8d545fcc5545152eb461f346e5.svg',
                'rating': '4.50',
                'estimatedReportHours': 24,
                'supportsHomeSampling': true,
                'supportsWalkIn': true,
                'homeSamplingFee': '250.00',
                'pricing': {
                  'HOME_SAMPLING': {
                    'price': 470,
                    'discountPct': 0,
                    'finalPrice': 470,
                  },
                  'WALK_IN': {
                    'price': 320,
                    'discountPct': 0,
                    'finalPrice': 320,
                  },
                },
              },
              {
                'labId': 3,
                'labName': 'Nayab Labs',
                'labSlug': 'nayab-labs',
                'logoUrl':
                    'http://bucket-route-minio.apps.jpocp.jazz.com.pk/apna-clinic/a9db7b8c3b5ef31adeefdfacc2.svg',
                'rating': '4.30',
                'estimatedReportHours': 24,
                'supportsHomeSampling': true,
                'supportsWalkIn': true,
                'homeSamplingFee': '300.00',
                'pricing': {
                  'HOME_SAMPLING': {
                    'price': 400,
                    'discountPct': 5,
                    'finalPrice': 380,
                  },
                  'WALK_IN': {
                    'price': 250,
                    'discountPct': 5,
                    'finalPrice': 238,
                  },
                },
              },
            ],
          },
          {
            'partnerId': 2,
            'partnerName': 'Oladoc',
            'partnerLogoUrl': '8b64541a-a887-4689-bf40-7894fcfb515d.svg',
            'labs': [
              {
                'labId': 1,
                'labName': 'Chughtai Lab (CLL)',
                'labSlug': 'chughtai-lab',
                'logoUrl':
                    'http://bucket-route-minio.apps.jpocp.jazz.com.pk/apna-clinic/c4991fae115edbfb40d8b6bfb8.svg',
                'rating': '4.50',
                'estimatedReportHours': 24,
                'supportsHomeSampling': true,
                'supportsWalkIn': true,
                'homeSamplingFee': '250.00',
                'pricing': {
                  'HOME_SAMPLING': {
                    'price': 450,
                    'discountPct': 0,
                    'finalPrice': 450,
                  },
                  'WALK_IN': {
                    'price': 300,
                    'discountPct': 0,
                    'finalPrice': 300,
                  },
                },
              },
              {
                'labId': 2,
                'labName': 'Excel Lab',
                'labSlug': 'excel-lab',
                'logoUrl':
                    'http://bucket-route-minio.apps.jpocp.jazz.com.pk/apna-clinic/c9d22260aad9586a15ee41e325.svg',
                'rating': '4.20',
                'estimatedReportHours': 36,
                'supportsHomeSampling': true,
                'supportsWalkIn': true,
                'homeSamplingFee': '200.00',
                'pricing': {
                  'HOME_SAMPLING': {
                    'price': 420,
                    'discountPct': 10,
                    'finalPrice': 378,
                  },
                  'WALK_IN': {
                    'price': 280,
                    'discountPct': 10,
                    'finalPrice': 252,
                  },
                },
              },
            ],
          },
          {
            'partnerId': 3,
            'partnerName': 'Jazz',
            'partnerLogoUrl': null,
            'labs': [
              {
                'labId': 7,
                'labName': 'IDC',
                'labSlug': 'idc',
                'logoUrl':
                    'http://bucket-route-minio.apps.jpocp.jazz.com.pk/apna-clinic/c87fb89e69fccbe1121d2ed1f5.svg',
                'rating': '4.20',
                'estimatedReportHours': 36,
                'supportsHomeSampling': true,
                'supportsWalkIn': true,
                'homeSamplingFee': '200.00',
                'pricing': {
                  'HOME_SAMPLING': {
                    'price': 390,
                    'discountPct': 8,
                    'finalPrice': 359,
                  },
                  'WALK_IN': {
                    'price': 240,
                    'discountPct': 8,
                    'finalPrice': 221,
                  },
                },
              },
              {
                'labId': 6,
                'labName': 'Shaukat Khanum Labs',
                'labSlug': 'shaukat-khanum-labs',
                'logoUrl': null,
                'rating': '4.70',
                'estimatedReportHours': 48,
                'supportsHomeSampling': false,
                'supportsWalkIn': true,
                'homeSamplingFee': '0.00',
                'pricing': {
                  'WALK_IN': {
                    'price': 350,
                    'discountPct': 0,
                    'finalPrice': 350,
                  },
                },
              },
            ],
          },
        ],
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
