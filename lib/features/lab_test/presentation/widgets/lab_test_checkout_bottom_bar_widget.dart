import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/widgets/app_button_widget.dart';
import 'lab_test_checkout_error_banner_widget.dart';

class LabTestCheckoutBottomBarWidget extends StatelessWidget {
  const LabTestCheckoutBottomBarWidget({
    super.key,
    required this.onProceed,
    this.errorMessage,
    this.isBusy = false,
  });

  final VoidCallback onProceed;
  final String? errorMessage;
  final bool isBusy;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(24.w, 8.h, 24.w, 8.h),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (errorMessage != null)
              Padding(
                padding: EdgeInsets.only(bottom: 10.h),
                child: LabTestCheckoutErrorBannerWidget(message: errorMessage!),
              ),
            AppButtonWidget(
              title: AppLocalizations.of(context)!.labTestBookCta,
              bgClr: AppColors.clr1FAFA3,
              onTap: isBusy ? null : onProceed,
            ),
          ],
        ),
      ),
    );
  }
}
