class ConsultationDoctorsMockApi {
  Future<Map<String, dynamic>> getDoctorsResponse({
    required String category,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 850));
    final normalized = category.trim().toLowerCase();
    final filteredDoctors = _mockDoctors.where((doctor) {
      final doctorCategory = (doctor['category'] as String? ?? '').toLowerCase();
      return normalized.isEmpty || doctorCategory == normalized;
    }).toList(growable: false);
    final doctors = filteredDoctors.isEmpty ? _mockDoctors : filteredDoctors;

    return {
      'success': true,
      'message': 'Doctors fetched successfully',
      'doctors': doctors,
    };
  }

  Future<Map<String, dynamic>> getDoctorDetailResponse(String doctorId) async {
    await Future<void>.delayed(const Duration(milliseconds: 850));
    final doctor = _mockDoctors.firstWhere(
      (item) => item['id'] == doctorId,
      orElse: () => _mockDoctors.first,
    );

    return {
      'success': true,
      'message': 'Doctor details fetched successfully',
      'doctor': doctor,
    };
  }
}

const List<Map<String, dynamic>> _mockDoctors = [
  {
    'id': 'dr_saadiya_akhter_janjua',
    'category': 'general & internal medicine',
    'name': 'Dr. Saadiya Akhtar Janjua',
    'specialty': 'General Practitioner',
    'experience': '2 years Experience',
    'qualification': 'MBBS',
    'fee': 'Rs. 350/-',
    'oldFee': 'Rs. 500/-',
    'partner': 'MedIQ',
    'rating': '4.5 / 5',
    'imageUrl': 'https://static.vecteezy.com/system/resources/previews/046/680/074/non_2x/an-pakistani-female-doctor-on-isolated-transparent-background-png.png',
    'verifiedPatientsCount': '35',
    'satisfiedText': '4% (35)',
    'description':
        'Dr. Saadiya is committed to patient-centered care with clear communication, '
            'accurate diagnosis, and practical treatment planning tailored to each patient.',
  },
  {
    'id': 'dr_abdul_hafeez',
    'category': 'general & internal medicine',
    'name': 'Dr. Abdul Hafeez',
    'specialty': 'Family Physician',
    'experience': '12 years Experience',
    'qualification': 'MBBS, DFM',
    'fee': 'Rs. 560/-',
    'oldFee': 'Rs. 800/-',
    'partner': 'MedIQ',
    'rating': '4.6 / 5',
    'imageUrl': 'https://www.shutterstock.com/image-photo/indian-doctor-stethoscope-around-neck-600nw-1625058334.jpg',
    'verifiedPatientsCount': '128',
    'satisfiedText': '92% (1.1k)',
    'description':
        'Dr. Abdul Hafeez provides comprehensive family medicine, focusing on preventive care, '
            'long-term health tracking, and continuity of treatment.',
  },
  {
    'id': 'dr_sarmad_hafeez',
    'category': 'general & internal medicine',
    'name': 'Dr Sarmad Hafeez',
    'specialty': 'General Practitioner',
    'experience': '5 years Experience',
    'qualification': 'MBBS, RMP',
    'fee': 'Rs. 350/-',
    'oldFee': 'Rs. 500/-',
    'partner': 'MedIQ',
    'rating': '4.5 / 5',
    'imageUrl': 'https://static.vecteezy.com/system/resources/previews/002/853/524/large_2x/handsome-pakistani-doctor-and-stethoscope-looking-confident-with-smile-on-face-pointing-oneself-with-fingers-proud-and-happy-photo.jpg',
    'verifiedPatientsCount': '84',
    'satisfiedText': '88% (540)',
    'description':
        'Dr. Sarmad focuses on practical evidence-based consultations with empathetic follow-up '
            'for recurring or chronic concerns.',
  },
];
