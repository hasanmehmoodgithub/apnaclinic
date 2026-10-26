import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/dependency_injection.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/widgets/app_scaffold_gradient.dart';
import '../../../../generated/assets.dart';
import '../../data/services/apna_clinic_ai_audio_player_service.dart';
import '../../domain/entities/apna_clinic_ai_message_entity.dart';
import '../apna_clinic_ai_copy.dart';
import '../constants/apna_clinic_ai_ui_config.dart';
import '../cubit/apna_clinic_ai_cubit.dart';
import '../cubit/apna_clinic_ai_state.dart';
import '../widgets/apna_clinic_ai_chat_view.dart';
import '../widgets/apna_clinic_ai_home_view.dart';

class ApnaClinicAiScreen extends StatefulWidget {
  const ApnaClinicAiScreen({super.key});

  @override
  State<ApnaClinicAiScreen> createState() => _ApnaClinicAiScreenState();
}

class _ApnaClinicAiScreenState extends State<ApnaClinicAiScreen> {
  late final ApnaClinicAiAudioPlayerService _audioPlayer;
  var _lastTtsNonce = 0;
  var _lastErrorNonce = 0;

  @override
  void initState() {
    super.initState();
    _audioPlayer = sl<ApnaClinicAiAudioPlayerService>();
  }

  @override
  void dispose() {
    // Stop TTS + mic as soon as the route leaves (don't wait for cubit close).
    try {
      unawaited(context.read<ApnaClinicAiCubit>().stopVoiceOnExit());
    } catch (_) {}
    unawaited(() async {
      await _audioPlayer.stop();
      await _audioPlayer.dispose();
    }());
    super.dispose();
  }

  Future<void> _stopVoice(ApnaClinicAiCubit cubit) async {
    await cubit.stopVoiceOnExit();
    await _audioPlayer.stop();
  }

  /// Chat → AI home (clears thread UI). Does not leave Care Companion.
  Future<void> _backToAiHome(ApnaClinicAiCubit cubit) async {
    await _audioPlayer.stop();
    await cubit.leaveChatToHome();
  }

