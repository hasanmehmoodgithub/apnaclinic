import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../core/extensions/screen_util_extensions.dart';
import '../../data/services/apna_clinic_ai_audio_recorder_service.dart';
import '../constants/apna_clinic_ai_ui_config.dart';

/// Recording composer: delete, sound wave, elapsed time, and send.
class ApnaClinicAiListeningBar extends StatefulWidget {
  const ApnaClinicAiListeningBar({
    super.key,
    required this.onCancel,
    required this.onSend,
  });

  final VoidCallback onCancel;
  final VoidCallback onSend;

  @override
  State<ApnaClinicAiListeningBar> createState() =>
      _ApnaClinicAiListeningBarState();
}

class _ApnaClinicAiListeningBarState extends State<ApnaClinicAiListeningBar>
    with SingleTickerProviderStateMixin {
  late final AnimationController _motion;
  late final DateTime _started;
  Timer? _clock;

  @override
  void initState() {
    super.initState();
    _started = DateTime.now();
    _motion = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat();
    _clock = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _clock?.cancel();
    _motion.dispose();
    super.dispose();
  }

  String get _elapsed {
    final max = ApnaClinicAiAudioRecorderService.maxDuration;
    final passed = DateTime.now().difference(_started);
    final capped = passed > max ? max : passed;
    final minutes = capped.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = capped.inSeconds.remainder(60).toString().padLeft(2, '0');
    final maxSeconds = max.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds / 0:$maxSeconds';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 10.h),
      child: Container(
        height: 58.h,
        padding: EdgeInsets.symmetric(horizontal: 8.w),
        decoration: BoxDecoration(
          color: ApnaClinicAiUiConfig.panel,
          borderRadius: BorderRadius.circular(29.r),
          border: Border.all(color: ApnaClinicAiUiConfig.borderStrong),
          boxShadow: ApnaClinicAiUiConfig.softShadow,
        ),
        child: Row(
          children: [
            _RoundButton(
              background: ApnaClinicAiUiConfig.emergencyBg,
              onTap: widget.onCancel,
              child: Icon(
                Icons.delete_outline_rounded,
                color: ApnaClinicAiUiConfig.emergencyText,
                size: 20.r,
              ),
            ),
            SizedBox(width: 8.w),
            Expanded(child: _VoiceWave(animation: _motion)),
            SizedBox(width: 8.w),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: ApnaClinicAiUiConfig.mint,
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Text(
                _elapsed,
                style: TextStyle(
                  color: ApnaClinicAiUiConfig.primaryText,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w700,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
            ),
            SizedBox(width: 8.w),
            _RoundButton(
              background: ApnaClinicAiUiConfig.cta,
              onTap: widget.onSend,
              child: Icon(
                Icons.arrow_upward_rounded,
                color: ApnaClinicAiUiConfig.panel,
                size: 22.r,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RoundButton extends StatelessWidget {
  const _RoundButton({
    required this.background,
    required this.onTap,
    required this.child,
  });

  final Color background;
  final VoidCallback onTap;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: background,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: SizedBox(
          width: 40.r,
          height: 40.r,
          child: Center(child: child),
        ),
      ),
    );
  }
}

class _VoiceWave extends StatelessWidget {
  const _VoiceWave({required this.animation});

  final Animation<double> animation;

  static const _count = 18;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 28.h,
      child: AnimatedBuilder(
        animation: animation,
        builder: (context, _) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              for (var i = 0; i < _count; i++) ...[
                if (i > 0) SizedBox(width: 2.5.w),
                _bar(i),
              ],
            ],
          );
        },
      ),
    );
  }

  Widget _bar(int index) {
    final place = index / (_count - 1);
    final envelope = math.sin(place * math.pi);
    final wobble =
        0.5 +
        0.5 * math.sin((animation.value * math.pi * 2) + (index * 0.7));
    final height = (4.h + (18.h * envelope * wobble)).clamp(3.0, 26.h);
    final color = Color.lerp(
      ApnaClinicAiUiConfig.cta,
      ApnaClinicAiUiConfig.online,
      place,
    )!;
    return Container(
      width: 3.w,
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(2.r),
      ),
    );
  }
}
