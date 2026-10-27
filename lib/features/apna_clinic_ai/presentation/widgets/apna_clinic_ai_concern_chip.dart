import 'package:flutter/material.dart';

import '../../../../core/extensions/screen_util_extensions.dart';
import '../constants/apna_clinic_ai_ui_config.dart';

class ApnaClinicAiConcernSection extends StatelessWidget {
  const ApnaClinicAiConcernSection({
    super.key,
    required this.title,
    required this.trailing,
    required this.concerns,
    required this.onTap,
  });

  final String title;
  final String trailing;
  final List<String> concerns;
  final ValueChanged<String> onTap;

  @override
  Widget build(BuildContext context) {
    if (concerns.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 18.h),
        Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w700,
                  color: ApnaClinicAiUiConfig.primaryText,
                  letterSpacing: -0.2,
                ),
              ),
            ),
            Text(
              trailing,
              style: TextStyle(
                fontSize: 11.sp,
                fontWeight: FontWeight.w500,
                color: ApnaClinicAiUiConfig.muted,
              ),
            ),
          ],
        ),
        SizedBox(height: 10.h),
        Wrap(
          spacing: 8.w,
          runSpacing: 8.h,
          children: [
            for (final concern in concerns)
              ApnaClinicAiConcernChip(
                label: concern,
                onTap: () => onTap(concern),
              ),
          ],
        ),
      ],
    );
  }
}

class ApnaClinicAiConcernChip extends StatelessWidget {
  const ApnaClinicAiConcernChip({
    super.key,
    required this.label,
    required this.onTap,
  });

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: ApnaClinicAiUiConfig.panel,
      borderRadius: BorderRadius.circular(12.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.r),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 9.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: ApnaClinicAiUiConfig.borderStrong),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: ApnaClinicAiUiConfig.primaryText,
            ),
          ),
        ),
      ),
    );
  }
}
