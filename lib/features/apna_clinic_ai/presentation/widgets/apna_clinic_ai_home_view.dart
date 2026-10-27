import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/widgets/apna_clinic_bot_animation.dart';
import '../../data/services/apna_clinic_ai_audio_player_service.dart';
import '../apna_clinic_ai_copy.dart';
import '../cubit/apna_clinic_ai_cubit.dart';
import '../cubit/apna_clinic_ai_state.dart';
import 'apna_clinic_ai_composer.dart';
import 'apna_clinic_ai_concern_chip.dart';
import 'apna_clinic_ai_home_disclaimer.dart';
import 'apna_clinic_ai_home_error_body.dart';
import 'apna_clinic_ai_home_hero_card.dart';
import 'apna_clinic_ai_home_speaking_panel.dart';
import 'apna_clinic_ai_listening_bar.dart';

/// Home shell: hero / disclaimer / concerns + bottom composer dock.
/// Business state comes from [ApnaClinicAiCubit]; only the text controller
/// is local (input buffer, not feature state).
class ApnaClinicAiHomeView extends StatefulWidget {
  const ApnaClinicAiHomeView({
    super.key,
    required this.audioPlayer,
    required this.onClose,
  });

  final ApnaClinicAiAudioPlayerService audioPlayer;
  final VoidCallback onClose;

  @override
  State<ApnaClinicAiHomeView> createState() => _ApnaClinicAiHomeViewState();
}

class _ApnaClinicAiHomeViewState extends State<ApnaClinicAiHomeView> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _send({
    String? raw,
    bool resumeThread = false,
    bool forceNewThread = false,
  }) {
    final text = (raw ?? _controller.text).trim();
    if (text.isEmpty) return;
    _controller.clear();
    context.read<ApnaClinicAiCubit>().sendText(
      text,
      resumeThread: resumeThread,
      forceNewThread: forceNewThread,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: BlocBuilder<ApnaClinicAiCubit, ApnaClinicAiState>(
            buildWhen: (prev, next) =>
                prev.connecting != next.connecting ||
                prev.errorCode != next.errorCode ||
                prev.suggestions != next.suggestions,
            builder: (context, state) {
              final l10n = AppLocalizations.of(context)!;
              final connecting = state.connecting;
              final hasError = !connecting && state.errorCode != null;

              if (connecting) {
                return _HomeChrome(
                  onClose: widget.onClose,
                  connecting: true,
                  connected: false,
                  statusLabel: l10n.apnaClinicAiConnecting,
                  onlineLabel: l10n.apnaClinicAiOnline,
                  child: const Expanded(
                    child: Center(
                      child: ApnaClinicBotAnimation(
                        headSize: 72,
                        style: ApnaClinicBotStyle.femaleAi,
                      ),
                    ),
                  ),
                );
              }

              if (hasError) {
                final errorMessage = state.errorCode != null
                    ? apnaClinicAiFailureText(l10n, state.errorCode)
                    : l10n.apnaClinicAiConnectFailed;
                return _HomeChrome(
                  onClose: widget.onClose,
                  connecting: false,
                  connected: false,
                  statusLabel: l10n.apnaClinicAiUnavailable,
                  onlineLabel: l10n.apnaClinicAiOnline,
                  child: Expanded(
                    child: ApnaClinicAiHomeErrorBody(
                      message: errorMessage,
                      onRetry: () => context
                          .read<ApnaClinicAiCubit>()
                          .connect(forceRefresh: true),
                    ),
                  ),
                );
              }

              return ListView(
                padding: EdgeInsets.fromLTRB(16.w, 4.h, 16.w, 12.h),
                children: [
                  ApnaClinicAiHomeHeroCard(
                    connecting: false,
                    connected: true,
                    connectingLabel: l10n.apnaClinicAiConnecting,
                    onlineLabel: l10n.apnaClinicAiOnline,
                    onClose: widget.onClose,
                  ),
                  SizedBox(height: 8.h),
                  const ApnaClinicAiHomeDisclaimer(),
                  ApnaClinicAiConcernSection(
                    title: l10n.apnaClinicAiCommonConcerns,
                    trailing: l10n.apnaClinicAiTapToStart,
                    concerns: state.suggestions,
                    onTap: (concern) =>
                        _send(raw: concern, forceNewThread: true),
                  ),
                ],
              );
            },
          ),
        ),
        BlocBuilder<ApnaClinicAiCubit, ApnaClinicAiState>(
          buildWhen: (prev, next) =>
              prev.connecting != next.connecting ||
              prev.errorCode != next.errorCode ||
              prev.recording != next.recording ||
              prev.streaming != next.streaming ||
              prev.welcomeMessage != next.welcomeMessage,
          builder: (context, state) {
            final showComposer =
                !state.connecting && state.errorCode == null;
            if (!showComposer) return const SizedBox.shrink();
            return _HomeComposerDock(
              state: state,
              controller: _controller,
              audioPlayer: widget.audioPlayer,
              onSend: () => _send(forceNewThread: true),
              onMicTap: () => context.read<ApnaClinicAiCubit>().toggleListening(
                languageCode: Localizations.localeOf(context).languageCode,
                forceNewThread: true,
              ),
            );
          },
        ),
      ],
    );
  }
}

