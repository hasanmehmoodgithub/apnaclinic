import '../../../../core/config/mock_config.dart';

class ProMockApi {
  /// Toggle mock responses for ApnaClinic Pro catalog API.
  static bool useMockResponses = MockConfig.enableProMocks;

  /// Flip to exercise active-member UI (`isPro: true`) vs subscribe UI.
  static bool mockAsActivePro = true;

  Future<Map<String, dynamic>> unsubscribeSuccessResponse() async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    return {
      'success': true,
      'message': 'Pro subscription cancelled',
      'data': {
        'planCode': 'PRO',
      },
    };
  }

  Future<Map<String, dynamic>> subscribeSuccessResponse() async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    return {
      'message': 'Pro subscription created',
      'data': {
        'planCode': 'PRO',
        'planPriceCode': 'PRO_30D',
      },
    };
  }

  Future<Map<String, dynamic>> getCatalogSuccessResponse() async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    if (mockAsActivePro) {
      return _activeCatalog();
    }
    return _subscribeCatalog();
  }

  Map<String, dynamic> _subscribeCatalog() {
    return {
      'success': true,
      'message': 'Membership catalog retrieved',
      'code': 200,
      'data': {
        'title': 'ApnaClinic Pro',
        'tagline':
            'Get higher discounts on doctors, labs & free medicine delivery',
        'logoUrl': null,
        'bannerUrl': 'https://iili.io/nfTySKg.png',
        'ctaLabel': 'Subscribe to Pro',
        'benefitsTitle': 'Benefits',
        'basicColumnLabel': 'Basic',
        'proColumnLabel': 'pro',
        'planSectionTitle': 'Select a plan',
        'membership': {
          'isPro': false,
          'status': 'none',
          'planId': null,
          'planName': null,
          'startedAt': null,
          'expiresAt': null,
          'autoRenew': false,
        },
        'allowedActions': {
          'canSubscribe': true,
          'canUnsubscribe': false,
          'canResubscribe': false,
          'canChangePlan': false,
          'canAbandon': false,
        },
        'benefits': _benefits,
        'plans': _plans(currentPlanId: null),
      },
      'timestamp': '2026-09-09T07:25:00.000Z',
    };
  }

  Map<String, dynamic> _activeCatalog() {
    return {
      'success': true,
      'message': 'Membership catalog retrieved',
      'code': 200,
      'data': {
        'title': 'Apna Clinic Pro',
        'tagline':
            'You are eligible for the following discounts on Apna Clinic',
        'logoUrl': null,
        'bannerUrl': 'https://iili.io/nfTySKg.png',
        'ctaLabel': 'Manage plan',
        'benefitsTitle': 'Benefits',
        'basicColumnLabel': 'Basic',
        'proColumnLabel': 'pro',
        'planSectionTitle': 'Select a plan',
        'membership': {
          'isPro': true,
          'status': 'active',
          'planId': 12312,
          'planName': 'month',
          'startedAt': null,
          'expiresAt': '2026-05-12T00:00:00.000Z',
          'autoRenew': true,
        },
        'allowedActions': {
          'canSubscribe': false,
          'canUnsubscribe': true,
          'canResubscribe': false,
          'canChangePlan': false,
          'canAbandon': false,
        },
        'benefits': _benefits,
        'plans': _plans(currentPlanId: 'pro_monthly'),
      },
      'timestamp': '2026-09-09T07:25:00.000Z',
    };
  }

  static const List<Map<String, dynamic>> _benefits = [
    {
      'key': 'instant_doctor',
      'title': 'General Practitioner Consultations',
      'basicValue': 'Paid',
      'proValue': 'Free',
      'highlightPro': true,
    },
    {
      'key': 'pharmacy_delivery',
      'title': 'Medicine Delivery Charges',
      'basicValue': 'Rs. 250',
      'proValue': 'Free',
      'highlightPro': true,
    },
    {
      'key': 'consultation',
      'title': 'Doctor Consultation',
      'basicValue': '10% OFF',
      'proValue': '20% OFF',
      'highlightPro': true,
    },
    {
      'key': 'lab',
      'title': 'Lab Tests',
      'basicValue': '10% OFF',
      'proValue': '20% OFF',
      'highlightPro': true,
    },
    {
      'key': 'surgery',
      'title': 'Surgeries',
      'basicValue': '10% OFF',
      'proValue': '30% OFF',
      'highlightPro': true,
    },
  ];

  static List<Map<String, dynamic>> _plans({required String? currentPlanId}) {
    return [
      {
        'planId': 'pro_monthly',
        'price': 350,
        'currency': 'PKR',
        'currencySymbol': 'Rs.',
        'durationValue': 1,
        'durationUnit': 'month',
        'priceDisplay': 'Rs. 350',
        'durationDisplay': '/month',
        'isRecommended': false,
        'isCurrent': currentPlanId == 'pro_monthly',
      },
      {
        'planId': 'pro_6_months',
        'price': 1500,
        'currency': 'PKR',
        'currencySymbol': 'Rs.',
        'durationValue': 6,
        'durationUnit': 'month',
        'priceDisplay': 'Rs. 1500',
        'durationDisplay': '/6 months',
        'isRecommended': true,
        'isCurrent': currentPlanId == 'pro_6_months',
      },
      {
        'planId': 'pro_yearly',
        'price': 2500,
        'currency': 'PKR',
        'currencySymbol': 'Rs.',
        'durationValue': 12,
        'durationUnit': 'month',
        'priceDisplay': 'Rs. 2500',
        'durationDisplay': '/year',
        'isRecommended': false,
        'isCurrent': currentPlanId == 'pro_yearly',
      },
    ];
  }
}
