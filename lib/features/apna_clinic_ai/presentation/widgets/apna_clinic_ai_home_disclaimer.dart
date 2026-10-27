import 'package:flutter/material.dart';

import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../constants/apna_clinic_ai_ui_config.dart';

class ApnaClinicAiHomeDisclaimer extends StatelessWidget {
  const ApnaClinicAiHomeDisclaimer({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final ink = ApnaClinicAiUiConfig.cautionText;
    return Container(
      width: double.infinity,
      margin: EdgeInsets.all(6.h),
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: const Color(0xFFFCF6E8),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: ApnaClinicAiUiConfig.caution.withValues(alpha: 0.35),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 32.r,
                height: 32.r,
                decoration: BoxDecoration(
                  color: ApnaClinicAiUiConfig.caution.withValues(alpha: 0.22),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                alignment: Alignment.center,
                child: Icon(
                  Icons.error_outline_rounded,
                  size: 18.r,
                  color: ink,
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  l10n.apnaClinicAiDisclaimerTitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: ink,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.6,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 14.h),
          Text(
            l10n.apnaClinicAiDisclaimer,
            textAlign: TextAlign.left,
            style: TextStyle(
              color: ink.withValues(alpha: 0.92),
              fontSize: 15.sp,
              height: 1.55,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
