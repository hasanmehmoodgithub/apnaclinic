import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';

class InfoTilesRow extends StatelessWidget {
  const InfoTilesRow({
    super.key,
    required this.gender,
    required this.dob,
    required this.email,
  });

  final String gender;
  final String dob;
  final String email;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return IntrinsicHeight(
      child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 94.w,
          child: InfoTile(
            title: l10n.profileGenderLabel,
            value: gender,
            minWidth: 94.w,
          ),
        ),
        SizedBox(width: 8.w),
        SizedBox(
          width: 146.w,
          child: InfoTile(
            title: l10n.profileDobLabel,
            value: dob,
            minWidth: 146.w,
          ),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: InfoTile(title: l10n.profileEmailLabel, value: email, minWidth: 0),
        ),
      ],
      ),
    );
  }
}

class InfoTile extends StatelessWidget {
  const InfoTile({
    super.key,
    required this.title,
    required this.value,
    required this.minWidth,
  });

  final String title;
  final String value;
  final double minWidth;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      constraints: BoxConstraints(minWidth: minWidth, minHeight: 68.h),
      padding: EdgeInsets.fromLTRB(12.w, 8.h, 12.w, 8.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: AppColors.clrC9CFD7, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodySmall?.copyWith(
              color: AppColors.clr7A91AE,
              fontSize: 11.sp,
              fontWeight: FontWeight.w500,
              height: 1,
            ),
          ),
          SizedBox(height: 5.h),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.titleMedium?.copyWith(
              color: AppColors.clr2B2C58,
              fontWeight: FontWeight.w500,
              fontSize: 16.sp,
              height: 1,
            ),
          ),
        ],
      ),
    );
  }
}
