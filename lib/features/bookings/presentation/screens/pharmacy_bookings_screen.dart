import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/router/app_routes.dart';

import '../widgets/empty_booking_widget.dart';

class PharmacyBookingsScreen extends StatelessWidget {
  const PharmacyBookingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(2.w, 18.h, 2.w, 8.h),
      child: Column(
        children: [
          EmptyBookingWidget(
            description: "No pharmacy orders or bookings yet.",
            buttonText: 'Order Medicines',
            onTap: () => context.push(AppRoutes.path(AppRoutes.pharmacy)),
          ),
        ],
      ),
    );
  }
}
