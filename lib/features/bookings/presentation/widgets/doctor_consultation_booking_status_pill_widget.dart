import 'package:flutter/material.dart';

import '../../data/models/doctor_consultation_booking_details_model.dart';

class DoctorConsultationBookingStatusPillWidget extends StatelessWidget {
  const DoctorConsultationBookingStatusPillWidget({
    super.key,
    required this.status,
    required this.label,
  });

  final DoctorConsultationBookingStatus status;
  final String label;

  @override
  Widget build(BuildContext context) {
    final (bg, textColor) = switch (status) {
      DoctorConsultationBookingStatus.pending => (
          const Color(0xFFFFF6DD),
          const Color(0xFF946300),
        ),
      DoctorConsultationBookingStatus.confirmed => (
          const Color(0xFFDEF8FB),
          const Color(0xFF15A9A0),
        ),
      DoctorConsultationBookingStatus.cancel => (
          const Color(0xFFFBDEDE),
          const Color(0xFFBA2025),
        ),
      DoctorConsultationBookingStatus.completed => (
          const Color(0xFFE5F7EA),
          const Color(0xFF1F8F4A),
        ),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: textColor,
              fontWeight: FontWeight.w500,
            ),
      ),
    );
  }
}
