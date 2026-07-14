import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/utils/app_url_launcher.dart';
import '../../data/mappers/doctor_consultation_booking_mapper.dart';

class DoctorConsultationBookingDetailsDocumentsWidget extends StatelessWidget {
  const DoctorConsultationBookingDetailsDocumentsWidget({
    super.key,
    required this.attachments,
  });

  final List<String> attachments;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.bookingsDocumentsTitle,
          style: textTheme.titleMedium?.copyWith(
            color: AppColors.clr061E40,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 8.h),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.clrWhite,
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(color: AppColors.clrE5E8EC),
          ),
          child: Column(
            children: [
              for (var i = 0; i < attachments.length; i++) ...[
                if (i > 0)
                  const Divider(height: 1, color: AppColors.clrE5E8EC),
                InkWell(
                  onTap: () => AppUrlLauncher.open(
                    url: attachments[i],
                    lunchMode: LaunchMode.externalApplication,
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 12.h,
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.insert_drive_file_outlined,
                          size: 20.r,
                          color: AppColors.clr52708E,
                        ),
                        SizedBox(width: 10.w),
                        Expanded(
                          child: Text(
                            DoctorConsultationBookingMapper
                                .attachmentDisplayName(
                              attachments[i],
                              i,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: textTheme.bodyMedium?.copyWith(
                              color: AppColors.clr061E40,
                            ),
                          ),
                        ),
                        Text(
                          l10n.bookingsDownloadCta,
                          style: textTheme.bodyMedium?.copyWith(
                            color: AppColors.clr2F80ED,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
