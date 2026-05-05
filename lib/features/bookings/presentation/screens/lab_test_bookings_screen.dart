import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../generated/assets.dart';
import '../../../lab_test/presentation/lab_test_route_args.dart';
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
    final l10n = AppLocalizations.of(context)!;
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
                  description: l10n.bookingsLabTestEmptyDescription,
                  buttonText: l10n.labTestBookCta,
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
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        boxShadow: const [
          BoxShadow(
            color: Color(0x33053453),
            blurRadius: 64.2,
            offset: Offset(0, 14),
            spreadRadius: -27,
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -52.w,
            top: -12.h,
            bottom: -40.h,
            child: IgnorePointer(
              child: Container(
                width: 205.w,
                decoration: BoxDecoration(
                  color: const Color(0xFFE7EBF5),
                  borderRadius: BorderRadius.circular(180.r),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 8.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 24.w,
                  height: 24.h,
                  child: SvgPicture.asset(
                    Assets.labTestWalkin,
                    fit: BoxFit.contain,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  '${l10n.labTestOrderNoPrefix}.${booking.orderNo}',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: const Color(0xFF061E40),
                    fontWeight: FontWeight.w500,
                    fontSize: 16.sp,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  booking.reportTitle,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: const Color(0xFF061E40),
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: 9.h),
                Container(height: 0.3.h, color: const Color(0xFF9BA6A7)),
                SizedBox(height: 10.h),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _metaColumn(
                        theme,
                        label: '${l10n.bookingsStatusLabel}:',
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 9.w, vertical: 3.h),
                          decoration: BoxDecoration(
                            color: booking.isConfirmed
                                ? const Color(0xFFDEF8FB)
                                : const Color(0xFFFBDEDE),
                            borderRadius: BorderRadius.circular(13.r),
                          ),
                          child: Text(
                            booking.statusLabel,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: booking.isConfirmed
                                  ? const Color(0xFF15A9A0)
                                  : const Color(0xFFBA2025),
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(width: 0.3.w, height: 44.h, color: const Color(0xFF9BA6A7)),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: _metaColumn(
                        theme,
                        label: l10n.labTestTotalFeeLabel,
                        child: Text(
                          booking.totalFee,
                          style: theme.textTheme.titleSmall?.copyWith(
                            color: Colors.black,
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    Container(width: 0.3.w, height: 44.h, color: const Color(0xFF9BA6A7)),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: _metaColumn(
                        theme,
                        label: l10n.bookingsDateLabel,
                        child: Text(
                          booking.dateLabel,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: const Color(0xFF667B99),
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    SizedBox(
                      width: 86.w,
                      height: 30.h,
                      child: OutlinedButton(
                        onPressed: () {
                          context.push(
                            AppRoutes.path(AppRoutes.labTestViewDetails),
                            extra: LabTestViewDetailsArgs(
                              testTitle: booking.reportTitle,
                              labName: 'Chughtai Lab',
                              labLogoUrl: Assets.labTestChughtaiLabLogo,
                              partnerLogoUrl: Assets.labTestOladocOgo,
                              sampleType: l10n.labTestSampleTypeBlood,
                              discountedFee: booking.discountedFee,
                              originalFee: booking.originalFee,
                              discountCode: booking.orderNo,
                            ),
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: const Color(0xFF9BA6A7), width: 0.275.r),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(39.433.r),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
                          foregroundColor: const Color(0xFF061E40),
                          textStyle: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w400),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Text(l10n.bookingsViewDetailsCta),
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
            color: const Color(0xFF667B99),
            fontSize: 12.sp,
            fontWeight: FontWeight.w400,
          ),
        ),
        SizedBox(height: 4.h),
        child,
      ],
    );
  }
}
