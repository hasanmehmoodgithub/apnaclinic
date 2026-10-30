import '../../../../core/config/mock_config.dart';

class ConsultationDoctorSlotsMockApi {
  static bool useMockResponses = MockConfig.enableConsultationMocks;

  Future<Map<String, dynamic>> getDoctorSlotsSuccessResponse({
    required String doctorId,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 400));

    return {
      'success': true,
      'message': 'Doctor details retrieved',
      'code': 200,
      'data': {
        'id': int.tryParse(doctorId) ?? 123,
        'publicId': 'doc_$doctorId',
        'displayName': 'Dr. Example',
        'yearsOfExperience': 10,
        'gender': 'male',
        'profileImageUrl': '',
        'consultationFee': '1500.00',
        'discountPercent': '20',
        'isFree': false,
        'bio': 'Mock doctor profile for consultation slots.',
        'education': 'MBBS',
        'specialtyId': 5,
        'specialtyName': 'Cardiology',
        'ratingScore': '4.70',
        'qualifications': [
          {'type': 'degree', 'name': 'MBBS'},
        ],
        'partner': {
          'tenantId': 1,
          'logoUrl': '',
        },
        'doctorInfo': {
          'ratings': 5,
          'pmdcVerified': true,
          'verifiedPatientsCount': 76,
          'patientsSatisfiedPercentage': 100,
          'timeslots': _mockTimeslots(),
          'patientReviews': {
            'totalCount': 76,
            'filteredCount': 3,
            'reviews': [
              {
                'rating': 5,
                'date': '2025-12-08',
                'comment': 'Recommended & Satisfied',
                'patientName': 'A** ***d',
              },
              {
                'rating': 5,
                'date': '2025-12-08',
                'comment': 'Recommended & Satisfied',
                'patientName': 'A** ***d',
              },
              {
                'rating': 4,
                'date': '2025-11-21',
                'comment': 'Good consultation experience',
                'patientName': 'S*** *a',
              },
            ],
          },
        },
      },
      'timestamp': DateTime.now().toUtc().toIso8601String(),
    };
  }

  /// Mirrors aggregator `GET .../doctor-consultation/doctor/{doctorId}` sample:
  /// Jul 14–18 + Jul 20 with 20-min slots; Jul 19 omitted (gap → disabled in UI).
  static List<Map<String, dynamic>> _mockTimeslots() {
    return [
      {
        'date': '2026-07-14',
        'slots': _slotsFrom('12:40 PM', '08:00 PM'),
      },
      {
        'date': '2026-07-15',
        'slots': _slotsFrom('09:00 AM', '08:00 PM'),
      },
      {
        'date': '2026-07-16',
        'slots': [
          ..._slotsFrom('09:00 AM', '09:20 AM'),
          ..._slotsFrom('10:00 AM', '08:00 PM'),
        ],
      },
      {
        'date': '2026-07-17',
        'slots': _slotsFrom('09:00 AM', '08:00 PM'),
      },
      {
        'date': '2026-07-18',
        'slots': _slotsFrom('09:00 AM', '08:00 PM'),
      },
      {
        'date': '2026-07-20',
        'slots': _slotsFrom('09:00 AM', '08:00 PM'),
      },
    ];
  }

  static List<Map<String, String>> _slotsFrom(
    String startInclusive,
    String endExclusiveOrLastEnd,
  ) {
    final start = _parse12h(startInclusive);
    final end = _parse12h(endExclusiveOrLastEnd);
    if (start == null || end == null || !end.isAfter(start)) {
      return [
        {'startTime': startInclusive, 'endTime': endExclusiveOrLastEnd},
      ];
    }

    final slots = <Map<String, String>>[];
    var cursor = start;
    while (cursor.isBefore(end)) {
      final next = cursor.add(const Duration(minutes: 20));
      if (next.isAfter(end)) break;
      slots.add({
        'startTime': _format12h(cursor),
        'endTime': _format12h(next),
      });
      cursor = next;
    }
    return slots;
  }

  static DateTime? _parse12h(String value) {
    final trimmed = value.trim().toUpperCase();
    final match = RegExp(r'^(\d{1,2}):(\d{2})\s*(AM|PM)$').firstMatch(trimmed);
    if (match == null) return null;
    var hour = int.parse(match.group(1)!);
    final minute = int.parse(match.group(2)!);
    final period = match.group(3)!;
    if (period == 'AM') {
      if (hour == 12) hour = 0;
    } else if (hour != 12) {
      hour += 12;
    }
    return DateTime(2026, 1, 1, hour, minute);
  }

  static String _format12h(DateTime time) {
    final hour24 = time.hour;
    final period = hour24 >= 12 ? 'PM' : 'AM';
    var hour12 = hour24 % 12;
    if (hour12 == 0) hour12 = 12;
    final minute = time.minute.toString().padLeft(2, '0');
    return '${hour12.toString().padLeft(2, '0')}:$minute $period';
  }
}
