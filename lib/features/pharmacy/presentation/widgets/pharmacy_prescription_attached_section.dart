import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';
import 'pharmacy_prescription_thumbnail.dart';

/// Shows an already-attached prescription URL on the add-to-cart sheet.
class PharmacyPrescriptionAttachedSection extends StatelessWidget {
  const PharmacyPrescriptionAttachedSection({
    super.key,
    required this.prescriptionUrl,
    required this.onReupload,
  });

  final String prescriptionUrl;
  final VoidCallback onReupload;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.pharmacyPrescriptionUploadedHint,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: AppColors.clr4A4A4A,
            fontSize: 13.sp,
            height: 1.35,
          ),
        ),
        SizedBox(height: 12.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
          decoration: BoxDecoration(
            color: AppColors.clrF5FBFA,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: AppColors.clrC8EEF2),
          ),
          child: Row(
            children: [
              PharmacyPrescriptionThumbnail(
                networkUrl: prescriptionUrl,
                size: 64.r,
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Text(
                  l10n.pharmacyPrescriptionUploadedLabel,
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: AppColors.clr060,
                    fontWeight: FontWeight.w700,
                    fontSize: 13.sp,
                  ),
                ),
              ),
              TextButton(
                onPressed: onReupload,
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.clr15A9A0,
                  padding: EdgeInsets.symmetric(horizontal: 8.w),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  l10n.pharmacyPrescriptionReupload,
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: AppColors.clr15A9A0,
                    fontWeight: FontWeight.w700,
                    fontSize: 12.sp,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
