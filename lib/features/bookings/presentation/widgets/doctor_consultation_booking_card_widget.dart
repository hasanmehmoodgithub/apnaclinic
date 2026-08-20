import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/widgets/app_rounded_rating_widget.dart';
import '../../../consultation/presentation/constants/consultation_partner_filter_defaults.dart';
import '../../../consultation/presentation/widgets/consultation_partner_logo_widget.dart';
import '../../data/models/doctor_consultation_booking_details_model.dart';
import '../doctor_consultation_booking_details_args.dart';
import 'doctor_consultation_booking_status_pill_widget.dart';

class DoctorConsultationBookingCardWidget extends StatelessWidget {
  const DoctorConsultationBookingCardWidget({
    super.key,
    required this.item,
  });

  final DoctorConsultationBookingDetailsModel item;

  void _openDetails(BuildContext context) {
    context.pushNamed(
      AppRoutes.doctorConsultationBookingDetails,
      extra: DoctorConsultationBookingDetailsArgs(
        bookingId: item.bookingId,
        booking: item,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _openDetails(context),
        borderRadius: BorderRadius.circular(16.r),
        child: Container(
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
                      item: item,
                      l10n: l10n,
                      textTheme: textTheme,
                      onViewDetailsTap: () => _openDetails(context),
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
    final experienceQualification = [
      if (item.experience.trim().isNotEmpty) item.experience.trim(),
      if (item.qualification.trim().isNotEmpty) item.qualification.trim(),
    ].join(' | ');

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
            if (item.ratings != null)
              AppRoundedRatingWidget(
                rating: item.ratings!,
                textTheme: textTheme,
                width: 56.w,
                height: 24.h,
              ),
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
        if (experienceQualification.isNotEmpty) ...[
          SizedBox(height: 2.h),
          Text(
            experienceQualification,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: textTheme.bodySmall?.copyWith(
              color: AppColors.clr667B99,
              fontSize: 10.sp,
              fontWeight: FontWeight.w300,
              height: 1.2,
            ),
          ),
        ],
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
    final showOriginal = item.discountAmount > 0 && item.originalFee > 0;

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
                  item.totalText,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.bodySmall?.copyWith(
                    color: AppColors.clrBlack,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (showOriginal)
                  Text(
                    'Rs. ${item.originalFee}/-',
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
    required this.item,
    required this.l10n,
    required this.textTheme,
    required this.onViewDetailsTap,
  });

  final DoctorConsultationBookingDetailsModel item;
  final AppLocalizations l10n;
  final TextTheme textTheme;
  final VoidCallback onViewDetailsTap;

  @override
  Widget build(BuildContext context) {
    final known =
        ConsultationPartnerFilterDefaults.knownById(item.partnerTenantId);
    final remoteLogo = item.partnerLogoUrl.trim();
    final logo = remoteLogo.isNotEmpty
        ? remoteLogo
        : (known?.resolvedLogo ?? '');

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
                child: ConsultationPartnerLogoWidget(
                  logoUrl: logo,
                  width: 28.w,
                  height: 28.w,
                  compact: true,
                ),
              ),
            ),
          ),
          SizedBox(height: 10.h),
          SizedBox(
            width: double.infinity,
            height: 33.h,
            child: OutlinedButton(
              onPressed: onViewDetailsTap,
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
    case DoctorConsultationBookingStatus.failed:
      return l10n.bookingsStatusFailed;
    case DoctorConsultationBookingStatus.completed:
      return l10n.bookingsStatusCompleted;
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
