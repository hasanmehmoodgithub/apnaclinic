import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../../../../components/shimmer/app_shimmer.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../domain/entities/apna_clinic_ai_message_entity.dart';
import '../apna_clinic_ai_copy.dart';
import '../constants/apna_clinic_ai_ui_config.dart';
import 'apna_clinic_ai_bot_avatar.dart';
import 'apna_clinic_ai_markdown_text.dart';

class ApnaClinicAiMessageBubble extends StatelessWidget {
  const ApnaClinicAiMessageBubble({
    super.key,
    required this.message,
    this.audioPlaying = false,
    this.onPlayAudio,
  });

  final ApnaClinicAiMessageEntity message;
  final bool audioPlaying;
  final VoidCallback? onPlayAudio;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isUser = message.role == ApnaClinicAiMessageRole.user;
    final isSystem = message.role == ApnaClinicAiMessageRole.system;
    final align = isUser ? Alignment.centerRight : Alignment.centerLeft;
    final color = isUser
        ? ApnaClinicAiUiConfig.userBubble
        : isSystem
        ? ApnaClinicAiUiConfig.systemBubble
        : ApnaClinicAiUiConfig.botBubble;
    final textColor = isUser
        ? ApnaClinicAiUiConfig.panel
        : ApnaClinicAiUiConfig.primaryText;
    final style = Theme.of(context).textTheme.bodyMedium?.copyWith(
      color: textColor,
      fontSize: 14.sp,
      height: 1.45,
      fontWeight: FontWeight.w400,
      letterSpacing: -0.1,
    );

    final bubbleBody = message.pending
        ? const _ThinkingLoader()
        : _Body(
            message: message,
            style: style ?? const TextStyle(),
            l10n: l10n,
            audioPlaying: audioPlaying,
            onPlayAudio: onPlayAudio,
          );

    final bubble = message.pending
        ? Container(
            constraints: BoxConstraints(maxWidth: 270.w),
            margin: EdgeInsets.only(bottom: 12.h),
            padding: EdgeInsets.fromLTRB(14.w, 12.h, 14.w, 12.h),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(18.r),
              border: Border.all(color: ApnaClinicAiUiConfig.border),
            ),
            child: bubbleBody,
          )
        : Container(
            constraints: BoxConstraints(maxWidth: isUser ? 260.w : 270.w),
            margin: EdgeInsets.only(bottom: 12.h),
            padding: EdgeInsets.fromLTRB(14.w, 12.h, 14.w, 10.h),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(18.r),
              border: isUser
                  ? null
                  : Border.all(
                      color: audioPlaying
                          ? ApnaClinicAiUiConfig.cta
                          : ApnaClinicAiUiConfig.border,
                    ),
              boxShadow: isUser ? null : ApnaClinicAiUiConfig.cardShadow,
            ),
            child: bubbleBody,
          );

    if (isUser) {
      return Align(alignment: align, child: bubble);
    }

    return Align(
      alignment: align,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ApnaClinicAiBotAvatar(size: 32),
          SizedBox(width: 8.w),
          Flexible(child: bubble),
        ],
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({
    required this.message,
    required this.style,
    required this.l10n,
    required this.audioPlaying,
    required this.onPlayAudio,
  });

  final ApnaClinicAiMessageEntity message;
  final TextStyle style;
  final AppLocalizations l10n;
  final bool audioPlaying;
  final VoidCallback? onPlayAudio;

  @override
  Widget build(BuildContext context) {
    final failure = message.failureCode;
    final text = failure != null
        ? apnaClinicAiFailureText(l10n, failure)
        : message.text;
    final showNote =
        message.showEmergencyNote && failure == null && !text.contains('1122');
    final isUser = message.role == ApnaClinicAiMessageRole.user;
    final isUserVoice = message.isVoice && isUser;
    final time = message.sentAt == null
        ? null
        : DateFormat('h:mm a').format(message.sentAt!.toLocal());
    final timeColor = isUser
        ? ApnaClinicAiUiConfig.panel.withValues(alpha: 0.85)
        : ApnaClinicAiUiConfig.muted;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (isUserVoice)
          _VoiceNote(
            caption: text.trim().isNotEmpty
                ? text.trim()
                : l10n.apnaClinicAiTranscribing,
            label: text.trim().isEmpty
                ? l10n.apnaClinicAiTranscribing
                : l10n.apnaClinicAiVoiceNote,
            pendingTranscript: text.trim().isEmpty,
            style: style,
            time: time,
            timeColor: timeColor,
            playing: audioPlaying,
            onPlay: onPlayAudio,
          )
        else if (isUser)
          Text(text, style: style)
        else
          ApnaClinicAiMarkdownText(text: text, style: style),
        if (!isUserVoice &&
            (time != null ||
                onPlayAudio != null ||
                message.audioPending)) ...[
          SizedBox(height: 8.h),
          Row(
            children: [
              if (time != null)
                Text(
                  time,
                  style: TextStyle(
                    color: timeColor,
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              const Spacer(),
              // Speaker on text and voice replies, including while audio is still pending.
              if (!isUser &&
                  (onPlayAudio != null || message.audioPending)) ...[
                _PlayControl(
                  playing: audioPlaying,
                  loading: message.audioPending && !message.hasAudio,
                  onTap: onPlayAudio,
                ),
                SizedBox(width: 6.w),
              ],
              if (!isUser)
                _CopyButton(
                  text: text,
                  copiedLabel: l10n.apnaClinicAiCopied,
                ),
            ],
          ),
        ],
        if (showNote) ...[
          SizedBox(height: 8.h),
          ApnaClinicAiMarkdownText(
            text: l10n.apnaClinicAiEmergencyNote,
            style: style,
          ),
        ],
      ],
    );
  }
}

