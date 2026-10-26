import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../core/extensions/screen_util_extensions.dart';
import '../constants/apna_clinic_ai_ui_config.dart';

/// Home-only speaking UI: centered wave animation + typewriter greeting.
/// Parent should remove this widget when playback completes.
class ApnaClinicAiHomeSpeakingPanel extends StatefulWidget {
  const ApnaClinicAiHomeSpeakingPanel({
    super.key,
    required this.playing,
    required this.text,
    required this.onToggle,
  });

  final bool playing;
  final String text;
  final VoidCallback onToggle;

  @override
  State<ApnaClinicAiHomeSpeakingPanel> createState() =>
      _ApnaClinicAiHomeSpeakingPanelState();
}

class _ApnaClinicAiHomeSpeakingPanelState
    extends State<ApnaClinicAiHomeSpeakingPanel>
    with SingleTickerProviderStateMixin {
  late final AnimationController _wave;
  Timer? _typeTimer;
  var _visibleChars = 0;

  String get _full => widget.text.trim();

  @override
  void initState() {
    super.initState();
    _wave = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _syncWave(widget.playing);
    _startTyping();
  }

  @override
  void didUpdateWidget(covariant ApnaClinicAiHomeSpeakingPanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.playing != widget.playing) {
      _syncWave(widget.playing);
    }
    if (oldWidget.text != widget.text) {
      _startTyping();
    }
  }

  void _syncWave(bool playing) {
    if (playing) {
      if (!_wave.isAnimating) _wave.repeat();
    } else {
      _wave.stop();
    }
  }

  void _startTyping() {
    _typeTimer?.cancel();
    _visibleChars = 0;
    final full = _full;
    if (full.isEmpty) {
      setState(() {});
      return;
    }
    final stepMs = (full.length > 80 ? 22 : 28).clamp(18, 40);
    _typeTimer = Timer.periodic(Duration(milliseconds: stepMs), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      if (_visibleChars >= full.length) {
        timer.cancel();
        return;
      }
      setState(() => _visibleChars += 1);
    });
  }

  @override
  void dispose() {
    _typeTimer?.cancel();
    _wave.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final full = _full;
    final shown = full.isEmpty
        ? ''
        : full.substring(0, _visibleChars.clamp(0, full.length));

    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 10.h),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: widget.onToggle,
          borderRadius: BorderRadius.circular(22.r),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 14.h),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  ApnaClinicAiUiConfig.cta,
                  ApnaClinicAiUiConfig.ctaDeep,
                ],
              ),
              borderRadius: BorderRadius.circular(22.r),
              boxShadow: ApnaClinicAiUiConfig.softShadow,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _SpeakingWave(animation: _wave, active: widget.playing),
                SizedBox(height: 12.h),
                Text(
                  shown.isEmpty ? ' ' : shown,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: ApnaClinicAiUiConfig.panel,
                    fontSize: 13.sp,
                    height: 1.35,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SpeakingWave extends StatelessWidget {
  const _SpeakingWave({required this.animation, required this.active});

  final Animation<double> animation;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36.h,
      child: AnimatedBuilder(
        animation: animation,
        builder: (context, _) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              for (var i = 0; i < 7; i++) ...[
                if (i > 0) SizedBox(width: 4.w),
                _bar(i),
              ],
            ],
          );
        },
      ),
    );
  }

  Widget _bar(int index) {
    final phase = (animation.value * math.pi * 2) - (index * 0.45);
    final level = active ? (math.sin(phase) + 1) / 2 : 0.22;
    final height = 8.h + (22.h * level);
    return AnimatedContainer(
      duration: const Duration(milliseconds: 80),
      width: 4.w,
      height: height,
      decoration: BoxDecoration(
        color: ApnaClinicAiUiConfig.panel.withValues(
          alpha: 0.45 + (0.55 * level),
        ),
        borderRadius: BorderRadius.circular(99.r),
      ),
    );
  }
}
