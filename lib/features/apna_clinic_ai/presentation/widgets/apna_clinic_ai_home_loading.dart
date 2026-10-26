import 'package:flutter/material.dart';

import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/widgets/apna_clinic_bot_animation.dart';
import '../constants/apna_clinic_ai_ui_config.dart';

/// Centered loading / error body while `/sdk/home` is fetching (header + composer stay).
class ApnaClinicAiHomeLoading extends StatelessWidget {
  const ApnaClinicAiHomeLoading({
    super.key,
    this.errorMessage,
    this.onRetry,
  });

  final String? errorMessage;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final hasError = errorMessage != null && errorMessage!.trim().isNotEmpty;

    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (hasError)
              Icon(
                Icons.wifi_off_rounded,
                size: 48.r,
                color: ApnaClinicAiUiConfig.muted,
              )
            else
              const ApnaClinicBotAnimation(
                headSize: 72,
                style: ApnaClinicBotStyle.femaleAi,
              ),
            SizedBox(height: 12.h),
            Text(
              hasError ? errorMessage! : l10n.apnaClinicAiConnecting,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: hasError
                    ? ApnaClinicAiUiConfig.emergencyText
                    : ApnaClinicAiUiConfig.secondaryText,
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                height: 1.4,
              ),
            ),
            if (hasError && onRetry != null) ...[
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
          ],
        ),
      ),
    );
  }
}
