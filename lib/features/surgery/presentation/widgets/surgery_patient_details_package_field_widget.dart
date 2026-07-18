import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';
import 'surgery_option.dart';

class SurgeryPatientDetailsPackageFieldWidget extends StatelessWidget {
  const SurgeryPatientDetailsPackageFieldWidget({
    super.key,
    required this.selected,
    required this.isLoading,
    required this.onTap,
  });

  final SurgeryOption selected;
  final bool isLoading;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          l10n.surgeryLabel,
          style: theme.textTheme.bodyLarge?.copyWith(
            color: AppColors.clr061E40,
            fontSize: 13.sp,
          ),
        ),
        SizedBox(height: 10.h),
        InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: onTap,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              color: Color(0xFFF1F1F1),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    selected.name,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: AppColors.clr061E40,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                if (isLoading)
                  SizedBox(
                    width: 16.r,
                    height: 16.r,
                    child: const CircularProgressIndicator(strokeWidth: 2),
                  )
                else ...[
                  Text(
                    selected.price,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: AppColors.clr061E40,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Transform.scale(
                    scale: 1.2,
                    child: Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: const Color(0xFFB6BDC8),
                      size: 14.r,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}
