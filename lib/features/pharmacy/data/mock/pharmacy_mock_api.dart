import '../../../../core/config/mock_config.dart';
import '../../domain/use_cases/abandon_pharmacy_order_use_case.dart';
import '../../domain/use_cases/pharmacy_checkout_use_case.dart';

class PharmacyMockApi {
  static bool useMockResponses = MockConfig.enablePharmacyMocks;
  static const String _companyUrl =
      'data:image/png;base64,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';

  Future<Map<String, dynamic>> getPharmacyProductsSuccessResponse({
    int page = 1,
    String displayName = '',
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 700));

    final allProducts = [
      {
        'product_id': 178,
        'display_name': '2Sum 2gm Injection 1 vial',
        'image_url':
            'https://mediq-bucket.s3.amazonaws.com/products/webp-images/2sum-2gm-4.webp',
        'price': 590,
        'manufacturer': 'Sami Pharma',
        'category': 'infections',
        'prescription_required': false,
        'generic_name': 'Cefoperazone 1 gm + Sulbactam 1 gm',
        'package_type': 'Pack',
        'indications': '',
        'contra_indications':
            'Contraindications may include hypersensitivity or allergy to cefoperazone, sulbactam, or any components of the medication.',
        'images': <String>[],
      },
      {
        'product_id': 176,
        'display_name': '2Blink 4mg/3mg Drop 15 ml',
        'image_url':
            'https://mediq-bucket.s3.amazonaws.com/products/webp-images/2blink-4mg-3mg-8438.webp',
        'price': 950,
        'manufacturer': 'Sante Pharma',
        'category': 'eye-conditions',
        'prescription_required': false,
        'generic_name': 'Propylene Glycol 0.3 % + Polyethylene Glycol 0.4 %',
        'package_type': 'Pack',
        'indications': '',
        'contra_indications':
            'Contraindications may include hypersensitivity or allergy to propylene glycol, polyethylene glycol, or any other component of the product.',
        'images': <String>[],
      },
      {
        'product_id': 177,
        'display_name': 'Bio-D3 Ampoule',
        'image_url':
            'https://bio-labs.net/wp-content/uploads/2019/12/13-Bio-D3-Inj_.webp',
        'price': 900,
        'manufacturer': 'Bio Labs',
        'category': 'vitamins',
        'prescription_required': false,
        'generic_name': 'Vitamin D3',
        'package_type': 'Pack',
        'indications': 'Vitamin D3 injection used for bone health and deficiency treatment.',
        'contra_indications': '',
        'images': <String>[],
      },
      {
        'product_id': 179,
        'display_name': 'BIORIS Tablets 2mg',
        'image_url':
            'https://bio-labs.net/wp-content/uploads/2019/12/19-Bioris-2mg-Tabs-.webp',
        'price': 600,
        'manufacturer': 'Bio Labs',
        'category': 'diabetes',
        'prescription_required': true,
        'generic_name': 'Glimepiride 2 mg',
        'package_type': 'Blisters',
        'indications': 'Used for managing blood sugar levels.',
        'contra_indications': '',
        'images': <String>[],
      },
      {
        'product_id': 180,
        'display_name': 'O-ZEETINE Capsules 6/25MG',
        'image_url':
            'https://bio-labs.net/wp-content/uploads/2024/01/75-72-74-mockup.webp',
        'price': 800,
        'manufacturer': 'Bio Labs',
        'category': 'gastro',
        'prescription_required': false,
        'generic_name': 'Omeprazole + Domperidone',
        'package_type': 'Blisters',
        'indications': 'Used for gastric and acidity-related conditions.',
        'contra_indications': '',
        'images': <String>[],
      },
      {
        'product_id': 181,
        'display_name': 'Vemtix Injection',
        'image_url':
            'https://bio-labs.net/wp-content/uploads/2024/11/Vemtix-8mg-Inj.png',
        'price': 1500,
        'manufacturer': 'Bio Labs',
        'category': 'other-medicines',
        'prescription_required': false,
        'generic_name': 'Ondansetron 8 mg',
        'package_type': 'Pack',
        'indications': 'Used in treatment of nausea and vomiting.',
        'contra_indications': '',
        'images': <String>[],
      },
    ];

    final query = displayName.trim().toLowerCase();
    final filtered = query.isEmpty
        ? allProducts
        : allProducts
            .where(
              (item) => (item['display_name'] as String)
                  .toLowerCase()
                  .contains(query),
            )
            .toList();

