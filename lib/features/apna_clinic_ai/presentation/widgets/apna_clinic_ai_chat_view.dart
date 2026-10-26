import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/utils/auth_guard.dart';
import '../../data/services/apna_clinic_ai_audio_player_service.dart';
import '../../domain/entities/apna_clinic_ai_message_entity.dart';
import '../constants/apna_clinic_ai_ui_config.dart';
import '../cubit/apna_clinic_ai_cubit.dart';
import '../cubit/apna_clinic_ai_state.dart';
import 'apna_clinic_ai_composer.dart';
import 'apna_clinic_ai_listening_bar.dart';
import 'apna_clinic_ai_message_bubble.dart';
import 'apna_clinic_ai_reply_rail.dart';
import 'apna_clinic_ai_speaking_bar.dart';

class ApnaClinicAiChatView extends StatefulWidget {
  const ApnaClinicAiChatView({
    super.key,
    required this.state,
    required this.cubit,
    required this.audioPlayer,
  });

  final ApnaClinicAiState state;
  final ApnaClinicAiCubit cubit;
  final ApnaClinicAiAudioPlayerService audioPlayer;

  @override
  State<ApnaClinicAiChatView> createState() => _ApnaClinicAiChatViewState();
}

class _ApnaClinicAiChatViewState extends State<ApnaClinicAiChatView> {
  final _controller = TextEditingController();
  final _scroll = ScrollController();
  final _composerFocus = FocusNode();
  var _keyboardInset = 0.0;
  Timer? _scrollDelay;

  @override
  void initState() {
    super.initState();
    _composerFocus.addListener(_onComposerFocus);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final inset = MediaQuery.viewInsetsOf(context).bottom;
    final keyboardGrew = inset > _keyboardInset + 1;
    _keyboardInset = inset;
    if (keyboardGrew && _composerFocus.hasFocus) _pinToLatest();
  }

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

  void _onComposerFocus() {
    if (_composerFocus.hasFocus) _scrollToEnd();
  }

  void _scrollToEnd() {
    WidgetsBinding.instance.addPostFrameCallback((_) => _animateToEnd());
    _scrollDelay?.cancel();
    _scrollDelay = Timer(const Duration(milliseconds: 320), () {
      if (!mounted || !_composerFocus.hasFocus) return;
      _animateToEnd();
    });
  }

  void _pinToLatest() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scroll.hasClients) return;
      final target = _scroll.position.maxScrollExtent;
      if ((_scroll.position.pixels - target).abs() < 2) return;
      _scroll.jumpTo(target);
    });
  }

  void _animateToEnd() {
    if (!_scroll.hasClients) return;
    final target = _scroll.position.maxScrollExtent;
    if ((_scroll.position.pixels - target).abs() < 2) return;
    _scroll.animateTo(
      target,
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOut,
    );
  }

  @override
  void dispose() {
    _scrollDelay?.cancel();
    _composerFocus.removeListener(_onComposerFocus);
    _composerFocus.dispose();
    _controller.dispose();
    _scroll.dispose();
    super.dispose();
  }

  VoidCallback? _playHandler(ApnaClinicAiMessageEntity message) {
    if (message.pending) return null;
    if (message.role == ApnaClinicAiMessageRole.user) {
      if (!message.hasAudio) return null;
      return () => widget.audioPlayer.toggleMessage(
        messageId: message.id,
        base64Audio: message.audioBase64!,
        mediaType: message.audioMediaType,
      );
    }
    if (message.role != ApnaClinicAiMessageRole.assistant) return null;
    // Play only for server clips — never fall back to on-device TTS.
    if (!message.hasAudio) return null;
    return () => widget.audioPlayer.toggleMessage(
      messageId: message.id,
      base64Audio: message.audioBase64!,
      mediaType: message.audioMediaType,
    );
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
    return StreamBuilder<ApnaClinicAiPlaybackSnapshot>(
      stream: widget.audioPlayer.snapshots,
      initialData: widget.audioPlayer.snapshot,
      builder: (context, snap) {
        final playback = snap.data ?? const ApnaClinicAiPlaybackSnapshot();
        return _buildChat(context, l10n, state, playback);
      },
    );
  }

  Widget _buildChat(
    BuildContext context,
    AppLocalizations l10n,
    ApnaClinicAiState state,
    ApnaClinicAiPlaybackSnapshot playback,
  ) {
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
                  audioPlaying:
                      playback.messageId == message.id && playback.playing,
                  onPlayAudio: _playHandler(message),
                ),
              ApnaClinicAiReplyRail(
                state: state,
                onSend: widget.cubit.sendText,
                onSignIn: () => _openSignIn(context),
              ),
            ],
          ),
        ),
        SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 240),
                switchInCurve: Curves.easeOut,
                switchOutCurve: Curves.easeIn,
                transitionBuilder: (child, animation) {
                  return FadeTransition(
                    opacity: animation,
                    child: SizeTransition(
                      sizeFactor: animation,
                      alignment: Alignment.topCenter,
                      child: child,
                    ),
                  );
                },
                child: playback.active
                    ? ApnaClinicAiSpeakingBar(
                        key: const ValueKey('chat_speaking'),
                        playing: playback.playing,
                        statusLabel: () {
                          for (final message in state.messages) {
                            if (message.id != playback.messageId) continue;
                            if (message.isVoice &&
                                message.role ==
                                    ApnaClinicAiMessageRole.user) {
                              return l10n.apnaClinicAiVoiceNote;
                            }
                            break;
                          }
                          return l10n.apnaClinicAiAgentSpeaking;
                        }(),
                        onToggle: () {
                          if (playback.playing) {
                            widget.audioPlayer.pause();
                          } else {
                            widget.audioPlayer.resume();
                          }
                        },
                      )
                    : const SizedBox.shrink(
                        key: ValueKey('chat_speaking_gone'),
                      ),
              ),
              state.recording
              ? ApnaClinicAiListeningBar(
                  onCancel: widget.cubit.cancelListening,
                  onSend: widget.cubit.stopListeningAndSend,
                )
              : ApnaClinicAiComposer(
                  controller: _controller,
                  hintText: l10n.apnaClinicAiChatComposerHint,
                  enabled: !state.streaming,
                  recording: false,
                  onSend: _send,
                  onMicTap: _toggleMic,
                  focusNode: _composerFocus,
                  onTap: _scrollToEnd,
                ),
            ],
          ),
        ),
      ],
    );
  }
}
