import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_text_styles.dart';
import '../../extensions/screen_util_extensions.dart';
import '../../l10n/app_localizations.dart';
import 'security_brand_header.dart';

class SecurityBlockedView extends StatelessWidget {
  const SecurityBlockedView({
    super.key,
    required this.message,
    required this.countdown,
    required this.totalSeconds,
  });

  final String? message;
  final int countdown;
  final int totalSeconds;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final progress = totalSeconds <= 0
        ? 0.0
        : (countdown / totalSeconds).clamp(0.0, 1.0);

    return Scaffold(
      backgroundColor: AppColors.clrF5FBFA,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
            child: Column(
              children: [
                const SecurityBrandHeader(),
                SizedBox(height: 32.h),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.fromLTRB(20.w, 28.h, 20.w, 24.h),
                  decoration: BoxDecoration(
                    color: AppColors.clrWhite,
                    borderRadius: BorderRadius.circular(20.r),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.clr061E40.withValues(alpha: 0.06),
                        blurRadius: 24,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: 72.r,
                        height: 72.r,
                        decoration: const BoxDecoration(
                          color: AppColors.clrFBDEDE,
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.shield_outlined,
                          size: 36.r,
                          color: AppColors.clrBA2025,
                        ),
                      ),
                      SizedBox(height: 18.h),
                      Text(
                        l10n.securityGateAccessDenied,
                        textAlign: TextAlign.center,
                        style: AppTextStyles.securityTitle,
                      ),
                      SizedBox(height: 10.h),
                      Text(
                        message ?? l10n.securityGateFallbackMessage,
                        textAlign: TextAlign.center,
                        style: AppTextStyles.securityBody,
                      ),
                      SizedBox(height: 28.h),
                      SizedBox(
                        width: 96.r,
                        height: 96.r,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            SizedBox.expand(
                              child: CircularProgressIndicator(
                                value: progress,
                                strokeWidth: 6.r,
                                strokeCap: StrokeCap.round,
                                color: AppColors.clr0FAA9A,
                                backgroundColor: AppColors.clrC7EFEB,
                              ),
                            ),
                            Text(
                              '$countdown',
                              style: AppTextStyles.securityCountdown,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 16.h),
                      Text(
                        l10n.securityGateWillCloseIn(countdown),
                        textAlign: TextAlign.center,
                        style: AppTextStyles.securityCaption,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