    const pageSize = 4;
    final totalPages = (filtered.length / pageSize).ceil().clamp(1, 999);
    final safePage = page.clamp(1, totalPages);
    final start = (safePage - 1) * pageSize;
    final end = (start + pageSize).clamp(0, filtered.length);
    final pageItems = filtered.sublist(
      start.clamp(0, filtered.length),
      end,
    );

    return {
      'success': true,
      'message': 'Partner products retrieved',
      'code': 200,
      'data': {
        'data': pageItems,
        'page': safePage,
        'limit': pageSize,
        'total': filtered.length,
        'totalPages': totalPages,
        'hasNextPage': safePage < totalPages,
      },
      'timestamp': DateTime.now().toUtc().toIso8601String(),
    };
  }

  Future<Map<String, dynamic>> getPharmacyMedicinesSuccessResponse() async {
    return getPharmacyProductsSuccessResponse();
  }

  Future<Map<String, dynamic>> getPharmacyProductDetailSuccessResponse({
    required String productId,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 650));

    final resolvedId = int.tryParse(productId) ?? 177;

    return {
      'success': true,
      'message': 'Partner product details retrieved',
      'code': 200,
      'data': {
        'product_id': resolvedId,
        'display_name': '2Sum 1gm Injection 1 vial',
        'image_url':
            'https://mediq-bucket.s3.amazonaws.com/products/webp-images/2sum-1gm-3.webp',
        'price': 485,
        'manufacturer': 'Sami Pharma',
        'category': 'Over the Counter Medicines',
        'prescription_required': false,
        'generic_name': 'Cefoperazone 500 mg + Sulbactam 500 mg',
        'package_type': 'Pack',
        'indications': '',
        'contra_indications':
            'Contraindications may include hypersensitivity or allergy to cefoperazone, sulbactam, or any components of the medication. It is important to inform the healthcare professional about any existing medical conditions, such as a history of severe allergic reactions or liver disease. Cefoperazone and sulbactam should be used with caution in patients with impaired liver or kidney function.',
        'images': <String>[],
        'similar_items': [
          {
            'product_id': 178,
            'display_name': '2Sum 2gm Injection 1 vial',
            'image_url':
                'https://mediq-bucket.s3.amazonaws.com/products/webp-images/2sum-2gm-4.webp',
            'price': 590,
            'manufacturer': 'Sami Pharma',
            'category': 'Over the Counter Medicines',
            'prescription_required': false,
            'generic_name': 'Cefoperazone 1 gm + Sulbactam 1 gm',
            'package_type': 'Pack',
            'indications': '',
            'contra_indications': '',
            'images': <String>[],
          },
          {
            'product_id': 176,
            'display_name': '2Blink 4mg/3mg Drop 15 ml',
            'image_url':
                'https://mediq-bucket.s3.amazonaws.com/products/webp-images/2blink-4mg-3mg-8438.webp',
            'price': 950,
            'manufacturer': 'Sante Pharma',
            'category': 'Over the Counter Medicines',
            'prescription_required': false,
            'generic_name':
                'Propylene Glycol 0.3 % + Polyethylene Glycol 0.4 %',
            'package_type': 'Pack',
            'indications': '',
            'contra_indications': '',
            'images': <String>[],
          },
        ],
      },
      'timestamp': DateTime.now().toUtc().toIso8601String(),
    };
  }

  Future<Map<String, dynamic>> getPharmacyCartSuccessResponse() async {
    await Future<void>.delayed(const Duration(milliseconds: 500));

    return {
      'success': true,
      'message': 'Active cart retrieved',
      'code': 200,
      'data': {
        'status': 200,
        'message': 'Request Successful',
        'data': {
          'products': [
            {
              'id': 63367,
              'booking_id': 422845,
              'product_id': 178,
              'unitPrice': 590,
              'line_total': 590,
              'quantity': 1,
              'prescription_url': '',
              'product': {
                'product_id': 178,
                'display_name': '2Sum 2gm Injection 1 vial',
                'image_url':
                    'https://mediq-bucket.s3.amazonaws.com/products/webp-images/2sum-2gm-4.webp',
                'price': 590,
                'manufacturer': 'Sami Pharma',
                'category': 'infections',
                'prescription_required': false,
                'generic_name': 'Cefoperazone 1 gm + Sulbactam 1 gm',
                'package_type': 'Pack',
                'indications': '',
                'contra_indications':
                    'Contraindications may include hypersensitivity or allergy to cefoperazone, sulbactam, or any components of the medication.',
                'images': <String>[],
              },
            },
          ],
          'products_count': 1,
          'booking': {
            'id': 422845,
            'product_name': '2Sum 2gm Injection 1 vial',
          },
          'payment_breakdown': {
            'sub_total': 590,
            'discount': 0,
            'discount_percentage': 0,
            'delivery_charges': 250,
            'total': 840,
          },
          'free_delivery_message':
              'Get Free Delivery for orders above Rs. 2500',
          'messages': {
            'disclaimer':
                'Disclaimer\nSold and fulfilled by our Licensed Pharmacy Partners. "MEDIQ PHARMACY". License No.: 05-352-0070-053618P',
            'prescription_notice':
                'Prescription is required for some items. Customer representative will contact you shortly.',
            'delivery_notice':
                'Orders will be delivered within 3 hours between 8:00 AM and 8:00 PM. Orders placed after 8:00 PM will be delivered by 12PM the following day.',
            'delivery_charges_notice':
                'Orders below Rs 2500 will include delivery charges of Rs 250.',
          },
          'family_members': [
            {
              'id': 1,
              'addresses': null,
            },
          ],
        },
      },
      'timestamp': DateTime.now().toUtc().toIso8601String(),
    };
  }

  Future<Map<String, dynamic>> updateCartQuantitySuccessResponse({
    required String productId,
    required String quantity,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 400));
    return {
      'success': true,
      'message': 'Cart quantity updated',
      'code': 200,
      'data': {
        'product_id': int.tryParse(productId) ?? productId,
        'quantity': int.tryParse(quantity) ?? quantity,
      },
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
      'code': 200,
      'data': {
        'status': 200,
        'message': 'Request Successful',
        'data': {
          'booking_id': '422845',
          'product_id': int.tryParse(medicineId) ?? medicineId,
          'quantity': quantity,
        },
      },
    };
  }

  Future<Map<String, dynamic>> getPharmacyBookingsSuccessResponse({
    int page = 1,
    int limit = 20,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 550));
    final all = <Map<String, dynamic>>[
      {
        'orderNo': 19,
        'unified_order_id': 19,
        'status': 'Confirmed',
        'imageUrl':
            'https://mediq-bucket.s3.amazonaws.com/products/webp-images/panadol-160mg-5ml-920.webp',
        'productName': 'Panadol 160mg/5ml Liquid 120 ml',
        'quantity': 1,
        'unitPrice': 148,
        'total': 398,
        'currency': 'PKR',
        'orderId': '66fb1287-c86d-48f1-8d72-878064118d99',
        'publicId': '66fb1287-c86d-48f1-8d72-878064118d99',
        'createdAt': '2026-08-03 16:35',
      },
      {
        'orderNo': 18,
        'unified_order_id': 18,
        'status': 'Failed',
        'imageUrl':
            'https://mediq-bucket.s3.amazonaws.com/products/webp-images/panadol-500mg-918.webp',
        'productName': 'Panadol 500mg Tablet (10 tablets)',
        'quantity': 1,
        'unitPrice': 50,
        'total': 300,
        'currency': 'PKR',
        'orderId': 'e47c38f5-fd8b-46ce-b895-8a7ad2ec8df2',
        'createdAt': '2026-07-30 21:51',
      },
      {
        'orderNo': 12,
        'unified_order_id': 12,
        'status': 'Confirmed',
        'imageUrl':
            'https://mediq-bucket.s3.amazonaws.com/products/webp-images/panadol-160mg-5ml-920.webp',
        'productName': 'Panadol 160mg/5ml Liquid 120 ml',
        'quantity': 1,
        'unitPrice': 148,
        'total': 398,
        'currency': 'PKR',
        'orderId': 'd6a8b21a-146d-4a54-9aa1-69af9c685708',
        'createdAt': '2026-07-29 18:18',
      },
      {
        'orderNo': 1,
        'unified_order_id': 1,
        'status': 'Cancelled',
        'imageUrl':
            'https://mediq-bucket.s3.amazonaws.com/products/webp-images/2sum-2gm-4.webp',
        'productName': '2Sum 2gm Injection 1 vial',
        'quantity': 1,
        'unitPrice': 590,
        'total': 908,
        'currency': 'PKR',
        'orderId': '61557a75-2127-4df0-89dd-013e2f457547',
        'createdAt': '2026-07-28 11:39',
      },
    ];

    final start = (page - 1) * limit;
    final end = (start + limit).clamp(0, all.length);
    final slice = start >= all.length
        ? const <Map<String, dynamic>>[]
        : all.sublist(start, end);

    return {
      'success': true,
      'message': 'Bookings retrieved',
      'data': {
        'data': slice,
        'page': page,
        'limit': limit,
        'total': all.length,
      },
    };
  }

  Future<Map<String, dynamic>> getPharmacyBookingDetailSuccessResponse({
    required String orderId,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 450));
    final id = orderId.trim().isEmpty
        ? '66fb1287-c86d-48f1-8d72-878064118d99'
        : orderId.trim();
    return {
      'success': true,
      'message': 'Booking retrieved',
      'data': {
        'type': 'pharmacy',
        'orderId': id,
        'publicId': id,
        'orderNo': 19,
        'unified_order_id': 19,
        'status': 'PENDING',
        'statusTimeline': [
          {'label': 'Confirmed', 'completed': false},
          {'label': 'Ready for Dispatch', 'completed': false},
          {'label': 'Dispatched / Shipped', 'completed': false},
          {'label': 'Completed', 'completed': false},
        ],
        'items': [
          {
            'productName': 'Panadol 160mg/5ml Liquid 120 ml',
            'quantity': 1,
            'unitPrice': 148,
            'lineTotal': 148,
            'imageUrl':
                'https://mediq-bucket.s3.amazonaws.com/products/webp-images/panadol-160mg-5ml-920.webp',
          },
        ],
        'subtotal': 148,
        'deliveryCharge': 250,
        'discount': 0,
        'discountPercent': 0,
        'total': 398,
        'currency': 'PKR',
        'paymentMethod': 'JAZZCASH',
        'deliveryAddress': 'NASTP, Rawalpindi',
        'city': 'Rawalpindi',
        'invoiceUrl': null,
        'messageAlert': null,
      },
    };
  }

  Future<Map<String, dynamic>> uploadPrescriptionSuccessResponse({
    required String productId,
    required String fileName,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    return {
      'success': true,
      'message': 'Prescription uploaded successfully',
      'code': 200,
      'data': {
        'product_id': int.tryParse(productId) ?? productId,
        'url':
            'https://mediq-bucket.s3.amazonaws.com/prescriptions/mock/$fileName',
        'file_name': fileName,
      },
    };
  }

  Future<Map<String, dynamic>> checkoutOrderSuccessResponse(
    PharmacyCheckoutParams params,
  ) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    return {
      'success': true,
      'message': 'Order placed successfully',
      'code': 200,
      'data': {
        ...params.toJson(),
        'order_no': '1223',
        'order_id': 'mock-order-1223',
        'unified_order_id': 1223,
        'status': 'confirmed',
        if (params.paymentMethod.toUpperCase() == 'CARD')
          'payment_url': 'https://example.com/mock-pharmacy-payment',
      },
    };
  }

  Future<Map<String, dynamic>> abandonOrderSuccessResponse(
    AbandonPharmacyOrderParams params,
  ) async {
    await Future<void>.delayed(const Duration(milliseconds: 400));
    return {
      'success': true,
      'message': 'Order abandoned successfully',
      'code': 201,
      'data': {
        'unified_order_id': params.unifiedOrderId,
      },
    };
  }

  Future<Map<String, dynamic>> addProfileAddressSuccessResponse({
    required String address,
    required String region,
    required String line1,
    required String cityId,
    String lat = '0',
    String long = '0',
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 400));
    return {
      'success': true,
      'message': 'Address added successfully',
      'code': 200,
      'data': {
        'id': '9001',
        'lat': lat,
        'long': long,
        'category': <String, dynamic>{},
        'address': address,
        'region': region,
        'line1': line1,
        'city_id': cityId,
      },
    };
  }

  Future<Map<String, dynamic>> getProfileAddressesSuccessResponse() async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    return {
      'success': true,
      'message': 'Saved addresses retrieved',
      'code': 200,
      'data': [
        {
          'address_id': '11d432a3-86d3-4471-a4ca-f9187f04904b',
          'label': 'HOME',
          'recipient_name': 'Hasan Mehmood',
          'recipient_phone': '923015077202',
          'line1': 'cmh Rawalpindi',
          'line2': null,
          'city_id': 3,
          'city_name': 'Islamabad',
          'latitude': '0.0000000',
          'longitude': '0.0000000',
          'is_default': true,
        },
      ],
    };
  }
}
