import '../../../../core/config/mock_config.dart';
import '../models/consultation_doctor_model.dart';

class ConsultationDoctorsMockApi {
  static bool get useMockResponses => MockConfig.enableConsultationMocks;

  Future<Map<String, dynamic>> getDoctorsResponse({
    required String mainCategoryId,
    String? partnerId,
    String? search,
    int page = 1,
    int limit = 20,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 850));

    final allDoctors = List<Map<String, dynamic>>.generate(24, (index) {
      final id = index + 1;
      final tenantId = id.isEven ? 2 : 3;
      final partnerName = tenantId == 2 ? 'Oladoc' : 'MedIQ';
      return {
        'id': id,
        'publicId': 'dr_mock_$id',
        'displayName': 'Dr. Mock Doctor $id',
        'specialtyName': index.isEven ? 'General Practitioner' : 'Neurologist',
        'yearsOfExperience': (id % 8) + 1,
        'profileImageUrl':
            'https://static.vecteezy.com/system/resources/previews/046/680/074/non_2x/an-pakistani-female-doctor-on-isolated-transparent-background-png.png',
        'consultationFee': '${(id % 5 + 1) * 500}.00',
        'discountPercent': '0.00',
        'isFree': false,
        'ratingScore': '${4 + (id % 10) / 10}',
        'bio': 'Dr. Mock Doctor $id is available via $partnerName.',
        'education': 'MBBS',
        'qualifications': [],
        'partner': {'tenantId': tenantId, 'logoUrl': null},
      };
    });

    final trimmedPartnerId = partnerId?.trim();
    var doctors = trimmedPartnerId == null || trimmedPartnerId.isEmpty
        ? allDoctors
        : allDoctors.where((doctor) {
            final partner = doctor['partner'];
            if (partner is! Map) return false;
            return partner['tenantId']?.toString() == trimmedPartnerId;
          }).toList(growable: false);

    final trimmedSearch = search?.trim().toLowerCase();
    if (trimmedSearch != null && trimmedSearch.isNotEmpty) {
      doctors = doctors.where((doctor) {
        final name = doctor['displayName']?.toString().toLowerCase() ?? '';
        final specialty = doctor['specialtyName']?.toString().toLowerCase() ?? '';
        return name.contains(trimmedSearch) || specialty.contains(trimmedSearch);
      }).toList(growable: false);
    }

    final safePage = page < 1 ? 1 : page;
    final safeLimit = limit < 1 ? 20 : limit;
    final start = (safePage - 1) * safeLimit;
    final pageItems = start >= doctors.length
        ? const <Map<String, dynamic>>[]
        : doctors.skip(start).take(safeLimit).toList(growable: false);

    return {
      'success': true,
      'message': 'Doctors retrieved',
      'code': 200,
      'data': {
        'data': pageItems,
        'page': safePage,
        'limit': safeLimit,
        'total': doctors.length,
        'partners': [
          {
            'tenantId': 1,
            'tenant': '019f1893-a334-746b-95bb-32194322eb55',
            'logoUrl': null,
          },
          {'tenantId': 2, 'tenant': 'oladoc', 'logoUrl': null},
          {'tenantId': 3, 'tenant': 'mediq', 'logoUrl': null},
          {'tenantId': 4, 'tenant': 'bima', 'logoUrl': null},
          {'tenantId': 5, 'tenant': 'apna-clinic', 'logoUrl': null},
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
      'partnerLogoUrl': item.partnerLogoUrl,
      'tenantId': item.tenantId,
      'partnerDoctorId': item.partnerDoctorId,
      'hospitalId': item.hospitalId,
    };
  }
}
