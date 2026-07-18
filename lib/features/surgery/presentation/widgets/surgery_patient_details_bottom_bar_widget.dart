import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';
import 'surgery_form_error_banner_widget.dart';

class SurgeryPatientDetailsBottomBarWidget extends StatelessWidget {
  const SurgeryPatientDetailsBottomBarWidget({
    super.key,
    required this.isSubmitting,
    required this.canSubmit,
    required this.validationBannerMessage,
    required this.onProceed,
  });

  final bool isSubmitting;
  final bool canSubmit;
  final String? validationBannerMessage;
  final VoidCallback onProceed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return ColoredBox(
      color: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (validationBannerMessage != null)
            SurgeryFormErrorBannerWidget(message: validationBannerMessage!),
          Container(
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(20.w, 14.h, 20.w, 20.h),
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Color.fromRGBO(0, 0, 0, 0.05),
                  blurRadius: 20,
                  offset: Offset(0, -4),
                ),
              ],
            ),
            child: FilledButton(
              onPressed: isSubmitting || !canSubmit ? null : onProceed,
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.clr0FAA9A,
                minimumSize: Size.fromHeight(44.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.r),
                ),
              ),
              child: isSubmitting
                  ? SizedBox(
                      width: 22.r,
                      height: 22.r,
                      child: const CircularProgressIndicator(
                        strokeWidth: 2.4,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Text(
                      l10n.surgeryProceedCheckout,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 13.sp,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