class _VoiceNote extends StatelessWidget {
  const _VoiceNote({
    required this.caption,
    required this.label,
    required this.style,
    required this.timeColor,
    required this.playing,
    this.pendingTranscript = false,
    this.time,
    this.onPlay,
  });

  final String caption;
  final String label;
  final TextStyle style;
  final String? time;
  final Color timeColor;
  final bool playing;
  final bool pendingTranscript;
  final VoidCallback? onPlay;

  @override
  Widget build(BuildContext context) {
    final showCaption =
        !pendingTranscript &&
        caption.trim().isNotEmpty &&
        caption.trim() != label;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Material(
          color: ApnaClinicAiUiConfig.panel.withValues(alpha: 0.14),
          borderRadius: BorderRadius.circular(14.r),
          child: InkWell(
            onTap: onPlay,
            borderRadius: BorderRadius.circular(14.r),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14.r),
                border: Border.all(
                  color: ApnaClinicAiUiConfig.panel.withValues(alpha: 0.28),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 28.r,
                    height: 28.r,
                    decoration: const BoxDecoration(
                      color: ApnaClinicAiUiConfig.panel,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      playing
                          ? Icons.pause_rounded
                          : Icons.play_arrow_rounded,
                      color: ApnaClinicAiUiConfig.ctaDeep,
                      size: 18.r,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  const _NoteWave(),
                  SizedBox(width: 8.w),
                  Flexible(
                    child: Text(
                      label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: style.copyWith(
                        fontWeight: FontWeight.w700,
                        color: ApnaClinicAiUiConfig.panel,
                        fontStyle: pendingTranscript
                            ? FontStyle.italic
                            : FontStyle.normal,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (showCaption) ...[
          SizedBox(height: 8.h),
          Text(caption, style: style),
        ],
        if (time != null) ...[
          SizedBox(height: 6.h),
          Align(
            alignment: Alignment.centerRight,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.mic_rounded, size: 12.r, color: timeColor),
                SizedBox(width: 4.w),
                Text(
                  time!,
                  style: TextStyle(
                    color: timeColor,
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

class _NoteWave extends StatelessWidget {
  const _NoteWave();

  @override
  Widget build(BuildContext context) {
    const heights = [8.0, 14.0, 10.0, 16.0, 9.0];
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        for (var i = 0; i < heights.length; i++) ...[
          if (i > 0) SizedBox(width: 2.w),
          Container(
            width: 2.5.w,
            height: heights[i].h,
            decoration: BoxDecoration(
              color: ApnaClinicAiUiConfig.panel.withValues(alpha: 0.9),
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
        ],
      ],
    );
  }
}

class _PlayControl extends StatelessWidget {
  const _PlayControl({
    required this.playing,
    required this.loading,
    this.onTap,
  });

  final bool playing;
  final bool loading;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final diameter = 32.r;
    return Material(
      color: playing
          ? ApnaClinicAiUiConfig.cta
          : ApnaClinicAiUiConfig.ctaSoft,
      shape: const CircleBorder(),
      child: InkWell(
        onTap: loading ? null : onTap,
        customBorder: const CircleBorder(),
        child: SizedBox(
          width: diameter,
          height: diameter,
          child: loading
              ? const _WaveThreeDots(compact: true)
              : Icon(
                  playing ? Icons.pause_rounded : Icons.volume_up_rounded,
                  size: 16.r,
                  color: playing
                      ? ApnaClinicAiUiConfig.panel
                      : ApnaClinicAiUiConfig.ctaDeep,
                ),
        ),
      ),
    );
  }
}

/// Three dots that pulse in a wave (audio-pending + thinking).
class _WaveThreeDots extends StatefulWidget {
  const _WaveThreeDots({this.compact = false});

  final bool compact;

  @override
  State<_WaveThreeDots> createState() => _WaveThreeDotsState();
}

class _WaveThreeDotsState extends State<_WaveThreeDots>
    with SingleTickerProviderStateMixin {
  late final AnimationController _motion;

  @override
  void initState() {
    super.initState();
    _motion = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat();
  }

  @override
  void dispose() {
    _motion.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final gap = widget.compact ? 2.5.w : 4.w;
    final slot = widget.compact ? 5.r : 8.r;
    final minSize = widget.compact ? 2.5.r : 5.r;
    final boost = widget.compact ? 2.r : 3.r;

    return AnimatedBuilder(
      animation: _motion,
      builder: (context, _) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (var i = 0; i < 3; i++) ...[
              if (i > 0) SizedBox(width: gap),
              _dot(i, slot: slot, minSize: minSize, boost: boost),
            ],
          ],
        );
      },
    );
  }

  Widget _dot(
    int index, {
    required double slot,
    required double minSize,
    required double boost,
  }) {
    final wave = math.sin((_motion.value * math.pi * 2) - (index * 0.7));
    final level = (wave + 1) / 2;
    final size = minSize + (boost * level);
    return SizedBox(
      width: slot,
      height: slot,
      child: Center(
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: (widget.compact
                    ? ApnaClinicAiUiConfig.ctaDeep
                    : ApnaClinicAiUiConfig.cta)
                .withValues(alpha: 0.35 + (0.65 * level)),
          ),
        ),
      ),
    );
  }
}

class _CopyButton extends StatelessWidget {
  const _CopyButton({required this.text, required this.copiedLabel});

  final String text;
  final String copiedLabel;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        final value = text.trim();
        if (value.isEmpty) return;
        await Clipboard.setData(ClipboardData(text: value));
        if (!context.mounted) return;
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(copiedLabel)));
      },
      borderRadius: BorderRadius.circular(16.r),
      child: Padding(
        padding: EdgeInsets.all(2.r),
        child: Icon(
          Icons.copy_rounded,
          size: 16.r,
          color: ApnaClinicAiUiConfig.muted,
        ),
      ),
    );
  }
}

class _ThinkingLoader extends StatelessWidget {
  const _ThinkingLoader();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppShimmer(
          width: 180.w,
          height: 12.h,
          borderRadius: 6.r,
          baseColor: ApnaClinicAiUiConfig.border,
          highlightColor: ApnaClinicAiUiConfig.panel,
        ),
        SizedBox(height: 8.h),
        AppShimmer(
          width: 140.w,
          height: 12.h,
          borderRadius: 6.r,
          baseColor: ApnaClinicAiUiConfig.border,
          highlightColor: ApnaClinicAiUiConfig.panel,
        ),
        SizedBox(height: 8.h),
        AppShimmer(
          width: 88.w,
          height: 12.h,
          borderRadius: 6.r,
          baseColor: ApnaClinicAiUiConfig.border,
          highlightColor: ApnaClinicAiUiConfig.panel,
        ),
      ],
    );
  }
}

