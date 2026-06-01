import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/widgets/app_button_widget.dart';

class LabTestCheckoutBottomBarWidget extends StatelessWidget {
  const LabTestCheckoutBottomBarWidget({
    super.key,
    required this.onProceed,
    this.errorMessage,
  });

  final VoidCallback onProceed;
  final String? errorMessage;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 14, 24, 8),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.07),
            offset: const Offset(0, -5),
            blurRadius: 30,
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Text(
                  errorMessage!,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: const Color(0xFFD72222),
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            AppButtonWidget(
              title: AppLocalizations.of(context)!.labTestBookCta,
              bgClr: AppColors.clr1FAFA3,
              onTap: onProceed,
            ),
          ],
        ),
      ),
    );
  }
}
