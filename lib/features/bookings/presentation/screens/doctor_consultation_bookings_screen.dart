import 'package:flutter/material.dart';

import '../../../../core/extensions/screen_util_extensions.dart';
import '../../data/mock/doctor_consultation_bookings_mock_api.dart';
import '../../data/models/doctor_consultation_booking_details_model.dart';
import '../widgets/doctor_consultation_booking_card_widget.dart';

class DoctorConsultationBookingsScreen extends StatefulWidget {
  const DoctorConsultationBookingsScreen({super.key});

  @override
  State<DoctorConsultationBookingsScreen> createState() =>
      _DoctorConsultationBookingsScreenState();
}

class _DoctorConsultationBookingsScreenState
    extends State<DoctorConsultationBookingsScreen> {
  late final Future<List<DoctorConsultationBookingDetailsModel>> _bookingsFuture;

  @override
  void initState() {
    super.initState();
    _bookingsFuture = DoctorConsultationBookingsMockApi().getBookings();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<DoctorConsultationBookingDetailsModel>>(
      future: _bookingsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator(strokeWidth: 2));
        }
        final items =
            snapshot.data ?? const <DoctorConsultationBookingDetailsModel>[];
        return ListView.separated(
          padding: EdgeInsets.fromLTRB(0, 20.h, 0, 8.h),
          itemBuilder: (context, index) =>
              DoctorConsultationBookingCardWidget(item: items[index]),
          separatorBuilder: (_, _) => SizedBox(height: 14.h),
          itemCount: items.length,
        );
      },
    );
  }
}
