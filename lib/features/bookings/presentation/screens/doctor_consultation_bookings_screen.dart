import 'package:flutter/material.dart';

import '../widgets/empty_booking_widget.dart';

class DoctorConsultationBookingsScreen extends StatelessWidget {
  const DoctorConsultationBookingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(2, 18, 2, 8),
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
