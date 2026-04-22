import 'package:flutter/foundation.dart';

class LabTestMockApi {
  static bool useMockResponses = kDebugMode & true;

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
}
