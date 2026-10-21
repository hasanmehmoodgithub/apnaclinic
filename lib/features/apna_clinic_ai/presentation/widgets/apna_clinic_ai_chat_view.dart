import 'package:flutter/material.dart';

import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/utils/auth_guard.dart';
import '../constants/apna_clinic_ai_ui_config.dart';
import '../cubit/apna_clinic_ai_cubit.dart';
import '../cubit/apna_clinic_ai_state.dart';
import 'apna_clinic_ai_composer.dart';
import 'apna_clinic_ai_message_bubble.dart';
import 'apna_clinic_ai_reply_rail.dart';

class ApnaClinicAiChatView extends StatefulWidget {
  const ApnaClinicAiChatView({
    super.key,
    required this.state,
    required this.cubit,
  });

  final ApnaClinicAiState state;
  final ApnaClinicAiCubit cubit;

  @override
  State<ApnaClinicAiChatView> createState() => _ApnaClinicAiChatViewState();
}

class _ApnaClinicAiChatViewState extends State<ApnaClinicAiChatView> {
  final _controller = TextEditingController();
  final _scroll = ScrollController();

  @override
  void didUpdateWidget(covariant ApnaClinicAiChatView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.state.messages.length != widget.state.messages.length ||
        oldWidget.state.thinkingStage != widget.state.thinkingStage ||
        oldWidget.state.doctors != widget.state.doctors ||
        oldWidget.state.slotDays != widget.state.slotDays) {
      _scrollToEnd();
    }
  }

  void _scrollToEnd() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scroll.hasClients) return;
      _scroll.animateTo(
        _scroll.position.maxScrollExtent,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _scroll.dispose();
    super.dispose();
  }

  void _send() {
    if (widget.state.recording) {
      widget.cubit.stopListeningAndSend();
      return;
    }
    final text = _controller.text;
    _controller.clear();
    widget.cubit.sendText(text);
  }

  void _toggleMic() {
    widget.cubit.toggleListening(
      languageCode: Localizations.localeOf(context).languageCode,
    );
  }

  Future<void> _openSignIn(BuildContext context) async {
    if (AuthGuard.isLoggedIn()) {
      await widget.cubit.resumeAfterSignIn();
      return;
    }
    await AuthGuard.pushLogin(context);
    if (!context.mounted) return;
    if (AuthGuard.isLoggedIn()) {
      await widget.cubit.resumeAfterSignIn();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final state = widget.state;
    return Column(
      children: [
        Expanded(
          child: ListView(
            controller: _scroll,
            padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 8.h),
            children: [
              if (!state.hasThread) ...[
                Text(
                  l10n.apnaClinicAiHeroTitle,
                  style: TextStyle(
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w800,
                    color: ApnaClinicAiUiConfig.primaryText,
                    height: 1.25,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  l10n.apnaClinicAiHeroBody,
                  style: TextStyle(
                    color: ApnaClinicAiUiConfig.secondaryText,
                    fontSize: 13.sp,
                    height: 1.35,
                  ),
                ),
                SizedBox(height: 12.h),
              ],
              for (final message in state.messages)
                ApnaClinicAiMessageBubble(
                  message: message,
                  thinkingStage: state.thinkingStage,
                ),
              ApnaClinicAiReplyRail(
                state: state,
                onSend: widget.cubit.sendText,
                onSignIn: () => _openSignIn(context),
              ),
            ],
          ),
        ),
        if (state.recording)
          _ListeningBar(
            caption: state.liveCaption.isEmpty
                ? l10n.apnaClinicAiListening
                : state.liveCaption,
            hint: l10n.apnaClinicAiTapMicToSend,
            englishLabel: l10n.apnaClinicAiVoiceEnglish,
            urduLabel: l10n.apnaClinicAiVoiceUrdu,
            urduSelected: state.voiceLanguageCode == 'ur',
            onEnglish: () => widget.cubit.setVoiceLanguage('en'),
            onUrdu: () => widget.cubit.setVoiceLanguage('ur'),
            onCancel: widget.cubit.cancelListening,
          ),
        SafeArea(
          top: false,
          child: ApnaClinicAiComposer(
            controller: _controller,
            hintText: state.recording
                ? l10n.apnaClinicAiTapMicToSend
                : l10n.apnaClinicAiChatComposerHint,
            enabled: !state.streaming && !state.recording,
            recording: state.recording,
            onSend: _send,
            onMicTap: _toggleMic,
          ),
        ),
      ],
    );
  }
}

class _ListeningBar extends StatelessWidget {
  const _ListeningBar({
    required this.caption,
    required this.hint,
    required this.englishLabel,
    required this.urduLabel,
    required this.urduSelected,
    required this.onEnglish,
    required this.onUrdu,
    required this.onCancel,
  });

  final String caption;
  final String hint;
  final String englishLabel;
  final String urduLabel;
  final bool urduSelected;
  final VoidCallback onEnglish;
  final VoidCallback onUrdu;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(14.w, 0, 14.w, 8.h),
      child: Container(
        padding: EdgeInsets.fromLTRB(12.w, 10.h, 8.w, 10.h),
        decoration: BoxDecoration(
          color: ApnaClinicAiUiConfig.ctaDeep,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 9.r,
                  height: 9.r,
                  decoration: const BoxDecoration(
                    color: ApnaClinicAiUiConfig.emergencyText,
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: Text(
                    caption,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: ApnaClinicAiUiConfig.panel,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                _LangChip(
                  label: englishLabel,
                  selected: !urduSelected,
                  onTap: onEnglish,
                ),
                SizedBox(width: 6.w),
                _LangChip(
                  label: urduLabel,
                  selected: urduSelected,
                  onTap: onUrdu,
                ),
                IconButton(
                  visualDensity: VisualDensity.compact,
                  onPressed: onCancel,
                  icon: Icon(
                    Icons.close_rounded,
                    color: ApnaClinicAiUiConfig.panel,
                    size: 18.r,
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(left: 19.w),
              child: Text(
                hint,
                style: TextStyle(
                  color: ApnaClinicAiUiConfig.panel.withValues(alpha: 0.8),
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LangChip extends StatelessWidget {
  const _LangChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected
          ? ApnaClinicAiUiConfig.panel
          : ApnaClinicAiUiConfig.panel.withValues(alpha: 0.16),
      borderRadius: BorderRadius.circular(8.r),
      child: InkWell(
        borderRadius: BorderRadius.circular(8.r),
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
          child: Text(
            label,
            style: TextStyle(
              color: selected
                  ? ApnaClinicAiUiConfig.ctaDeep
                  : ApnaClinicAiUiConfig.panel,
              fontSize: 11.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}
