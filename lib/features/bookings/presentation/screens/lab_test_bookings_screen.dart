import 'package:flutter/material.dart';

import '../widgets/empty_booking_widget.dart';

class LabTestBookingsScreen extends StatelessWidget {
  const LabTestBookingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(2, 18, 2, 8),
      child: Column(
        children: [
          EmptyBookingWidget(
            description: "No lab test bookings yet.",
            buttonText: 'Book Lab Test',
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
