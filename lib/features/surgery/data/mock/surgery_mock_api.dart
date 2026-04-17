import 'package:flutter/foundation.dart';

class SurgeryMockApi {
  static bool useMockResponses = kDebugMode & true;

  Future<Map<String, dynamic>> getSurgeryContentSuccessResponse() async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    return {
      'success': true,
      'message': 'Surgery content fetched successfully',
      'defaultCity': 'Islamabad',
      'cities': ['Islamabad', 'Lahore', 'Peshawar', 'Rawalpindi', 'Karachi'],
      'procedures': [
        {'id': 'acl', 'name': 'ACL', 'highlighted': true},
        {'id': 'cataract-eye', 'name': 'Cataract Eye', 'highlighted': true},
        {'id': 'c-section', 'name': 'C-Section', 'highlighted': true},
        {'id': 'fistula', 'name': 'Fitsula', 'highlighted': true},
        {'id': 'lasik-eye', 'name': 'LASIK Eye', 'highlighted': true},
        {'id': 'liposuction', 'name': 'Liposuction', 'highlighted': true},
        {'id': 'cataract-surgery', 'name': 'Cataract Surgery', 'highlighted': true},
        {'id': 'stent-procedure', 'name': 'Stent Procedure', 'highlighted': true},
        {
          'id': 'gallbladder-removal',
          'name': 'Gallbladder Removal',
          'highlighted': true,
        },
        {'id': 'breast-surgery', 'name': 'Breast Surgery', 'highlighted': true},
      ],
    };
  }
}