class _HomeChrome extends StatelessWidget {
  const _HomeChrome({
    required this.onClose,
    required this.connecting,
    required this.connected,
    required this.statusLabel,
    required this.onlineLabel,
    required this.child,
  });

  final VoidCallback onClose;
  final bool connecting;
  final bool connected;
  final String statusLabel;
  final String onlineLabel;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 4.h, 16.w, 12.h),
      child: Column(
        children: [
          ApnaClinicAiHomeHeroCard(
            connecting: connecting,
            connected: connected,
            connectingLabel: statusLabel,
            onlineLabel: onlineLabel,
            onClose: onClose,
          ),
          SizedBox(height: 8.h),
          const ApnaClinicAiHomeDisclaimer(),
          child,
        ],
      ),
    );
  }
}

class _HomeComposerDock extends StatelessWidget {
  const _HomeComposerDock({
    required this.state,
    required this.controller,
    required this.audioPlayer,
    required this.onSend,
    required this.onMicTap,
  });

  final ApnaClinicAiState state;
  final TextEditingController controller;
  final ApnaClinicAiAudioPlayerService audioPlayer;
  final VoidCallback onSend;
  final VoidCallback onMicTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final cubit = context.read<ApnaClinicAiCubit>();
    return SafeArea(
      top: false,
      child: StreamBuilder<ApnaClinicAiPlaybackSnapshot>(
        stream: audioPlayer.snapshots,
        initialData: audioPlayer.snapshot,
        builder: (context, snap) {
          final playback = snap.data ?? const ApnaClinicAiPlaybackSnapshot();
          final greeting = state.welcomeMessage.trim().isNotEmpty
              ? state.welcomeMessage.trim()
              : l10n.apnaClinicAiAgentSpeaking;
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 280),
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
                    ? ApnaClinicAiHomeSpeakingPanel(
                        key: const ValueKey('home_speaking'),
                        playing: playback.playing,
                        text: greeting,
                        onToggle: () {
                          if (playback.playing) {
                            audioPlayer.pause();
                          } else {
                            audioPlayer.resume();
                          }
                        },
                      )
                    : const SizedBox.shrink(
                        key: ValueKey('home_speaking_gone'),
                      ),
              ),
              state.recording
                  ? ApnaClinicAiListeningBar(
                      onCancel: cubit.cancelListening,
                      onSend: cubit.stopListeningAndSend,
                    )
                  : ApnaClinicAiComposer(
                      controller: controller,
                      hintText: l10n.apnaClinicAiChatComposerHint,
                      enabled: !state.streaming,
                      recording: false,
                      showMic: true,
                      prominent: true,
                      onSend: onSend,
                      onMicTap: onMicTap,
                    ),
            ],
          );
        },
      ),
    );
  }
}
