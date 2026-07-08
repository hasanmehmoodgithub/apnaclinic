import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../generated/assets.dart';

class InstantDoctorConsultationHeaderWidget extends StatelessWidget {
  const InstantDoctorConsultationHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              Assets.imgFreedoctorTitleIcon,
              height: 20.h,
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: Text(
                l10n.instantDoctorConsultationTitle,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: AppColors.clr061E40,
                  fontWeight: FontWeight.w700,
                  fontSize: 18.sp,
                  height: 1.25,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 8.h),
        Text(
          l10n.instantDoctorConsultationSubtitle,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: AppColors.clr43,
            fontSize: 15.sp,
            fontWeight: FontWeight.w500,
            height: 1.35,
          ),
        ),
      ],
    );
  }
}
