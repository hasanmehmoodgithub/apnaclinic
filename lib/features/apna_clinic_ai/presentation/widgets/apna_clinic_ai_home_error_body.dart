import 'package:flutter/material.dart';

import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../constants/apna_clinic_ai_ui_config.dart';

class ApnaClinicAiHomeErrorBody extends StatelessWidget {
  const ApnaClinicAiHomeErrorBody({
    super.key,
    required this.message,
    required this.onRetry,
  });

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: ApnaClinicAiUiConfig.emergencyText,
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                height: 1.4,
              ),
            ),
            SizedBox(height: 16.h),
            Material(
              color: ApnaClinicAiUiConfig.cta,
              borderRadius: BorderRadius.circular(14.r),
              child: InkWell(
                onTap: onRetry,
                borderRadius: BorderRadius.circular(14.r),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 22.w,
                    vertical: 12.h,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.refresh_rounded,
                        size: 18.r,
                        color: ApnaClinicAiUiConfig.panel,
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        l10n.commonRetry,
                        style: TextStyle(
                          color: ApnaClinicAiUiConfig.panel,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
