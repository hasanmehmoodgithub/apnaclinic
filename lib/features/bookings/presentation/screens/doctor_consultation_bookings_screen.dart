import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/router/app_routes.dart';
import '../../data/mock/doctor_consultation_bookings_mock_api.dart';
import '../../data/models/doctor_consultation_booking_details_model.dart';
import '../doctor_consultation_booking_details_args.dart';

class DoctorConsultationBookingsScreen extends StatefulWidget {
  const DoctorConsultationBookingsScreen({super.key});

  @override
  State<DoctorConsultationBookingsScreen> createState() =>
      _DoctorConsultationBookingsScreenState();
}

class _DoctorConsultationBookingsScreenState
    extends State<DoctorConsultationBookingsScreen> {
  late final Future<List<DoctorConsultationBookingDetailsModel>> _bookingsFuture;

  @override
  void initState() {
    super.initState();
    _bookingsFuture = DoctorConsultationBookingsMockApi().getBookings();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;
    return FutureBuilder<List<DoctorConsultationBookingDetailsModel>>(
      future: _bookingsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator(strokeWidth: 2));
        }
        final items = snapshot.data ?? const <DoctorConsultationBookingDetailsModel>[];
        return ListView.separated(
          padding: EdgeInsets.fromLTRB(0, 20.h, 0, 8.h),
          itemBuilder: (context, index) => _DoctorBookingCard(
            item: items[index],
            textTheme: textTheme,
            l10n: l10n,
          ),
          separatorBuilder: (_, _) => SizedBox(height: 14.h),
          itemCount: items.length,
        );
      },
    );
  }
}

class _DoctorBookingCard extends StatelessWidget {
  const _DoctorBookingCard({
    required this.item,
    required this.textTheme,
    required this.l10n,
  });

  final DoctorConsultationBookingDetailsModel item;
  final TextTheme textTheme;
  final AppLocalizations l10n;

