import '../../../../core/config/mock_config.dart';
import '../models/consultation_doctor_model.dart';

class ConsultationDoctorsMockApi {
  static bool get useMockResponses => MockConfig.enableConsultationMocks;

  Future<Map<String, dynamic>> getDoctorsResponse({
    required String mainCategoryId,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 850));

    return {
      'success': true,
      'message': 'Doctors retrieved',
      'code': 200,
      'data': {
        'data': [
          {
            'id': 1,
            'publicId': 'dr_saadiya_akhter_janjua',
            'displayName': 'Dr. Saadiya Akhtar Janjua',
            'specialtyName': 'General Practitioner',
            'yearsOfExperience': 2,
            'profileImageUrl':
                'https://static.vecteezy.com/system/resources/previews/046/680/074/non_2x/an-pakistani-female-doctor-on-isolated-transparent-background-png.png',
            'consultationFee': '500.00',
            'discountPercent': '30.00',
            'isFree': false,
            'ratingScore': 4.5,
            'qualifications': ['MBBS'],
            'partner': {'tenantId': 1, 'logoUrl': null},
          },
          {
            'id': 2,
            'publicId': 'dr_sumbal_shahid',
            'displayName': 'Dr. Sumbal Shahid',
            'specialtyName': 'Neurologist',
            'yearsOfExperience': 6,
            'profileImageUrl':
                'https://www.shutterstock.com/image-photo/indian-doctor-stethoscope-around-neck-600nw-1625058334.jpg',
            'consultationFee': '15000.00',
            'discountPercent': '0.00',
            'isFree': false,
            'ratingScore': 4.8,
            'qualifications': ['MBBS', 'FCPS'],
            'partner': {'tenantId': 2, 'logoUrl': null},
          },
        ],
      },
    };
  }

  Future<Map<String, dynamic>> getDoctorDetailResponse(String doctorId) async {
    await Future<void>.delayed(const Duration(milliseconds: 850));
    final response = await getDoctorsResponse(mainCategoryId: '1');
    final data = response['data'];
    final nested = data is Map ? data['data'] : null;
    final doctors = nested is List ? nested : const [];
    Map<String, dynamic>? doctor;
    for (final item in doctors) {
      if (item is! Map<String, dynamic>) continue;
      if (item['publicId'] == doctorId || item['id']?.toString() == doctorId) {
        doctor = item;
        break;
      }
    }
    doctor ??= doctors.isNotEmpty && doctors.first is Map<String, dynamic>
        ? doctors.first as Map<String, dynamic>
        : const {};

    return {
      'success': true,
      'message': 'Doctor details fetched successfully',
      'doctor': _legacyDoctorMap(doctor),
    };
  }

  Map<String, dynamic> _legacyDoctorMap(Map<String, dynamic> doctor) {
    final model = ConsultationDoctorModel.fromJson(doctor);
    final item = model.toResultsDoctorItem();
    return {
      'id': item.id,
      'name': item.name,
      'specialty': item.specialty,
      'experience': item.experience,
      'qualification': item.qualification,
      'fee': item.fee,
      'oldFee': item.oldFee,
      'partner': item.partner,
      'rating': item.rating,
      'imageUrl': item.imageUrl,
      'verifiedPatientsCount': item.verifiedPatientsCount,
      'satisfiedText': item.satisfiedText,
      'description': item.description,
    };
  }
}
