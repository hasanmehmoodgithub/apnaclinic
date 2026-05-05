import 'package:flutter/foundation.dart';

class PharmacyMockApi {
  static bool useMockResponses = kDebugMode & true;
  static const String _companyUrl =
      'data:image/png;base64,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';

  Future<Map<String, dynamic>> getPharmacyMedicinesSuccessResponse() async {
    await Future<void>.delayed(const Duration(milliseconds: 700));

    return {
      'success': true,
      'message': 'Medicines fetched successfully',
      'medicines': [
        {
          'id': 'm1',
          'name': 'Bio-Col Tablets (Vitamin B12 + Folic Acid)',
          'description':
              'Combination of Vitamin B12 (500mcg) and Folic Acid (400mcg) used for blood formation, energy boost, and prevention of anemia.',
          'imageUrl':
              'https://bio-labs.net/wp-content/uploads/2022/10/12-Bio-Col-Tabs.webp',
          'companyUrl': _companyUrl,
          'price': 450.0,
          'oldPrice': 550.0,
          'type': 'Tablet',
          'category': 'Nutraceutical',
          'packSize': '30 Tablets',
          'composition': 'Vitamin B12 500mcg + Folic Acid 400mcg',
          'usage': '1-2 tablets daily after meal or as prescribed',
        },

        {
          'id': 'm2',
          'name': 'Bio-D3 Ampoule',
          'description':
              'Vitamin D3 injection used for bone health and deficiency treatment.',
          'imageUrl':
              'https://bio-labs.net/wp-content/uploads/2019/12/13-Bio-D3-Inj_.webp',
          'companyUrl': _companyUrl,
          'price': 900.0,
          'oldPrice': 1100.0,
          'type': 'Injection',
          'category': 'Supplements',
        },

        {
          'id': 'm3',
          'name': 'BIORIS Tablets 2mg',
          'description':
              'Used for managing blood sugar levels in diabetes patients.',
          'imageUrl':
              'https://bio-labs.net/wp-content/uploads/2019/12/19-Bioris-2mg-Tabs-.webp',
          'companyUrl': _companyUrl,
          'price': 600.0,
          'oldPrice': 750.0,
          'type': 'Tablet',
          'category': 'Diabetes',
        },

        {
          'id': 'm4',
          'name': 'Nextone Injection (Ceftriaxone)',
          'description':
              'Broad-spectrum antibiotic injection used for severe infections.',
          'imageUrl':
              'https://bio-labs.net/wp-content/uploads/2024/01/75-72-74-mockup.webp',
          'companyUrl': _companyUrl,
          'price': 1200.0,
          'oldPrice': 1400.0,
          'type': 'Injection',
          'category': 'Antibiotic',
        },

        {
          'id': 'm5',
          'name': 'O-ZEETINE Capsules 6/25MG',
          'description': 'Used for gastric and acidity-related conditions.',
          'imageUrl':
              'https://bio-labs.net/wp-content/uploads/2024/01/75-72-74-mockup.webp',
          'companyUrl': _companyUrl,
          'price': 800.0,
          'oldPrice': 950.0,
          'type': 'Capsule',
          'category': 'Gastro',
        },

        {
          'id': 'm6',
          'name': 'Vemtix Injection',
          'description':
              'Used in treatment of nausea, vomiting, and chemotherapy side effects.',
          'imageUrl':
              'https://bio-labs.net/wp-content/uploads/2024/11/Vemtix-8mg-Inj.png',
          'companyUrl': _companyUrl,
          'price': 1500.0,
          'oldPrice': 1800.0,
          'type': 'Injection',
          'category': 'General',
        },
      ],
    };
  }

  Future<Map<String, dynamic>> getPharmacyCartSuccessResponse() async {
    await Future<void>.delayed(const Duration(milliseconds: 500));

    return {
      'success': true,
      'message': 'Cart fetched successfully',
      'cart': [
        {
          'id': 'm2',
          'name': 'Bio-D3 Ampoule',
          'description':
              'Vitamin D3 injection used for bone health and deficiency treatment.',
          'imageUrl':
              'https://bio-labs.net/wp-content/uploads/2019/12/13-Bio-D3-Inj_.webp',
          'companyUrl': _companyUrl,
          'price': 900.0,
          'oldPrice': 1100.0,
          'quantity': 1,
        },
      ],
    };
  }

  Future<Map<String, dynamic>> addToCartSuccessResponse({
    required String medicineId,
    required int quantity,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 450));
    return {
      'success': true,
      'message': 'Added to cart',
      'medicineId': medicineId,
      'quantity': quantity,
    };
  }
}
