import 'package:flutter/material.dart';
import '../../../../core/extensions/screen_util_extensions.dart';

import '../widgets/empty_booking_widget.dart';

class DoctorConsultationBookingsScreen extends StatelessWidget {
  const DoctorConsultationBookingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(2.w, 18.h, 2.w, 8.h),
      child: Column(
        children: [
          EmptyBookingWidget(
            description: "Seems like you don't have any appointments yet!",
            buttonText: 'Book Your Appointment',
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
