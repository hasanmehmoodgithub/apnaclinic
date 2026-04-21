import 'dart:async';

import '../models/lab_test_booking_item_model.dart';

class LabTestBookingsMockApi {
  Future<List<LabTestBookingItemModel>> getLabTestBookings() async {
    await Future<void>.delayed(const Duration(milliseconds: 250));

    final response = <Map<String, dynamic>>[
      {
        'orderNo': '224',
        'reportTitle': 'Lab Test Report',
        'statusLabel': 'Confirmed',
        'totalFee': 'Rs.30,000/-',
        'dateLabel': '11 Feb,2025',
        'isConfirmed': true,
      },
      {
        'orderNo': '225',
        'reportTitle': 'Lab Test Report',
        'statusLabel': 'Canceled',
        'totalFee': 'Rs.30,000/-',
        'dateLabel': '11 Feb,2025',
        'isConfirmed': false,
      },
    ];

    return response.map(LabTestBookingItemModel.fromJson).toList(growable: false);
  }
}
