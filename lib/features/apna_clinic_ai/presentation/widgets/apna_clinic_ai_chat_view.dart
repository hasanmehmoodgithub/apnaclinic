import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/utils/auth_guard.dart';
import '../../data/services/apna_clinic_ai_audio_player_service.dart';
import '../../domain/entities/apna_clinic_ai_message_entity.dart';
import '../cubit/apna_clinic_ai_cubit.dart';
import '../cubit/apna_clinic_ai_state.dart';
import '../apna_clinic_ai_copy.dart';
import 'apna_clinic_ai_composer.dart';
import 'apna_clinic_ai_home_error_body.dart';
import 'apna_clinic_ai_listening_bar.dart';
import 'apna_clinic_ai_loading_shimmer.dart';
import 'apna_clinic_ai_message_bubble.dart';
import 'apna_clinic_ai_reply_rail.dart';
import 'apna_clinic_ai_speaking_bar.dart';
import 'apna_clinic_ai_suggestion_row.dart';

/// Chat thread + composer. Scroll / focus / text buffer stay local;
/// turn / recording / cards come from [ApnaClinicAiCubit].
class ApnaClinicAiChatView extends StatefulWidget {
  const ApnaClinicAiChatView({
    super.key,
    required this.audioPlayer,
  });

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
  var _lastMessageCount = 0;
  String? _lastThinkingStage;
  Object? _lastDoctors;
  Object? _lastSlotDays;

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

  void _maybeScrollForState(ApnaClinicAiState state) {
    final shouldScroll =
        state.messages.length != _lastMessageCount ||
        state.thinkingStage != _lastThinkingStage ||
        !identical(state.doctors, _lastDoctors) ||
        !identical(state.slotDays, _lastSlotDays);
    _lastMessageCount = state.messages.length;
    _lastThinkingStage = state.thinkingStage;
    _lastDoctors = state.doctors;
    _lastSlotDays = state.slotDays;
    if (shouldScroll) _scrollToEnd();
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
    if (!message.hasAudio) return null;
    return () => widget.audioPlayer.toggleMessage(
      messageId: message.id,
      base64Audio: message.audioBase64!,
      mediaType: message.audioMediaType,
    );
  }

  void _send(ApnaClinicAiCubit cubit, ApnaClinicAiState state) {
    if (state.recording) {
      cubit.stopListeningAndSend();
      return;
    }
    final text = _controller.text;
    _controller.clear();
    cubit.sendText(text);
  }

  void _toggleMic(ApnaClinicAiCubit cubit) {
    cubit.toggleListening(
      languageCode: Localizations.localeOf(context).languageCode,
    );
  }

  Future<void> _openSignIn(
    BuildContext context,
    ApnaClinicAiCubit cubit,
  ) async {
    if (AuthGuard.isLoggedIn()) {
      await cubit.resumeAfterSignIn();
      return;
    }
    await AuthGuard.pushLogin(context);
    if (!context.mounted) return;
    if (AuthGuard.isLoggedIn()) {
      await cubit.resumeAfterSignIn();
    }
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ApnaClinicAiCubit>();
    return StreamBuilder<ApnaClinicAiPlaybackSnapshot>(
      stream: widget.audioPlayer.snapshots,
      initialData: widget.audioPlayer.snapshot,
      builder: (context, snap) {
        final playback = snap.data ?? const ApnaClinicAiPlaybackSnapshot();
        return BlocConsumer<ApnaClinicAiCubit, ApnaClinicAiState>(
          listenWhen: (prev, next) =>
              prev.messages.length != next.messages.length ||
              prev.thinkingStage != next.thinkingStage ||
              prev.doctors != next.doctors ||
              prev.slotDays != next.slotDays,
          listener: (context, state) => _maybeScrollForState(state),
          builder: (context, state) {
            final l10n = AppLocalizations.of(context)!;
            final starterChips = [
              l10n.apnaClinicAiChipFindDoctor,
              l10n.apnaClinicAiChipFindMedicines,
            ];
            final seen = starterChips.map((item) => item.toLowerCase()).toSet();
            final chips = [
              ...starterChips,
              for (final item in state.suggestions)
                if (item.trim().isNotEmpty &&
                    seen.add(item.trim().toLowerCase()))
                  item.trim(),
            ];
            final showStarterSuggestions =
                !state.streaming &&
                !state.recording &&
                !state.connecting &&
                state.errorCode == null &&
                !state.messages.any(
                  (message) => message.role == ApnaClinicAiMessageRole.user,
                );
            return Column(
              children: [
                Expanded(
                  child: state.connecting && !state.hasThread
                      ? const ApnaClinicAiTopMessageShimmer()
                      : state.errorCode != null && !state.hasThread
                      ? ApnaClinicAiHomeErrorBody(
                          message: apnaClinicAiFailureText(
                            AppLocalizations.of(context)!,
                            state.errorCode,
                          ),
                          onRetry: () => cubit.connect(forceRefresh: true),
                        )
                      : _ChatThread(
                          state: state,
                          scroll: _scroll,
                          playback: playback,
                          playHandler: _playHandler,
                          onSend: cubit.sendText,
                          onSignIn: () => _openSignIn(context, cubit),
                        ),
                ),
                if (showStarterSuggestions)
                  ApnaClinicAiSuggestionRow(
                    suggestions: chips,
                    onTap: cubit.sendText,
                  ),
                if (state.hasThread || state.errorCode == null)
                  _ChatComposerDock(
                  state: state,
                  playback: playback,
                  controller: _controller,
                  composerFocus: _composerFocus,
                  audioPlayer: widget.audioPlayer,
                  onSend: () => _send(cubit, state),
                  onMicTap: () => _toggleMic(cubit),
                  onComposerTap: _scrollToEnd,
                  onCancelListening: cubit.cancelListening,
                  onStopListening: cubit.stopListeningAndSend,
                ),
              ],
            );
          },
        );
      },
    );
  }
}

