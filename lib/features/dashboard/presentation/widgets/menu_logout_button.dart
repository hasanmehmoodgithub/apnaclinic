import 'package:flutter/material.dart';

import '../../../../components/widgets/app_button.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';

class MenuLogoutButton extends StatelessWidget {
  const MenuLogoutButton({
    super.key,
    required this.onPressed,
  });

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: EdgeInsets.fromLTRB(29.w, 0, 29.w, 11.h),
      child: SizedBox(
        width: double.infinity,
        child: AppButton.primary(
          text: l10n.dashboardMenuLogout,
          onPressed: onPressed,
          backgroundColor: AppColors.clr40AFA2,
          foregroundColor: AppColors.clrWhite,
          elevation: 0,
          height: 62.h,
          borderRadius: 13.r,
          fontWeight: FontWeight.w700,
          fontSize: 18.sp,
          width: double.infinity,
        ),
      ),
    );
  }
}
