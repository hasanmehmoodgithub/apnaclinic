import 'package:flutter/material.dart';
import '../../../../core/extensions/screen_util_extensions.dart';

import '../widgets/empty_booking_widget.dart';

class SurgeryBookingsScreen extends StatelessWidget {
  const SurgeryBookingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(2.w, 18.h, 2.w, 8.h),
      child: Column(
        children: [
          EmptyBookingWidget(
            description: "No surgery bookings found at the moment.",
            buttonText: 'Explore Surgery',
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
