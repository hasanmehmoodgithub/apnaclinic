import 'package:flutter/material.dart';

import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../constants/apna_clinic_ai_ui_config.dart';

class ApnaClinicAiHomeDisclaimer extends StatelessWidget {
  const ApnaClinicAiHomeDisclaimer({super.key, this.margin});

  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final ink = ApnaClinicAiUiConfig.disclaimerInk;
    return Container(
      width: double.infinity,
      margin: margin ?? EdgeInsets.all(6.h),
      padding: EdgeInsets.fromLTRB(18.w, 18.h, 18.w, 18.h),
      decoration: BoxDecoration(
        color: ApnaClinicAiUiConfig.disclaimerBg,
        borderRadius: BorderRadius.circular(22.r),
        border: Border.all(color: ApnaClinicAiUiConfig.disclaimerBorder),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline_rounded,
                size: 18.r,
                color: ink,
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  l10n.apnaClinicAiDisclaimerTitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: ink,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.4,
                    height: 1.2,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Text(
            l10n.apnaClinicAiDisclaimer,
            textAlign: TextAlign.start,
            style: TextStyle(
              color: ink,
              fontSize: 14.sp,
              height: 1.45,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
