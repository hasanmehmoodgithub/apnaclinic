import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/router/app_routes.dart';
import '../../data/models/doctor_consultation_booking_details_model.dart';
import '../doctor_consultation_booking_details_args.dart';
import 'doctor_consultation_booking_status_pill_widget.dart';

class DoctorConsultationBookingCardWidget extends StatelessWidget {
  const DoctorConsultationBookingCardWidget({
    super.key,
    required this.item,
  });

  final DoctorConsultationBookingDetailsModel item;

  static const String _partnerLogoUrl =
      'https://www.figma.com/api/mcp/asset/705ed652-7c25-48fd-916b-375e85a43137';

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.clrWhite,
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _DoctorPhoto(imageUrl: item.doctorImageUrl),
                SizedBox(width: 10.w),
                Expanded(
                  child: _DoctorSummarySection(
                    item: item,
                    textTheme: textTheme,
                  ),
                ),
                SizedBox(width: 8.w),
                _CardActionsColumn(
                  l10n: l10n,
                  textTheme: textTheme,
                  item: item,
                ),
              ],
            ),
            SizedBox(height: 8.h),
            _StatusFeeRow(
              item: item,
              l10n: l10n,
              textTheme: textTheme,
            ),
          ],
        ),
      ),
    );
  }
}

class _DoctorPhoto extends StatelessWidget {
  const _DoctorPhoto({required this.imageUrl});

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 72.w,
      height: 96.h,
      decoration: BoxDecoration(
        color: const Color(0xFFF4F4F4),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10.r),
        child: CachedNetworkImage(
          imageUrl: imageUrl,
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
    );
  }
}

class _DoctorSummarySection extends StatelessWidget {
  const _DoctorSummarySection({
    required this.item,
    required this.textTheme,
  });

  final DoctorConsultationBookingDetailsModel item;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Wrap(
          spacing: 6.w,
          runSpacing: 4.h,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Text(
              item.doctorName,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: textTheme.titleMedium?.copyWith(
                color: AppColors.clr060,
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                height: 1.15,
              ),
            ),
            _RatingBadge(textTheme: textTheme),
          ],
        ),
        SizedBox(height: 2.h),
        Text(
          item.specialty,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: textTheme.bodyMedium?.copyWith(
            color: AppColors.clr667B99,
            fontSize: 12.sp,
            fontWeight: FontWeight.w400,
          ),
        ),
        SizedBox(height: 2.h),
        Text(
          '${item.experience} | ${item.qualification}',
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: textTheme.bodySmall?.copyWith(
            color: AppColors.clr667B99,
            fontSize: 10.sp,
            fontWeight: FontWeight.w300,
            height: 1.2,
          ),
        ),
        SizedBox(height: 6.h),
        Wrap(
          spacing: 5.w,
          runSpacing: 4.h,
          children: [
            _InfoPill(label: item.listDate, textTheme: textTheme),
            _InfoPill(label: item.listTime, textTheme: textTheme),
          ],
        ),
      ],
    );
  }
}

class _StatusFeeRow extends StatelessWidget {
  const _StatusFeeRow({
    required this.item,
    required this.l10n,
    required this.textTheme,
  });

  final DoctorConsultationBookingDetailsModel item;
  final AppLocalizations l10n;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${l10n.bookingsStatusLabel}:',
                  style: textTheme.bodySmall?.copyWith(
                    color: AppColors.clr667B99,
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: 4.h),
                Align(
                  alignment: Alignment.centerLeft,
                  child: DoctorConsultationBookingStatusPillWidget(
                    status: item.status,
                    label: _localizedStatus(item.status, l10n),
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 0.5,
            margin: EdgeInsets.symmetric(horizontal: 10.w),
            color: AppColors.clr9BA6A7,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  l10n.bookingsFeeLabel,
                  style: textTheme.bodySmall?.copyWith(
                    color: AppColors.clr667B99,
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  'Rs.${item.consultationFee}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.bodySmall?.copyWith(
                    color: AppColors.clrBlack,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  'Rs. ${item.consultationFee + item.discountAmount}/-',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.bodySmall?.copyWith(
                    color: const Color(0xFF979797),
                    fontSize: 11.sp,
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CardActionsColumn extends StatelessWidget {
  const _CardActionsColumn({
    required this.l10n,
    required this.textTheme,
    required this.item,
  });

  final AppLocalizations l10n;
  final TextTheme textTheme;
  final DoctorConsultationBookingDetailsModel item;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 76.w,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 34.w,
            height: 34.w,
            decoration: BoxDecoration(
              color: AppColors.clrWhite,
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color(0x36000000),
                width: 0.4,
              ),
            ),
            child: ClipOval(
              child: Padding(
                padding: EdgeInsets.all(3.w),
                child: CachedNetworkImage(
                  imageUrl: DoctorConsultationBookingCardWidget._partnerLogoUrl,
                  fit: BoxFit.contain,
                  placeholder: (_, _) => const SizedBox.shrink(),
                  errorWidget: (_, _, _) => const SizedBox.shrink(),
                ),
              ),
            ),
          ),
          SizedBox(height: 10.h),
          SizedBox(
            width: double.infinity,
            height: 33.h,
            child: OutlinedButton(
              onPressed: () => context.pushNamed(
                AppRoutes.doctorConsultationBookingDetails,
                extra: DoctorConsultationBookingDetailsArgs(
                  bookingId: item.bookingId,
                  booking: item,
                ),
              ),
              style: OutlinedButton.styleFrom(
                side: BorderSide(
                  color: AppColors.clr9BA6A7,
                  width: 0.5,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  l10n.bookingsViewDetailsCta,
                  maxLines: 1,
                  style: textTheme.bodySmall?.copyWith(
                    color: AppColors.clr060,
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
        ],
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

class _RatingBadge extends StatelessWidget {
  const _RatingBadge({required this.textTheme});

  final TextTheme textTheme;

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
          color: AppColors.clr667B99,
          fontSize: 9.sp,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _InfoPill extends StatelessWidget {
  const _InfoPill({
    required this.label,
    required this.textTheme,
  });

  final String label;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.clr9BA6A7, width: 0.5),
        borderRadius: BorderRadius.circular(40.r),
      ),
      child: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: textTheme.bodySmall?.copyWith(
          color: AppColors.clr667B99,
          fontSize: 11.sp,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}
