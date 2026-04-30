import 'dart:async';

import '../models/lab_test_booking_item_model.dart';

class LabTestBookingsMockApi {
  Future<List<LabTestBookingItemModel>> getLabTestBookings() async {
    await Future<void>.delayed(const Duration(milliseconds: 250));

    final response = <Map<String, dynamic>>[
      {
        'orderNo': '85048960',
        'reportTitle': 'Lipid Profile',
        'statusLabel': 'Confirmed',
        'totalFee': 'Rs. 1,920/-',
        'discountedFee': 'Rs. 1,920/-',
        'originalFee': 'Rs. 2,400/-',
        'dateLabel': '11 Feb,2025',
        'isConfirmed': true,
      },
      {
        'orderNo': '85048961',
        'reportTitle': 'Lipid Profile',
        'statusLabel': 'Canceled',
        'totalFee': 'Rs.30,000/-',
        'discountedFee': 'Rs. 27,000/-',
        'originalFee': 'Rs. 30,000/-',
        'dateLabel': '11 Feb,2025',
        'isConfirmed': false,
      },
    ];

    return response.map(LabTestBookingItemModel.fromJson).toList(growable: false);
  }
}