  static const String _partnerLogoUrl =
      'https://www.figma.com/api/mcp/asset/705ed652-7c25-48fd-916b-375e85a43137';

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
      child: Padding(
        padding: EdgeInsets.all(10.w),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Doctor image
            Container(
              width: 85.w,
              height: 110.h,
              decoration: BoxDecoration(
                color: const Color(0xFFF4F4F4),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10.r),
                child: CachedNetworkImage(
                  imageUrl: item.doctorImageUrl,
                  fit: BoxFit.cover,
                  placeholder: (_, _) => const Center(
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  errorWidget: (_, _, _) => const Icon(
                    Icons.person_rounded,
                    color: Color(0xFFBFC7CF),
                    size: 40,
                  ),
                ),
              ),
            ),
            SizedBox(width: 10.w),

            // Middle content section (name, info, status, fee)
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Top row: Name + Rating badge
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Text(
                          item.doctorName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: textTheme.titleMedium?.copyWith(
                            color: const Color(0xFF061E40),
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            height: 1.1,
                          ),
                        ),
                      ),
                      SizedBox(width: 5.w),
                      _RatingBadge(textTheme: textTheme),
                    ],
                  ),
                  SizedBox(height: 1.h),

                  // Specialty
                  Text(
                    item.specialty,
                    style: textTheme.bodyMedium?.copyWith(
                      color: const Color(0xFF667B99),
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),

                  SizedBox(height: 1.h),

                  // Experience + Qualification
                  Text(
                    '${item.experience} | ${item.qualification}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.bodySmall?.copyWith(
                      color: const Color(0xFF667B99),
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w300,
                    ),
                  ),

                  SizedBox(height: 5.h),

                  // Date + Time pills
                  Row(
                    children: [
                      _InfoPill(label: item.listDate, textTheme: textTheme),
                      SizedBox(width: 5.w),
                      _InfoPill(label: item.listTime, textTheme: textTheme),
                    ],
                  ),

                  SizedBox(height: 6.h),

                  // Status + Fee row (with divider in between)
                  IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Status column
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '${l10n.bookingsStatusLabel}:',
                                style: textTheme.bodySmall?.copyWith(
                                  color: const Color(0xFF667B99),
                                  fontSize: 11.sp,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              SizedBox(height: 4.h),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 6.w,
                                  vertical: 4.h,
                                ),
                                decoration: BoxDecoration(
                                  color: _statusBgColor(item.status),
                                  borderRadius: BorderRadius.circular(10.r),
                                ),
                                child: Text(
                                  _localizedStatus(item.status, l10n),
                                  maxLines: 1,
                                  overflow: TextOverflow.visible,
                                  softWrap: false,
                                  style: textTheme.bodySmall?.copyWith(
                                    color: _statusTextColor(item.status),
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Vertical divider between Status and Fee
                        Container(
                          width: 0.5,
                          margin: EdgeInsets.symmetric(horizontal: 6.w),
                          color: const Color(0xFF9BA6A7),
                        ),

                        // Fee column
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                l10n.bookingsFeeLabel,
                                style: textTheme.bodySmall?.copyWith(
                                  color: const Color(0xFF667B99),
                                  fontSize: 11.sp,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              SizedBox(height: 3.h),
                              FittedBox(
                                fit: BoxFit.scaleDown,
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Rs.${item.consultationFee}',
                                  maxLines: 1,
                                  softWrap: false,
                                  style: textTheme.bodySmall?.copyWith(
                                    color: Colors.black,
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              FittedBox(
                                fit: BoxFit.scaleDown,
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Rs. ${item.consultationFee + item.discountAmount}/-',
                                  maxLines: 1,
                                  softWrap: false,
                                  style: textTheme.bodySmall?.copyWith(
                                    color: const Color(0xFF979797),
                                    fontSize: 11.sp,
                                    decoration: TextDecoration.lineThrough,
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

            SizedBox(width: 8.w),

            // Right column: Logo (top) + View details button (bottom)
            SizedBox(
              height: 130.h,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Partner logo
                  Container(
                    width: 36.w,
                    height: 36.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0x36000000),
                        width: 0.4,
                      ),
                    ),
                    child: ClipOval(
                      child: Padding(
                        padding: EdgeInsets.all(3.w),
                        child: _NetAsset(_partnerLogoUrl, fit: BoxFit.contain),
                      ),
                    ),
                  ),
                  // View details button
                  SizedBox(
                    width: 82.w,
                    height: 33.h,
                    child: OutlinedButton(
                      onPressed: () => context.pushNamed(
                        AppRoutes.doctorConsultationBookingDetails,
                        extra: DoctorConsultationBookingDetailsArgs(
                          bookingId: item.bookingId,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(
                          color: Color(0xFF9BA6A7),
                          width: 0.5,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        padding: EdgeInsets.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text(
                        l10n.bookingsViewDetailsCta,
                        style: textTheme.bodySmall?.copyWith(
                          color: const Color(0xFF061E40),
                          fontSize: 12.sp,
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
    );
  }
}

String _localizedStatus(
  DoctorConsultationBookingStatus status,
  AppLocalizations l10n,
) {
  switch (status) {
    case DoctorConsultationBookingStatus.pending:
      return l10n.bookingsStatusPending;
    case DoctorConsultationBookingStatus.confirmed:
      return l10n.bookingsStatusConfirmed;
    case DoctorConsultationBookingStatus.cancel:
      return l10n.bookingsStatusCancel;
    case DoctorConsultationBookingStatus.completed:
      return l10n.bookingsStatusCompleted;
  }
}

Color _statusTextColor(DoctorConsultationBookingStatus status) {
  switch (status) {
    case DoctorConsultationBookingStatus.pending:
      return const Color(0xFF946300);
    case DoctorConsultationBookingStatus.confirmed:
      return const Color(0xFF0590A0);
    case DoctorConsultationBookingStatus.cancel:
      return const Color(0xFFE01F26);
    case DoctorConsultationBookingStatus.completed:
      return const Color(0xFF1F8F4A);
  }
}

Color _statusBgColor(DoctorConsultationBookingStatus status) {
  switch (status) {
    case DoctorConsultationBookingStatus.pending:
      return const Color(0xFFFFF6DD);
    case DoctorConsultationBookingStatus.confirmed:
      return const Color(0xFFDEF8FB);
    case DoctorConsultationBookingStatus.cancel:
      return const Color(0xFFFBDEDE);
    case DoctorConsultationBookingStatus.completed:
      return const Color(0xFFE5F7EA);
  }
}

class _RatingBadge extends StatelessWidget {
  final TextTheme textTheme;

  const _RatingBadge({required this.textTheme});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6.r),
        border: Border.all(color: const Color(0xFF98E089), width: 1),
      ),
      child: Text(
        '4 / 5',
        style: textTheme.bodySmall?.copyWith(
          color: const Color(0xFF667B99),
          fontSize: 9.sp,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _InfoPill extends StatelessWidget {
  final String label;
  final TextTheme textTheme;

  const _InfoPill({required this.label, required this.textTheme});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFF9BA6A7), width: 0.5),
        borderRadius: BorderRadius.circular(40.r),
      ),
      child: Text(
        label,
        style: textTheme.bodySmall?.copyWith(
          color: const Color(0xFF667B99),
          fontSize: 11.sp,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}

class _NetAsset extends StatelessWidget {
  const _NetAsset(this.url, {this.fit = BoxFit.contain});

  final String url;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: url,
      fit: fit,
      placeholder: (_, _) => const SizedBox.shrink(),
      errorWidget: (_, _, _) => const SizedBox.shrink(),
    );
  }
}

