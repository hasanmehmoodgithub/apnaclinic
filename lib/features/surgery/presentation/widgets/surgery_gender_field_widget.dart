import 'package:flutter/material.dart';

import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';

class SurgeryGenderFieldWidget extends StatelessWidget {
  const SurgeryGenderFieldWidget({
    super.key,
    required this.selectedGender,
    required this.onTap,
    this.hasError = false,
  });

  final String? selectedGender;
  final VoidCallback onTap;
  final bool hasError;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final displayText = switch (selectedGender) {
      'male' => l10n.commonMale,
      'female' => l10n.commonFemale,
      _ => null,
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.profileGenderLabel,
          style: theme.textTheme.bodyLarge?.copyWith(
            color: const Color(0xFF061E40),
            fontSize: 13.sp,
          ),
        ),
        SizedBox(height: 8.h),
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(10),
          child: Container(
            height: 40.h,
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            decoration: BoxDecoration(
              color: hasError ? const Color(0xFFFFF8F8) : const Color(0xFFF1F1F1),
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              border: Border(
                bottom: BorderSide(
                  color: hasError ? const Color(0xFF852221) : Colors.transparent,
                  width: 0.6,
                ),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    displayText ?? l10n.profileGenderHint,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: hasError
                          ? const Color(0xFFBA2025)
                          : displayText == null
                          ? const Color(0xFFB6BDC8)
                          : const Color(0xFF4A555F),
                      fontSize: 12.sp,
                      fontWeight:
                          displayText == null ? FontWeight.w400 : FontWeight.w500,
                    ),
                  ),
                ),
                Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: const Color(0xFFB6BDC8),
                  size: 18.r,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
