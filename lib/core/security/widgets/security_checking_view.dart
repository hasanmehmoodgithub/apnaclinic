import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_text_styles.dart';
import '../../extensions/screen_util_extensions.dart';
import '../../l10n/app_localizations.dart';
import 'security_brand_header.dart';

class SecurityCheckingView extends StatelessWidget {
  const SecurityCheckingView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: AppColors.clrF5FBFA,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 32.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SecurityBrandHeader(),
                SizedBox(height: 40.h),
                SizedBox(
                  width: 36.r,
                  height: 36.r,
                  child: CircularProgressIndicator(
                    strokeWidth: 3.r,
                    color: AppColors.clr0FAA9A,
                    backgroundColor: AppColors.clrC7EFEB,
                  ),
                ),
                SizedBox(height: 16.h),
                Text(
                  l10n.securityGateChecking,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.securityCaption,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
