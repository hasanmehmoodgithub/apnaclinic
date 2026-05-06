import '../../../../core/config/mock_config.dart';

class SearchMockApi {
  static bool useMockResponses = MockConfig.enableMocks;

  Future<Map<String, dynamic>> getSearchResponse({
    required String query,
    required bool listening,
    required bool submitted,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 450));
    final q = query.trim();

    if (submitted || q.toLowerCase() == 'al') {
      return _categorizedResultResponse(q.isEmpty ? 'Al' : q);
    }

    if (q.toLowerCase() == 'dr. alina') {
      return _doctorOnlyResultResponse(q);
    }

    if (listening) {
      return _initialResponse(queryHint: 'Listening...');
    }

    if (q.isNotEmpty) {
      return _suggestionsResponse(q);
    }

    return _initialResponse();
  }

  Map<String, dynamic> _initialResponse({String? queryHint}) {
    return {
      'success': true,
      'message': 'Search content fetched',
      'recentSearches': [
        {'title': 'Allegra', 'subtitle': 'in Restaurants'},
        {'title': 'Dr. Alina', 'subtitle': 'in Doctor Consultation'},
        {'title': 'ALK Eye', 'subtitle': 'in Surgery Booking'},
      ],
      'popularSearches': ['Eye Surgery', 'Corona Test', 'Panadol', 'Dentist'],
      'suggestions': [],
      'sections': [],
      'queryHint': queryHint ?? '',
    };
  }

  Map<String, dynamic> _suggestionsResponse(String query) {
    return {
      'success': true,
      'message': 'Search suggestions fetched',
      'recentSearches': [],
      'popularSearches': [],
      'suggestions': [
        {
          'title': 'Dr. Alina',
          'subtitle': 'in Doctor Consultation',
          'sectionType': 'doctor_consultation',
        },
        {
          'title': 'Allegra',
          'subtitle': 'in Pharmacy',
          'sectionType': 'pharmacy',
        },
        {
          'title': 'Allergy Test',
          'subtitle': 'in Laboratory Tests',
          'sectionType': 'laboratory_tests',
        },
        {
          'title': 'ALK (Keratoplasty Eye Surgery)',
          'subtitle': 'in Surgery Booking',
          'sectionType': 'surgery_booking',
        },
      ],
      'sections': [],
    };
  }

  Map<String, dynamic> _doctorOnlyResultResponse(String query) {
    return {
      'success': true,
      'message': 'Search results fetched',
      'recentSearches': [],
      'popularSearches': [],
      'suggestions': [],
      'sections': [
        {
          'title': 'Doctor Consultation',
          'sectionType': 'doctor_consultation',
          'results': [
            {
              'id': 'doc-1',
              'title': 'Dr. Kainat Shahid',
              'subtitle': 'Neurologist',
              'description': '6 years Experience   MMBS, FCPS',
              'imageUrl': 'assets/img/placeHolderPerson.webp',
              'rating': '4/5',
              'fee': 'Rs. 800/-',
              'primaryActionLabel': 'Book Now',
            },
          ],
        },
      ],
    };
  }

  Map<String, dynamic> _categorizedResultResponse(String query) {
    return {
      'success': true,
      'message': 'Search results fetched',
      'recentSearches': [],
      'popularSearches': [],
      'suggestions': [],
      'sections': [
        {
          'title': 'Doctor Consultation',
          'sectionType': 'doctor_consultation',
          'results': [
            {
              'id': 'doc-1',
              'title': 'Dr. Sumbal Shahid',
              'subtitle': 'Neurologist',
              'description': '6 years Experience   MMBS, FCPS',
              'imageUrl': 'assets/img/placeHolderPerson.webp',
              'rating': '4/5',
              'fee': 'Rs. 800/-',
              'primaryActionLabel': 'Book Now',
            },
          ],
        },
        {
          'title': 'Pharmacy',
          'sectionType': 'pharmacy',
          'results': [
            {
              'id': 'pharma-1',
              'title': 'Allegra',
              'subtitle': 'Rs 1900/-',
              'imageUrl': 'assets/img/services/pharmacy.png',
              'price': 'Rs 1900/-',
            },
          ],
        },
        {
          'title': 'Laboratory Tests',
          'sectionType': 'laboratory_tests',
          'results': [
            {
              'id': 'lab-1',
              'title': 'Allergy Test',
              'subtitle': '(also known as Gastric Fluid Analysis)',
              'description': 'IDC Islamabad',
              'sampleType': 'Blood',
              'fee': 'Rs. 15,000/-',
              'providerLabel': 'Provided By Oladoc',
              'imageUrl': 'assets/icons/lab.svg',
            },
          ],
        },
        {
          'title': 'Surgery Booking',
          'sectionType': 'surgery_booking',
          'results': [
            {
              'id': 'surgery-1',
              'title': 'Dr. Sumbal Shahid',
              'subtitle': 'Neurologist',
              'description': '6 years Experience   MMBS, FCPS',
              'hospital': 'Al Shifa International Hospital',
              'imageUrl': 'assets/img/placeHolderPerson.webp',
              'rating': '4/5',
              'fee': 'Rs. 800/-',
              'primaryActionLabel': 'Book Now',
            },
          ],
        },
      ],
    };
  }
}