class _ChatThread extends StatelessWidget {
  const _ChatThread({
    required this.state,
    required this.scroll,
    required this.playback,
    required this.playHandler,
    required this.onSend,
    required this.onSignIn,
  });

  final ApnaClinicAiState state;
  final ScrollController scroll;
  final ApnaClinicAiPlaybackSnapshot playback;
  final VoidCallback? Function(ApnaClinicAiMessageEntity) playHandler;
  final ValueChanged<String> onSend;
  final VoidCallback onSignIn;

  @override
  Widget build(BuildContext context) {
    return ListView(
      controller: scroll,
      padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 8.h),
      children: [
        for (final message in state.messages)
          ApnaClinicAiMessageBubble(
            message: message,
            audioPlaying:
                playback.messageId == message.id && playback.playing,
            onPlayAudio: playHandler(message),
          ),
        ApnaClinicAiReplyRail(
          state: state,
          onSend: onSend,
          onSignIn: onSignIn,
        ),
      ],
    );
  }
}

class _ChatComposerDock extends StatelessWidget {
  const _ChatComposerDock({
    required this.state,
    required this.playback,
    required this.controller,
    required this.composerFocus,
    required this.audioPlayer,
    required this.onSend,
    required this.onMicTap,
    required this.onComposerTap,
    required this.onCancelListening,
    required this.onStopListening,
  });

  final ApnaClinicAiState state;
  final ApnaClinicAiPlaybackSnapshot playback;
  final TextEditingController controller;
  final FocusNode composerFocus;
  final ApnaClinicAiAudioPlayerService audioPlayer;
  final VoidCallback onSend;
  final VoidCallback onMicTap;
  final VoidCallback onComposerTap;
  final VoidCallback onCancelListening;
  final VoidCallback onStopListening;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return SafeArea(
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
                            message.role == ApnaClinicAiMessageRole.user) {
                          return l10n.apnaClinicAiVoiceNote;
                        }
                        break;
                      }
                      return l10n.apnaClinicAiAgentSpeaking;
                    }(),
                    onToggle: () {
                      if (playback.playing) {
                        audioPlayer.pause();
                      } else {
                        audioPlayer.resume();
                      }
                    },
                  )
                : const SizedBox.shrink(
                    key: ValueKey('chat_speaking_gone'),
                  ),
          ),
          state.recording
              ? ApnaClinicAiListeningBar(
                  onCancel: onCancelListening,
                  onSend: onStopListening,
                )
              : ApnaClinicAiComposer(
                  controller: controller,
                  hintText: l10n.apnaClinicAiChatComposerHint,
                  enabled: !state.streaming && !state.connecting,
                  micEnabled: !state.connecting,
                  recording: false,
                  onSend: onSend,
                  onMicTap: onMicTap,
                  focusNode: composerFocus,
                  onTap: onComposerTap,
                ),
        ],
      ),
    );
  }
}
