import 'package:flutter/material.dart';

import '../widgets/empty_booking_widget.dart';

class SurgeryBookingsScreen extends StatelessWidget {
  const SurgeryBookingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(2, 18, 2, 8),
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
