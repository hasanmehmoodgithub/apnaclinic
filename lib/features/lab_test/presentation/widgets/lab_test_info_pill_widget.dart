import 'package:flutter/material.dart';

import '../../../../core/extensions/screen_util_extensions.dart';

/// Small pill used for requirement and sample type on browse cards.
class LabTestInfoPillWidget extends StatelessWidget {
  const LabTestInfoPillWidget({
    super.key,
    required this.value,
    this.highlight = false,
  });

  final String value;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: highlight ? const Color(0xFFB7EAC3) : Colors.white,
        borderRadius: BorderRadius.circular(59.r),
        border: highlight
            ? null
            : Border.all(color: const Color(0xFFE7E7E7), width: 1.0),
      ),
      child: Text(
        value,
        style: theme.textTheme.bodySmall?.copyWith(
          color: highlight ? const Color(0xFF198733) : const Color(0xFF9A9A9A),
          fontSize: 13.sp,
          height: 1.1,
        ),
      ),
    );
  }
}
