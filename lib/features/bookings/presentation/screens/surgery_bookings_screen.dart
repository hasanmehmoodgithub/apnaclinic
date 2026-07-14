import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/router/app_routes.dart';
import '../../../consultation/presentation/widgets/consultation_partner_logo_widget.dart';
import '../../data/mock/surgery_bookings_mock_api.dart';
import '../../data/models/surgery_booking_list_item_model.dart';
import '../../data/models/surgery_details_item.dart';
import '../widgets/bookings_list_shimmer_widget.dart';

class SurgeryBookingsScreen extends StatefulWidget {
  const SurgeryBookingsScreen({super.key});

  @override
  State<SurgeryBookingsScreen> createState() => _SurgeryBookingsScreenState();
}

class _SurgeryBookingsScreenState extends State<SurgeryBookingsScreen> {
  late final Future<List<SurgeryBookingListItemModel>> _bookingsFuture;

  @override
  void initState() {
    super.initState();
    _bookingsFuture = SurgeryBookingsMockApi().getBookings();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;
    return FutureBuilder<List<SurgeryBookingListItemModel>>(
      future: _bookingsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const BookingsListShimmerWidget();
        }

        final items = snapshot.data ?? const <SurgeryBookingListItemModel>[];
        if (items.isEmpty) {
          return Center(
            child: Text(
              l10n.bookingsSurgeryEmptyDescription,
              style: textTheme.bodyMedium,
            ),
          );
        }

        return ListView.separated(
          padding: EdgeInsets.fromLTRB(0, 20.h, 0, 8.h),
          itemCount: items.length,
          separatorBuilder: (_, _) => SizedBox(height: 14.h),
          itemBuilder: (context, index) {
            final item = items[index];
            return GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => _openDetails(context, item, l10n),
              child: _SurgeryBookingCard(
                item: item,
                textTheme: textTheme,
                l10n: l10n,
                onViewDetails: () => _openDetails(context, item, l10n),
              ),
            );
          },
        );
      },
    );
  }

  void _openDetails(
    BuildContext context,
    SurgeryBookingListItemModel item,
    AppLocalizations l10n,
  ) {
    context.pushNamed(
      AppRoutes.surgeryBookingDetails,
      extra: SurgeryBookingDetailsArgs(
        item: item.toDetailsItem(l10n),
        initialStatus: item.initialStatus,
      ),
    );
  }
}

class _SurgeryBookingCard extends StatelessWidget {
  const _SurgeryBookingCard({
    required this.item,
    required this.textTheme,
    required this.l10n,
    required this.onViewDetails,
  });

  final SurgeryBookingListItemModel item;
  final TextTheme textTheme;
  final AppLocalizations l10n;
  final VoidCallback onViewDetails;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: const [
          BoxShadow(
            color: Color(0x33053453),
            blurRadius: 64.2,
            offset: Offset(0, 14),
            spreadRadius: -27,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.r),
        child: Stack(
          children: [
            Positioned(
              right: -100.w,
              top: -40.h,
              child: IgnorePointer(
                child: Container(
                  width: 280.w,
                  height: 280.h,
                  decoration: const BoxDecoration(
                    color: Color(0xFFDFF1F4),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(10.w, 9.h, 10.w, 9.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SvgPicture.asset(
                              'assets/icons/surgerybooking.svg',
                              width: 18.r,
                              height: 18.r,
                            ),
                            SizedBox(height: 8.h),
                            Text(
                              item.procedure,
                              style: textTheme.titleMedium?.copyWith(
                                color: const Color(0xFF061E40),
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w500,
                                height: 1.2,
                              ),
                            ),
                            SizedBox(height: 2.h),
                            Text(
                              item.hospital,
                              style: textTheme.bodyMedium?.copyWith(
                                color: const Color(0xFF061E40),
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 6.w),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 38.w,
                            height: 38.h,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: const Color(0x36000000),
                                width: 0.4,
                              ),
                            ),
                            clipBehavior: Clip.antiAlias,
                            child: Center(
                              child: ConsultationPartnerLogoWidget(
                                logoUrl: item.partnerLogoUrl,
                                width: 30.w,
                                height: 30.h,
                                fit: BoxFit.contain,
                                compact: true,
                              ),
                            ),
                          ),
                          SizedBox(height: 8.h),
                          SvgPicture.asset(
                            'assets/icons/surgerymessage.svg',
                            width: 25.r,
                            height: 25.r,
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 5.h),
                  Container(height: 0.5, color: const Color(0xFFCBD3D9)),
                  SizedBox(height: 5.h),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text(
                          item.doctor,
                          style: textTheme.bodyMedium?.copyWith(
                            color: const Color(0xFF061E40),
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        '${item.specialty}  |  ${item.qualification}',
                        style: textTheme.bodySmall?.copyWith(
                          color: const Color(0xFF667B99),
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  Container(height: 0.5, color: const Color(0xFFCBD3D9)),
                  SizedBox(height: 8.h),
                  IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '${l10n.bookingsStatusLabel}:',
                              style: textTheme.bodySmall?.copyWith(
                                color: const Color(0xFF667B99),
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            SizedBox(height: 3.h),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 12.w,
                                vertical: 5.h,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFDEF8FB),
                                borderRadius: BorderRadius.circular(20.r),
                              ),
                              child: Text(
                                item.status,
                                style: textTheme.bodyMedium?.copyWith(
                                  color: const Color(0xFF0590A0),
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          width: 0.5,
                          margin: EdgeInsets.symmetric(horizontal: 14.w),
                          color: const Color(0xFF9BA6A7),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              l10n.bookingsDateCreatedLabel,
                              style: textTheme.bodySmall?.copyWith(
                                color: const Color(0xFF667B99),
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            SizedBox(height: 3.h),
                            Text(
                              item.dateCreated,
                              style: textTheme.bodySmall?.copyWith(
                                color: const Color(0xFF667B99),
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        SizedBox(
                          height: 40.h,
                          child: OutlinedButton(
                            onPressed: onViewDetails,
                            style: OutlinedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              side: const BorderSide(
                                color: Color(0xFF9BA6A7),
                                width: 0.5,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(40.r),
                              ),
                              padding: EdgeInsets.symmetric(horizontal: 18.w),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: Text(
                              l10n.bookingsViewDetailsCta,
                              style: textTheme.bodySmall?.copyWith(
                                color: const Color(0xFF061E40),
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
