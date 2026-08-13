import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;

import '../../../../core/constants/app_colors.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';

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
    final displayName = _fileNameFromUrl(prescriptionUrl);

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
              Icon(
                Icons.check_circle_rounded,
                color: AppColors.clr15A9A0,
                size: 22.r,
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.pharmacyPrescriptionUploadedLabel,
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: AppColors.clr060,
                        fontWeight: FontWeight.w700,
                        fontSize: 13.sp,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      displayName,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: AppColors.clr667B99,
                        fontSize: 11.sp,
                      ),
                    ),
                  ],
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

  static String _fileNameFromUrl(String url) {
    final trimmed = url.trim();
    if (trimmed.isEmpty) return trimmed;
    try {
      final uri = Uri.parse(trimmed);
      final name = p.basename(uri.path);
      if (name.isNotEmpty && name != '/' && name != '.') return name;
    } catch (_) {}
    return trimmed;
  }
}