  /// AI home → main Apna Clinic screen.
  Future<void> _exitToApp(ApnaClinicAiCubit cubit) async {
    await _stopVoice(cubit);
    if (!mounted) return;
    if (context.canPop()) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BlocConsumer<ApnaClinicAiCubit, ApnaClinicAiState>(
      listenWhen: (previous, current) =>
          previous.ttsNonce != current.ttsNonce ||
          previous.errorNonce != current.errorNonce ||
          previous.recording != current.recording ||
          previous.streaming != current.streaming,
      listener: (context, state) {
        final ttsChanged = state.ttsNonce != _lastTtsNonce;
        // Stop only when the user starts a new turn — not when a voice
        // reply finishes and auto-play begins in the same update cycle.
        if ((state.recording || state.streaming) && !ttsChanged) {
          if (_audioPlayer.isPlaying) unawaited(_audioPlayer.stop());
        }
        if (ttsChanged) {
          _lastTtsNonce = state.ttsNonce;
          ApnaClinicAiMessageEntity? assistant;
          for (final message in state.messages.reversed) {
            if (message.role == ApnaClinicAiMessageRole.assistant &&
                !message.pending) {
              assistant = message;
              break;
            }
          }
          final clip = (state.ttsBase64 ?? '').trim();
          final spoken = (state.ttsSpeakText ?? '').trim();
          // Defer so streaming:false settles before speak starts.
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!mounted) return;
            if (clip.isNotEmpty) {
              unawaited(
                _audioPlayer.playBase64(
                  clip,
                  mediaType: state.ttsMediaType,
                  // Home greeting has no chat message — keep a stable key so
                  // the speaking bar can show on home.
                  messageId: assistant?.id ?? 'home_greeting',
                ),
              );
            } else if (spoken.isNotEmpty && assistant != null) {
              unawaited(
                _audioPlayer.toggleText(
                  messageId: assistant.id,
                  text: spoken,
                ),
              );
            }
          });
        }
        if (state.showChat &&
            state.errorCode != null &&
            state.errorNonce != _lastErrorNonce) {
          _lastErrorNonce = state.errorNonce;
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(apnaClinicAiFailureText(l10n, state.errorCode)),
              ),
            );
        }
      },
      builder: (context, state) {
        final cubit = context.read<ApnaClinicAiCubit>();
        // Chat: system back → AI home. AI home: system back → main app.
        return PopScope(
          canPop: !state.showChat,
          onPopInvokedWithResult: (didPop, _) {
            if (didPop) {
              unawaited(_stopVoice(cubit));
              return;
            }
            if (state.showChat) {
              unawaited(_backToAiHome(cubit));
            }
          },
          child: AppScaffoldGradient(
            colors: ApnaClinicAiUiConfig.pageGradient,
            child: Column(
              children: [
                if (state.showChat)
                  _ChatHeader(
                    assistantName: state.assistantName.isEmpty
                        ? l10n.apnaClinicAiTitle
                        : state.assistantName,
                    subtitle: state.streaming
                        ? l10n.apnaClinicAiJustAMoment
                        : (state.headerSubtitle.trim().isNotEmpty
                              ? state.headerSubtitle.trim()
                              : l10n.apnaClinicAiOnline),
                    streaming: state.streaming,
                    onBack: () => unawaited(_backToAiHome(cubit)),
                    onNewChat: () {
                      unawaited(_audioPlayer.stop());
                      cubit.newChat();
                    },
                  ),
                AppScaffoldGradientPanel(
                  child: state.showChat
                      ? ApnaClinicAiChatView(
                          state: state,
                          cubit: cubit,
                          audioPlayer: _audioPlayer,
                        )
                      : ApnaClinicAiHomeView(
                          state: state,
                          cubit: cubit,
                          audioPlayer: _audioPlayer,
                          onClose: () => unawaited(_exitToApp(cubit)),
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ChatHeader extends StatelessWidget {
  const _ChatHeader({
    required this.assistantName,
    required this.subtitle,
    required this.streaming,
    required this.onBack,
    required this.onNewChat,
  });

  final String assistantName;
  final String subtitle;
  final bool streaming;
  final VoidCallback onBack;
  final VoidCallback onNewChat;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(8.w, 6.h, 8.w, 10.h),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: ApnaClinicAiUiConfig.border)),
      ),
      child: Row(
        children: [
          _HeaderIconButton(
            icon: Icons.arrow_back_ios_new_rounded,
            onPressed: onBack,
            size: 18,
          ),
          SizedBox(width: 4.w),
          Container(
            width: 40.r,
            height: 40.r,
            padding: EdgeInsets.all(6.r),
            decoration: BoxDecoration(
              color: ApnaClinicAiUiConfig.panel,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: ApnaClinicAiUiConfig.border),
            ),
            alignment: Alignment.center,
            child: Image.asset(
              Assets.iconsApnaClinicLogoSource,
              fit: BoxFit.contain,
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  assistantName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: ApnaClinicAiUiConfig.primaryText,
                    fontWeight: FontWeight.w700,
                    fontSize: 15.sp,
                    letterSpacing: -0.2,
                  ),
                ),
                Row(
                  children: [
                    Container(
                      width: 6.r,
                      height: 6.r,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: streaming
                            ? ApnaClinicAiUiConfig.cta
                            : ApnaClinicAiUiConfig.online,
                      ),
                    ),
                    SizedBox(width: 6.w),
                    Expanded(
                      child: Text(
                        subtitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: ApnaClinicAiUiConfig.muted,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          _HeaderIconButton(
            icon: Icons.refresh_rounded,
            onPressed: onNewChat,
            tooltip: AppLocalizations.of(context)!.apnaClinicAiNewChat,
          ),
        ],
      ),
    );
  }
}

class _HeaderIconButton extends StatelessWidget {
  const _HeaderIconButton({
    required this.icon,
    required this.onPressed,
    this.tooltip,
    this.size = 20,
    this.extent = 36,
  });

  final IconData icon;
  final VoidCallback onPressed;
  final String? tooltip;
  final double size;
  final double extent;

  @override
  Widget build(BuildContext context) {
    final button = Material(
      color: ApnaClinicAiUiConfig.panel,
      borderRadius: BorderRadius.circular(10.r),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(10.r),
        child: Container(
          width: extent.r,
          height: extent.r,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(color: ApnaClinicAiUiConfig.border),
          ),
          child: Icon(
            icon,
            size: size.r,
            color: ApnaClinicAiUiConfig.primaryText,
          ),
        ),
      ),
    );
    if (tooltip == null) {
      return Padding(
        padding: EdgeInsets.only(left: 4.w),
        child: button,
      );
    }
    return Padding(
      padding: EdgeInsets.only(left: 4.w),
      child: Tooltip(message: tooltip!, child: button),
    );
  }
}
