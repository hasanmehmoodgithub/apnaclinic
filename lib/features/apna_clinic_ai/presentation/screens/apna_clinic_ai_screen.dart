import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/dependency_injection.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/widgets/app_scaffold_gradient.dart';
import '../../data/services/apna_clinic_ai_audio_player_service.dart';
import '../../domain/entities/apna_clinic_ai_message_entity.dart';
import '../apna_clinic_ai_copy.dart';
import '../constants/apna_clinic_ai_ui_config.dart';
import '../cubit/apna_clinic_ai_cubit.dart';
import '../cubit/apna_clinic_ai_state.dart';
import '../widgets/apna_clinic_ai_chat_header.dart';
import '../widgets/apna_clinic_ai_chat_view.dart';

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

  Future<void> _leave(ApnaClinicAiCubit cubit) async {
    await _stopVoice(cubit);
    if (!mounted) return;
    if (context.canPop()) {
      context.pop();
      return;
    }
    await SystemNavigator.pop();
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
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!mounted) return;
            if (clip.isNotEmpty) {
              unawaited(
                _audioPlayer.playBase64(
                  clip,
                  mediaType: state.ttsMediaType,
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
        if (state.messages.isNotEmpty &&
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
      builder: (context, _) {
        final cubit = context.read<ApnaClinicAiCubit>();
        return PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, _) {
            if (didPop) return;
            unawaited(_leave(cubit));
          },
          child: AppScaffoldGradient(
            colors: ApnaClinicAiUiConfig.pageGradient,
            child: Column(
              children: [
                ApnaClinicAiChatHeader(
                  onBack: () => unawaited(_leave(cubit)),
                  onNewChat: () {
                    unawaited(_audioPlayer.stop());
                    cubit.newChat();
                  },
                ),
                AppScaffoldGradientPanel(
                  topBorderRadius: 0,
                  child: ApnaClinicAiChatView(audioPlayer: _audioPlayer),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
