import 'package:flutter/material.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../data/mock/lab_test_bookings_mock_api.dart';
import '../../data/models/lab_test_booking_item_model.dart';

import '../widgets/empty_booking_widget.dart';

class LabTestBookingsScreen extends StatefulWidget {
  const LabTestBookingsScreen({super.key});

  @override
  State<LabTestBookingsScreen> createState() => _LabTestBookingsScreenState();
}

class _LabTestBookingsScreenState extends State<LabTestBookingsScreen> {
  late final Future<List<LabTestBookingItemModel>> _bookingsFuture;

  @override
  void initState() {
    super.initState();
    _bookingsFuture = LabTestBookingsMockApi().getLabTestBookings();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(2.w, 18.h, 2.w, 8.h),
      child: FutureBuilder<List<LabTestBookingItemModel>>(
        future: _bookingsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(strokeWidth: 2));
          }

          final bookings = snapshot.data ?? const <LabTestBookingItemModel>[];
          if (bookings.isEmpty) {
            return Column(
              children: [
                EmptyBookingWidget(
                  description: 'No lab test bookings yet.',
                  buttonText: 'Book Lab Test',
                  onTap: () {},
                ),
              ],
            );
          }

          return ListView.separated(
            itemCount: bookings.length,
            separatorBuilder: (_, _) => SizedBox(height: 10.h),
            itemBuilder: (context, index) => _LabTestBookingCard(
              booking: bookings[index],
            ),
          );
        },
      ),
    );
  }
}

class _LabTestBookingCard extends StatelessWidget {
  const _LabTestBookingCard({required this.booking});

  final LabTestBookingItemModel booking;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: const Color(0xFFE9EBEF)),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -80.w,
            top: -1.h,
            bottom: -70.h,
            child: IgnorePointer(
              child: Container(
                width: 200.w,
                decoration: BoxDecoration(
                  color: const Color(0xFFF2F5FF),
                  borderRadius: BorderRadius.circular(120.r),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(14.w, 12.h, 14.w, 12.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.science_outlined, size: 20.r, color: const Color(0xFF6F7D95)),
                SizedBox(height: 6.h),
                Text(
                  'Order No.${booking.orderNo}',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: const Color(0xFF061E40),
                    fontWeight: FontWeight.w700,
                    fontSize: 17.sp,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  booking.reportTitle,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: const Color(0xFF384B67),
                    fontSize: 14.sp,
                  ),
                ),
                SizedBox(height: 9.h),
                Divider(height: 1.h, color: const Color(0xFFD7DDE5)),
                SizedBox(height: 10.h),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _metaColumn(
                        theme,
                        label: 'Status:',
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 9.w, vertical: 3.h),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEAF8F8),
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Text(
                            booking.statusLabel,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: booking.isConfirmed
                                  ? const Color(0xFF15A9A0)
                                  : const Color(0xFFCF3D3D),
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(width: 1.w, height: 44.h, color: const Color(0xFFE0E4EA)),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: _metaColumn(
                        theme,
                        label: 'Total Fee',
                        child: Text(
                          booking.totalFee,
                          style: theme.textTheme.titleSmall?.copyWith(
                            color: const Color(0xFF191C20),
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    Container(width: 1.w, height: 44.h, color: const Color(0xFFE0E4EA)),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: _metaColumn(
                        theme,
                        label: 'Date',
                        child: Text(
                          booking.dateLabel,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: const Color(0xFF5B6C84),
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    SizedBox(
                      height: 36.h,
                      child: OutlinedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: const Color(0xFFC9D0DA), width: 1.r),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.r),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 12.w),
                          foregroundColor: const Color(0xFF4F6078),
                          textStyle: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w500),
                        ),
                        child: const Text('View Details'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _metaColumn(ThemeData theme, {required String label, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: const Color(0xFF6A7A92),
            fontSize: 12.sp,
          ),
        ),
        SizedBox(height: 4.h),
        child,
      ],
    );
  }
}
