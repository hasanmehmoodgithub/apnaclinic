import '../../../../core/config/mock_config.dart';

class SurgeryPatientFormMockApi {
  static bool useMockResponses = MockConfig.enableSurgeryMocks;

  Future<Map<String, dynamic>> getPatientFormSuccessResponse({
    required String doctorId,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));

    return {
      'success': true,
      'message': 'Patient form fetched successfully',
      'doctorId': doctorId,
      'patientPrefill': {
        'patientName': 'Haseeb Qasim',
        'age': '24',
        'contactNumber': '0341-2211221',
        'emergencyContact': '0341-2211221',
      },
      'surgeryOptions': _optionsForDoctor(doctorId),
    };
  }

  static List<Map<String, dynamic>> _optionsForDoctor(String doctorId) {
    switch (doctorId) {
      case 'dr_hina_tariq':
        return const [
          {
            'id': 'acl_reconstruction',
            'name': 'ACL Reconstruction',
            'price': 'Rs. 120,000/-',
            'oldPrice': 'Rs. 150,000/-',
          },
          {
            'id': 'meniscus_repair',
            'name': 'Meniscus Repair',
            'price': 'Rs. 85,000/-',
            'oldPrice': 'Rs. 110,000/-',
          },
        ];
      case 'dr_umar_farooq':
        return const [
          {
            'id': 'laparoscopic_cholecystectomy',
            'name': 'Laparoscopic Cholecystectomy',
            'price': 'Rs. 95,000/-',
            'oldPrice': 'Rs. 130,000/-',
          },
          {
            'id': 'open_cholecystectomy',
            'name': 'Open Cholecystectomy',
            'price': 'Rs. 75,000/-',
            'oldPrice': 'Rs. 100,000/-',
          },
        ];
      default:
        return const [
          {
            'id': 'refractive_surgery',
            'name': 'Refractive Surgery',
            'price': 'Rs. 65,000/-',
            'oldPrice': 'Rs. 100,000/-',
          },
          {
            'id': 'corneal_transplant',
            'name': 'Corneal transplant.',
            'price': 'Rs. 65,000/-',
            'oldPrice': 'Rs. 100,000/-',
          },
          {
            'id': 'glaucoma_surgery',
            'name': 'Glaucoma surgery',
            'price': 'Rs. 65,000/-',
            'oldPrice': 'Rs. 100,000/-',
          },
          {
            'id': 'trabeculectomy',
            'name': 'Trabeculectomy',
            'price': 'Rs. 65,000/-',
            'oldPrice': 'Rs. 100,000/-',
          },
        ];
    }
  }
}
