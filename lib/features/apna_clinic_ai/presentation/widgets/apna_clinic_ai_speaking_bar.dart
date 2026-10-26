import 'package:flutter/material.dart';

import '../../../../core/extensions/screen_util_extensions.dart';
import '../constants/apna_clinic_ai_ui_config.dart';

/// Shown above the composer while an assistant reply is playing.
class ApnaClinicAiSpeakingBar extends StatelessWidget {
  const ApnaClinicAiSpeakingBar({
    super.key,
    required this.playing,
    required this.statusLabel,
    required this.onToggle,
    this.maxLines = 1,
  });

  final bool playing;
  final String statusLabel;
  final VoidCallback onToggle;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    final tall = maxLines > 1;
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 8.h),
      child: Container(
        constraints: BoxConstraints(minHeight: tall ? 56.h : 48.h),
        padding: EdgeInsets.symmetric(
          horizontal: 8.w,
          vertical: tall ? 8.h : 0,
        ),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [ApnaClinicAiUiConfig.cta, ApnaClinicAiUiConfig.ctaDeep],
          ),
          borderRadius: BorderRadius.circular(24.r),
          boxShadow: ApnaClinicAiUiConfig.softShadow,
        ),
        child: Row(
          children: [
            Container(
              width: 32.r,
              height: 32.r,
              decoration: BoxDecoration(
                color: ApnaClinicAiUiConfig.panel.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.volume_up_rounded,
                color: ApnaClinicAiUiConfig.panel,
                size: 18.r,
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(right: 10.w),
                child: Text(
                  statusLabel,
                  maxLines: maxLines,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: ApnaClinicAiUiConfig.panel,
                    fontSize: tall ? 12.sp : 13.sp,
                    height: tall ? 1.25 : 1.2,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            Material(
              color: ApnaClinicAiUiConfig.panel,
              shape: const CircleBorder(),
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: onToggle,
                child: SizedBox(
                  width: 32.r,
                  height: 32.r,
                  child: Icon(
                    playing ? Icons.pause_rounded : Icons.play_arrow_rounded,
                    color: ApnaClinicAiUiConfig.ctaDeep,
                    size: 18.r,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
