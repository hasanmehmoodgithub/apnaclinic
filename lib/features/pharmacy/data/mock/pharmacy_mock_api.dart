import 'package:flutter/foundation.dart';

class PharmacyMockApi {
  static bool useMockResponses = kDebugMode & true;

  Future<Map<String, dynamic>> getPharmacyMedicinesSuccessResponse() async {
    await Future<void>.delayed(const Duration(milliseconds: 700));
    return {
      'success': true,
      'message': 'Medicines fetched successfully',
      'medicines': [
        {
          'id': 'm1',
          'name': 'O-ZEETINE Capsules 6/25MG',
          'description':
              'A product that provides a guaranteed level of life takafal protection against death, of the Participant.',
          'imageUrl': 'https://picsum.photos/seed/pharma1/600/400',
          'price': 1900.0,
          'oldPrice': 2200.0,
        },
        {
          'id': 'm2',
          'name': 'Bio-Col Capsules 6/25MG',
          'description':
              'Relief medicine with fast action formula for daily symptoms.',
          'imageUrl': 'https://picsum.photos/seed/pharma2/600/400',
          'price': 1700.0,
          'oldPrice': 1900.0,
        },
        {
          'id': 'm3',
          'name': 'Amdol Capsule 10MG',
          'description':
              'Trusted medicine for regular use under specialist advice.',
          'imageUrl': 'https://picsum.photos/seed/pharma3/600/400',
          'price': 1450.0,
          'oldPrice': 1750.0,
        },
        {
          'id': 'm4',
          'name': 'Arbit Capsule 20MG',
          'description':
              'High quality medicine with verified source and packaging.',
          'imageUrl': 'https://picsum.photos/seed/pharma4/600/400',
          'price': 1600.0,
          'oldPrice': 1950.0,
        },
      ],
    };
  }
}
