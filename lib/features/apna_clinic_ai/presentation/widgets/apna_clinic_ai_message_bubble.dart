import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../domain/entities/apna_clinic_ai_message_entity.dart';
import '../apna_clinic_ai_copy.dart';
import '../constants/apna_clinic_ai_ui_config.dart';
import 'apna_clinic_ai_markdown_text.dart';

class ApnaClinicAiMessageBubble extends StatelessWidget {
  const ApnaClinicAiMessageBubble({
    super.key,
    required this.message,
    this.thinkingStage = 'listening',
  });

  final ApnaClinicAiMessageEntity message;
  final String thinkingStage;

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

    return Align(
      alignment: align,
      child: Container(
        constraints: BoxConstraints(maxWidth: 300.w),
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(18.r),
            topRight: Radius.circular(18.r),
            bottomLeft: Radius.circular(isUser ? 18.r : 6.r),
            bottomRight: Radius.circular(isUser ? 6.r : 18.r),
          ),
          border: isUser
              ? null
              : Border.all(color: ApnaClinicAiUiConfig.border),
          boxShadow: isUser ? null : ApnaClinicAiUiConfig.cardShadow,
        ),
        child: message.pending
            ? _ThinkingLabel(stage: thinkingStage)
            : _Body(
                message: message,
                style: style ?? const TextStyle(),
                l10n: l10n,
              ),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({
    required this.message,
    required this.style,
    required this.l10n,
  });

  final ApnaClinicAiMessageEntity message;
  final TextStyle style;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final failure = message.failureCode;
    final text = failure != null
        ? apnaClinicAiFailureText(l10n, failure)
        : message.text;
    final showNote =
        message.showEmergencyNote &&
        failure == null &&
        !text.contains('1122');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (message.isVoice && message.role == ApnaClinicAiMessageRole.user)
          Padding(
            padding: EdgeInsets.only(bottom: 4.h),
            child: Icon(
              Icons.graphic_eq_rounded,
              size: 14.r,
              color: ApnaClinicAiUiConfig.panel.withValues(alpha: 0.85),
            ),
          ),
        if (message.role == ApnaClinicAiMessageRole.user)
          Text(text, style: style)
        else
          ApnaClinicAiMarkdownText(text: text, style: style),
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

class _ThinkingLabel extends StatefulWidget {
  const _ThinkingLabel({required this.stage});

  final String stage;

  @override
  State<_ThinkingLabel> createState() => _ThinkingLabelState();
}

class _ThinkingLabelState extends State<_ThinkingLabel> {
  Timer? _timer;
  var _index = 0;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(milliseconds: 1600), (_) {
      if (!mounted) return;
      setState(() => _index = (_index + 1) % 5);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final labels = [
      l10n.apnaClinicAiStageListening,
      l10n.apnaClinicAiStageSpecialists,
      l10n.apnaClinicAiStageDoctors,
      l10n.apnaClinicAiStageClinic,
      l10n.apnaClinicAiStageReady,
    ];
    final specific = widget.stage != 'listening' && widget.stage.isNotEmpty;
    final label = specific
        ? apnaClinicAiStageLabel(l10n, widget.stage)
        : labels[_index];
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 22.r,
          height: 22.r,
          decoration: const BoxDecoration(
            color: ApnaClinicAiUiConfig.ctaSoft,
            shape: BoxShape.circle,
          ),
          padding: EdgeInsets.all(5.r),
          child: const CircularProgressIndicator(
            strokeWidth: 1.8,
            color: ApnaClinicAiUiConfig.cta,
          ),
        ),
        SizedBox(width: 10.w),
        Flexible(
          child: Text(
            label,
            style: TextStyle(
              color: ApnaClinicAiUiConfig.secondaryText,
              fontSize: 13.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
