import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../consultation/presentation/widgets/consultation_partner_logo_widget.dart';
import '../../../instant_doctor/domain/entities/instant_doctor_booking_entity.dart';
import 'instant_doctor_booking_prescription_sheet.dart';
import 'instant_doctor_booking_status_pill_widget.dart';

class InstantDoctorBookingCardWidget extends StatelessWidget {
  const InstantDoctorBookingCardWidget({
    super.key,
    required this.item,
  });

  final InstantDoctorBookingEntity item;

  void _openPrescription(BuildContext context) {
    InstantDoctorBookingPrescriptionSheet.show(context, booking: item);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _openPrescription(context),
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
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            item.displayDoctorName,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: textTheme.titleMedium?.copyWith(
                              color: AppColors.clr060,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                              height: 1.15,
                            ),
                          ),
                          if (item.specialty.trim().isNotEmpty) ...[
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
                          ],
                          if (item.listDate.isNotEmpty) ...[
                            SizedBox(height: 6.h),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8.w,
                                vertical: 4.h,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: AppColors.clr9BA6A7,
                                  width: 0.5,
                                ),
                                borderRadius: BorderRadius.circular(40.r),
                              ),
                              child: Text(
                                item.listDate,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: textTheme.bodySmall?.copyWith(
                                  color: AppColors.clr667B99,
                                  fontSize: 11.sp,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    SizedBox(width: 8.w),
                    SizedBox(
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
                                  logoUrl: item.partnerImageUrl,
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
                              onPressed: () => _openPrescription(context),
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(
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
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                IntrinsicHeight(
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
                              child: InstantDoctorBookingStatusPillWidget(
                                status: item.status,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (!item.isFree) ...[
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
                                item.feeLabel,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: textTheme.bodySmall?.copyWith(
                                  color: AppColors.clrBlack,
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
