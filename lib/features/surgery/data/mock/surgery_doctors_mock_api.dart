import '../../../../core/config/mock_config.dart';

class SurgeryDoctorsMockApi {
  static bool useMockResponses = MockConfig.enableMocks;

  Future<Map<String, dynamic>> getSurgeryDoctorsSuccessResponse({
    required String procedureName,
    required String city,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 600));

    final normalizedProcedure = procedureName.trim().toLowerCase();
    final normalizedCity = city.trim().toLowerCase();

    final doctors = _allDoctors.where((doctor) {
      final doctorProcedure =
          (doctor['procedureName'] as String? ?? '').toLowerCase();
      final doctorCity = (doctor['city'] as String? ?? '').toLowerCase();
      final procedureMatch = normalizedProcedure.isEmpty ||
          doctorProcedure.contains(normalizedProcedure) ||
          normalizedProcedure.contains(doctorProcedure.split(' ').first);
      final cityMatch =
          normalizedCity.isEmpty || doctorCity == normalizedCity;
      return procedureMatch && cityMatch;
    }).toList(growable: false);

    final effectiveDoctors =
        doctors.isEmpty ? _allDoctors.take(3).toList() : doctors;

    final hospitals = effectiveDoctors
        .map((e) => e['hospitalName'] as String)
        .toSet()
        .toList();
    final specialties = effectiveDoctors
        .map((e) => e['speciality'] as String)
        .toSet()
        .toList();

    return {
      'success': true,
      'message': 'Surgery doctors fetched successfully',
      'procedureName': procedureName,
      'city': city,
      'hospitals': hospitals,
      'specialties': specialties,
      'doctors': effectiveDoctors
          .map((doctor) => Map<String, dynamic>.from(doctor)..remove('city'))
          .toList(),
    };
  }

  static const List<Map<String, dynamic>> _allDoctors = [
    {
      'id': 'dr_sumbal_shahid',
      'city': 'islamabad',
      'doctorName': 'Dr. Sumbal Shahid',
      'speciality': 'Eye Surgeon',
      'experience': '6 years Experience',
      'qualifications': 'MMBS, FCPS',
      'hospitalName': 'Al Shifa International Hospital',
      'procedureName': 'Refractive Lens Exchange',
      'price': 'Rs. 65,000/-',
      'oldPrice': 'Rs. 100,000/-',
      'imageUrl':
          'https://images.unsplash.com/photo-1559839734-2b71ea197ec2?auto=format&fit=crop&w=800&q=80',
      'partnerLogoUrl':
          'https://www.figma.com/api/mcp/asset/5e669d2b-dc77-4e06-86d2-9ead92b99252',
    },
    {
      'id': 'dr_ayesha',
      'city': 'islamabad',
      'doctorName': 'Dr. Ayesha',
      'speciality': 'Cornea Specialist',
      'experience': '6 years Experience',
      'qualifications': 'MMBS, FCPS',
      'hospitalName': 'Al Maroof Hospital',
      'procedureName': 'Corneal Transplant (Keratoplasty)',
      'price': 'Rs. 65,000/-',
      'oldPrice': 'Rs. 100,000/-',
      'imageUrl':
          'https://images.unsplash.com/photo-1594824476967-48c8b964273f?auto=format&fit=crop&w=800&q=80',
      'partnerLogoUrl':
          'https://www.figma.com/api/mcp/asset/5e669d2b-dc77-4e06-86d2-9ead92b99252',
    },
    {
      'id': 'dr_raheel_khan',
      'city': 'islamabad',
      'doctorName': 'Dr. Raheel Khan',
      'speciality': 'Refractive Surgeon',
      'experience': '6 years Experience',
      'qualifications': 'MMBS, FCPS',
      'hospitalName': 'Al Maroof Hospital',
      'procedureName': 'Photorefractive keratectomy Surgery',
      'price': 'Rs. 50,000/-',
      'oldPrice': 'Rs. 80,000/-',
      'imageUrl':
          'https://images.unsplash.com/photo-1612349317150-e413f6a5b16d?auto=format&fit=crop&w=800&q=80',
      'partnerLogoUrl':
          'https://www.figma.com/api/mcp/asset/5e669d2b-dc77-4e06-86d2-9ead92b99252',
    },
    {
      'id': 'dr_hina_tariq',
      'city': 'lahore',
      'doctorName': 'Dr. Hina Tariq',
      'speciality': 'Orthopaedic Surgeon',
      'experience': '8 years Experience',
      'qualifications': 'MBBS, FCPS',
      'hospitalName': 'Shaukat Khanum Memorial Hospital',
      'procedureName': 'ACL Reconstruction',
      'price': 'Rs. 120,000/-',
      'oldPrice': 'Rs. 150,000/-',
      'imageUrl':
          'https://images.unsplash.com/photo-1622253692010-333f2da6031d?auto=format&fit=crop&w=800&q=80',
      'partnerLogoUrl':
          'https://www.figma.com/api/mcp/asset/5e669d2b-dc77-4e06-86d2-9ead92b99252',
    },
    {
      'id': 'dr_umar_farooq',
      'city': 'karachi',
      'doctorName': 'Dr. Umar Farooq',
      'speciality': 'General Surgeon',
      'experience': '10 years Experience',
      'qualifications': 'MBBS, FCPS',
      'hospitalName': 'Aga Khan University Hospital',
      'procedureName': 'Gallbladder Removal',
      'price': 'Rs. 95,000/-',
      'oldPrice': 'Rs. 130,000/-',
      'imageUrl':
          'https://images.unsplash.com/photo-1612349317150-e413f6a5b16d?auto=format&fit=crop&w=800&q=80',
      'partnerLogoUrl':
          'https://www.figma.com/api/mcp/asset/5e669d2b-dc77-4e06-86d2-9ead92b99252',
    },
  ];
}
