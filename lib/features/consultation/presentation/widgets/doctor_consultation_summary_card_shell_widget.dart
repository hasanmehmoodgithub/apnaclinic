import 'package:flutter/material.dart';

import '../../../../core/extensions/screen_util_extensions.dart';

class DoctorConsultationSummaryCardShell extends StatelessWidget {
  const DoctorConsultationSummaryCardShell({
    super.key,
    required this.child,
    this.padding,
    this.compact = false,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding ??
          EdgeInsets.symmetric(
            horizontal: 12.w,
            vertical: compact ? 10.h : 12.h,
          ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFFE8EDF2), width: 0.5),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A053453),
            blurRadius: 24,
            offset: Offset(0, 8),
            spreadRadius: -12,
          ),
        ],
      ),
      child: child,
    );
  }
}
