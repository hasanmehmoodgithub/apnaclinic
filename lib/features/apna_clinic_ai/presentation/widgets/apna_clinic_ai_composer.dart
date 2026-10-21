import 'package:flutter/material.dart';

import '../../../../core/extensions/screen_util_extensions.dart';
import '../constants/apna_clinic_ai_ui_config.dart';

class ApnaClinicAiComposer extends StatelessWidget {
  const ApnaClinicAiComposer({
    super.key,
    required this.controller,
    required this.hintText,
    required this.enabled,
    required this.recording,
    required this.onSend,
    required this.onMicTap,
    this.showMic = true,
  });

  final TextEditingController controller;
  final String hintText;
  final bool enabled;
  final bool recording;
  final bool showMic;
  final VoidCallback onSend;
  final VoidCallback onMicTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(16.w, 0, 16.w, 10.h),
      padding: EdgeInsets.fromLTRB(14.w, 8.h, 8.w, 8.h),
      decoration: BoxDecoration(
        color: ApnaClinicAiUiConfig.panel,
        borderRadius: BorderRadius.circular(22.r),
        border: Border.all(color: ApnaClinicAiUiConfig.borderStrong),
        boxShadow: ApnaClinicAiUiConfig.softShadow,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              enabled: enabled,
              minLines: 1,
              maxLines: 4,
              textInputAction: TextInputAction.send,
              onSubmitted: (_) {
                if (enabled) onSend();
              },
              style: TextStyle(
                color: ApnaClinicAiUiConfig.primaryText,
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                height: 1.35,
              ),
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: TextStyle(
                  color: ApnaClinicAiUiConfig.muted,
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w400,
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.symmetric(vertical: 10.h),
              ),
            ),
          ),
          if (showMic) ...[
            _MicButton(
              recording: recording,
              enabled: enabled || recording,
              onTap: onMicTap,
            ),
            SizedBox(width: 6.w),
          ],
          Material(
            color: enabled || recording
                ? ApnaClinicAiUiConfig.cta
                : ApnaClinicAiUiConfig.border,
            borderRadius: BorderRadius.circular(12.r),
            child: InkWell(
              borderRadius: BorderRadius.circular(12.r),
              onTap: enabled || recording ? onSend : null,
              child: SizedBox(
                width: 40.r,
                height: 40.r,
                child: Icon(
                  Icons.send_rounded,
                  color: ApnaClinicAiUiConfig.panel,
                  size: 18.r,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MicButton extends StatefulWidget {
  const _MicButton({
    required this.recording,
    required this.enabled,
    required this.onTap,
  });

  final bool recording;
  final bool enabled;
  final VoidCallback onTap;

  @override
  State<_MicButton> createState() => _MicButtonState();
}

class _MicButtonState extends State<_MicButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulse;

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    if (widget.recording) _pulse.repeat(reverse: true);
  }

  @override
  void didUpdateWidget(covariant _MicButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.recording && !_pulse.isAnimating) {
      _pulse.repeat(reverse: true);
    } else if (!widget.recording && _pulse.isAnimating) {
      _pulse
        ..stop()
        ..value = 0;
    }
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final recording = widget.recording;
    return Semantics(
      button: true,
      child: Material(
        color: recording
            ? ApnaClinicAiUiConfig.emergencyText
            : ApnaClinicAiUiConfig.mint,
        borderRadius: BorderRadius.circular(12.r),
        child: InkWell(
          borderRadius: BorderRadius.circular(12.r),
          onTap: widget.enabled ? widget.onTap : null,
          child: AnimatedBuilder(
            animation: _pulse,
            builder: (context, child) {
              final scale = recording ? 1 + (_pulse.value * 0.08) : 1.0;
              return Transform.scale(scale: scale, child: child);
            },
            child: SizedBox(
              width: 40.r,
              height: 40.r,
              child: Icon(
                recording ? Icons.stop_rounded : Icons.mic_none_rounded,
                size: 20.r,
                color: recording
                    ? ApnaClinicAiUiConfig.panel
                    : ApnaClinicAiUiConfig.ctaDeep,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
