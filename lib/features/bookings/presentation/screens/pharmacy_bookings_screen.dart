import 'package:flutter/material.dart';

import '../widgets/empty_booking_widget.dart';

class PharmacyBookingsScreen extends StatelessWidget {
  const PharmacyBookingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(2, 18, 2, 8),
      child: Column(
        children: [
          EmptyBookingWidget(
            description: "No pharmacy orders or bookings yet.",
            buttonText: 'Order Medicines',
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
