import 'package:flutter/material.dart';

import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../generated/assets.dart';
import '../constants/apna_clinic_ai_ui_config.dart';

/// Starter chips above the composer until the user sends the first message.
class ApnaClinicAiSuggestionRow extends StatelessWidget {
  const ApnaClinicAiSuggestionRow({
    super.key,
    required this.suggestions,
    required this.onTap,
  });

  final List<String> suggestions;
  final ValueChanged<String> onTap;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: EdgeInsets.fromLTRB(16.w, 4.h, 16.w, 8.h),
        child: Wrap(
          alignment: WrapAlignment.start,
          textDirection: TextDirection.ltr,
          spacing: 8.w,
          runSpacing: 8.h,
          children: [
            for (final label in suggestions)
              _SuggestionChip(
                label: label,
                onTap: () => onTap(label),
              ),
          ],
        ),
      ),
    );
  }
}

String? _chipIconAsset(String label) {
  final lower = label.toLowerCase();
  if (lower.contains('doctor') || lower.contains('ڈاکٹر')) {
    return Assets.imgApnaClinicAiChipDoctor;
  }
  if (lower.contains('medicine') ||
      lower.contains('دوا') ||
      lower.contains('pharmacy')) {
    return Assets.imgApnaClinicAiChipMedicine;
  }
  return null;
}

class _SuggestionChip extends StatelessWidget {
  const _SuggestionChip({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final iconAsset = _chipIconAsset(label);
    return Material(
      color: ApnaClinicAiUiConfig.panel,
      borderRadius: BorderRadius.circular(24.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24.r),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24.r),
            border: Border.all(color: ApnaClinicAiUiConfig.borderStrong),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (iconAsset != null)
                Image.asset(
                  iconAsset,
                  width: 22.r,
                  height: 22.r,
                  filterQuality: FilterQuality.high,
                )
              else
                Icon(
                  Icons.chat_bubble_outline,
                  size: 18.r,
                  color: ApnaClinicAiUiConfig.ctaDeep,
                ),
              SizedBox(width: 6.w),
              Text(
                label,
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                  color: ApnaClinicAiUiConfig.primaryText,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
