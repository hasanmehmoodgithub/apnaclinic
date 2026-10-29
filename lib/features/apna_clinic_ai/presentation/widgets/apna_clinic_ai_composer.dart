import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/extensions/screen_util_extensions.dart';
import '../constants/apna_clinic_ai_ui_config.dart';
import 'apna_clinic_ai_moving_stroke.dart';

class _MaxLinesInputFormatter extends TextInputFormatter {
  const _MaxLinesInputFormatter(this.maxLines);

  final int maxLines;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final lineCount = '\n'.allMatches(newValue.text).length + 1;
    return lineCount <= maxLines ? newValue : oldValue;
  }
}

class ApnaClinicAiComposer extends StatelessWidget {
  const ApnaClinicAiComposer({
    super.key,
    required this.controller,
    required this.hintText,
    required this.enabled,
    required this.recording,
    required this.onSend,
    required this.onMicTap,
    this.micEnabled,
    this.showMic = true,
    this.prominent = false,
    this.focusNode,
    this.onTap,
  });

  final TextEditingController controller;
  final String hintText;
  final bool enabled;
  final bool recording;
  /// Mic stays tappable while a reply is still streaming.
  final bool? micEnabled;
  final bool showMic;
  /// Larger home input with a moving teal stroke.
  final bool prominent;
  final VoidCallback onSend;
  final VoidCallback onMicTap;
  final FocusNode? focusNode;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final actionSize = prominent ? 44.r : 36.r;
    final radius = 28.r;
    final actionRadius = actionSize / 2;
    final field = _ComposerField(
      controller: controller,
      hintText: hintText,
      enabled: enabled,
      recording: recording,
      showMic: showMic,
      prominent: prominent,
      focusNode: focusNode,
      onTap: onTap,
      onSend: onSend,
      onMicTap: onMicTap,
      micEnabled: micEnabled ?? enabled,
      actionSize: actionSize,
      actionRadius: actionRadius,
    );

    if (!prominent) {
      return Container(
        margin: EdgeInsets.fromLTRB(16.w, 0, 16.w, 10.h),
        padding: EdgeInsets.fromLTRB(16.w, 6.h, 6.w, 6.h),
        decoration: BoxDecoration(
          color: ApnaClinicAiUiConfig.panel,
          borderRadius: BorderRadius.circular(radius),
          border: Border.all(color: ApnaClinicAiUiConfig.cta, width: 1.4),
        ),
        child: field,
      );
    }

    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 6.h, 16.w, 24.h),
      child: ApnaClinicAiMovingStroke(
        borderRadius: radius,
        strokeWidth: 1.2,
        includeWhite: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(16.w, 12.h, 10.w, 12.h),
          child: field,
        ),
      ),
    );
  }
}

class _ComposerField extends StatelessWidget {
  const _ComposerField({
    required this.controller,
    required this.hintText,
    required this.enabled,
    required this.recording,
    required this.showMic,
    required this.prominent,
    required this.onSend,
    required this.onMicTap,
    required this.micEnabled,
    required this.actionSize,
    required this.actionRadius,
    this.focusNode,
    this.onTap,
  });

  final TextEditingController controller;
  final String hintText;
  final bool enabled;
  final bool recording;
  final bool showMic;
  final bool prominent;
  final VoidCallback onSend;
  final VoidCallback onMicTap;
  final bool micEnabled;
  final double actionSize;
  final double actionRadius;
  final FocusNode? focusNode;
  final VoidCallback? onTap;

  /// Fits up to 2 hint/input lines, at least as tall as mic/send.
  double get _prominentFieldHeight {
    final twoLines = (15.sp * 1.3 * 2) + 8.h;
    return twoLines > actionSize ? twoLines : actionSize;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: SizedBox(
            height: prominent ? _prominentFieldHeight : null,
              child: Align(
              alignment: Alignment.centerLeft,
              child: TextField(
                controller: controller,
                focusNode: focusNode,
                enabled: enabled,
                expands: prominent,
                minLines: prominent ? null : 1,
                maxLines: prominent ? null : 4,
                onTap: onTap,
                textAlign: TextAlign.left,
                textAlignVertical: TextAlignVertical.center,
                textInputAction: TextInputAction.send,
                onSubmitted: (_) {
                  if (enabled) onSend();
                },
                style: TextStyle(
                  color: ApnaClinicAiUiConfig.primaryText,
                  fontSize: prominent ? 16.sp : 14.sp,
                  fontWeight: FontWeight.w500,
                  height: 1.3,
                ),
                decoration: InputDecoration(
                  hintText: hintText,
                  hintMaxLines: 2,
                  hintStyle: TextStyle(
                    color: ApnaClinicAiUiConfig.muted,
                    fontSize: prominent ? 15.sp : 13.sp,
                    fontWeight: FontWeight.w400,
                    height: 1.3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(
                    vertical: prominent ? 0 : 10.h,
                  ),
                ),
                inputFormatters: prominent
                    ? const [_MaxLinesInputFormatter(2)]
                    : null,
              ),
            ),
          ),
        ),
        if (showMic) ...[
          _MicButton(
            recording: recording,
            enabled: micEnabled || recording,
            onTap: onMicTap,
            size: actionSize,
            borderRadius: actionRadius,
            iconSize: prominent ? 26.r : 20.r,
          ),
          SizedBox(width: prominent ? 8.w : 6.w),
        ],
        Material(
          color: enabled || recording
              ? ApnaClinicAiUiConfig.cta
              : ApnaClinicAiUiConfig.border,
          borderRadius: BorderRadius.circular(actionRadius),
          child: InkWell(
            borderRadius: BorderRadius.circular(actionRadius),
            onTap: enabled || recording ? onSend : null,
            child: SizedBox(
              width: actionSize,
              height: actionSize,
              child: Icon(
                Icons.send_rounded,
                color: ApnaClinicAiUiConfig.panel,
                size: prominent ? 24.r : 18.r,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _MicButton extends StatefulWidget {
  const _MicButton({
    required this.recording,
    required this.enabled,
    required this.onTap,
    required this.size,
    required this.borderRadius,
    required this.iconSize,
  });

  final bool recording;
  final bool enabled;
  final VoidCallback onTap;
  final double size;
  final double borderRadius;
  final double iconSize;

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
            : ApnaClinicAiUiConfig.ctaSoft,
        borderRadius: BorderRadius.circular(widget.borderRadius),
        child: InkWell(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          onTap: widget.enabled ? widget.onTap : null,
          child: AnimatedBuilder(
            animation: _pulse,
            builder: (context, child) {
              final scale = recording ? 1 + (_pulse.value * 0.08) : 1.0;
              return Transform.scale(scale: scale, child: child);
            },
            child: SizedBox(
              width: widget.size,
              height: widget.size,
              child: Icon(
                recording ? Icons.stop_rounded : Icons.mic_none_rounded,
                size: widget.iconSize,
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
