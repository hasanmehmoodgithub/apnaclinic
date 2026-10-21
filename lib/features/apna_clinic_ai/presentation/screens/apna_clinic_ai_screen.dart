import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/extensions/string_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/widgets/app_scaffold_gradient.dart';
import '../../../../generated/assets.dart';
import '../apna_clinic_ai_copy.dart';
import '../constants/apna_clinic_ai_ui_config.dart';
import '../cubit/apna_clinic_ai_cubit.dart';
import '../cubit/apna_clinic_ai_state.dart';
import '../widgets/apna_clinic_ai_chat_view.dart';
import '../widgets/apna_clinic_ai_home_view.dart';
import '../widgets/apna_clinic_ai_settings_sheet.dart';

class ApnaClinicAiScreen extends StatefulWidget {
  const ApnaClinicAiScreen({super.key});

  @override
  State<ApnaClinicAiScreen> createState() => _ApnaClinicAiScreenState();
}

class _ApnaClinicAiScreenState extends State<ApnaClinicAiScreen> {
  final _player = AudioPlayer();
  var _lastTtsNonce = 0;
  var _lastErrorNonce = 0;

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  Future<void> _playReply(String base64Audio, String? mediaType) async {
    try {
      final bytes = base64Decode(base64Audio);
      if (bytes.isEmpty) return;
      final dir = await getTemporaryDirectory();
      final ext = _audioExtension(bytes, mediaType);
      final file = File(
        '${dir.path}/apna_clinic_ai_reply_${DateTime.now().microsecondsSinceEpoch}.$ext',
      );
      await file.writeAsBytes(bytes, flush: true);
      await _player.stop();
      await _player.setFilePath(file.path);
      await _player.setVolume(1);
      await _player.play();
    } catch (_) {}
  }

  String _audioExtension(List<int> bytes, String? mediaType) {
    final type = (mediaType ?? '').toLowerCase();
    if (type.contains('mpeg') || type.contains('mp3')) return 'mp3';
    if (type.contains('ogg') || type.contains('opus')) return 'ogg';
    if (type.contains('wav')) return 'wav';
    if (type.contains('mp4') || type.contains('m4a') || type.contains('aac')) {
      return 'm4a';
    }
    if (bytes.length >= 4) {
      final wav =
          bytes[0] == 0x52 &&
          bytes[1] == 0x49 &&
          bytes[2] == 0x46 &&
          bytes[3] == 0x46;
      final ogg =
          bytes[0] == 0x4F &&
          bytes[1] == 0x67 &&
          bytes[2] == 0x67 &&
          bytes[3] == 0x53;
      if (wav) return 'wav';
      if (ogg) return 'ogg';
      if (bytes[0] == 0x49 && bytes[1] == 0x44 && bytes[2] == 0x33) {
        return 'mp3';
      }
      if (bytes[0] == 0xFF && (bytes[1] & 0xE0) == 0xE0) return 'mp3';
    }
    return 'm4a';
  }

  void _openSettings(ApnaClinicAiCubit cubit) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.clrWhite,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      builder: (_) => ApnaClinicAiSettingsSheet(cubit: cubit),
    );
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
        if (state.recording || state.streaming) {
          if (_player.playing) unawaited(_player.stop());
        }
        if (state.ttsNonce != _lastTtsNonce &&
            state.ttsBase64 != null &&
            state.ttsBase64!.isNotEmpty) {
          _lastTtsNonce = state.ttsNonce;
          _playReply(state.ttsBase64!, state.ttsMediaType);
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
        return AppScaffoldGradient(
          colors: ApnaClinicAiUiConfig.pageGradient,
          child: Column(
            children: [
              if (state.showChat)
                _ChatHeader(
                  assistantName: state.assistantName.isEmpty
                      ? l10n.apnaClinicAiTitle
                      : state.assistantName,
                  subtitle: state.streaming
                      ? apnaClinicAiStageLabel(l10n, state.thinkingStage)
                      : l10n.apnaClinicAiOnline,
                  streaming: state.streaming,
                  onBack: cubit.showHome,
                  onNewChat: cubit.newChat,
                  onSettings: () => _openSettings(cubit),
                )
              else
                _HomeHeader(
                  greeting: l10n.apnaClinicAiGreeting,
                  displayName: state.userDisplayName.isEmpty
                      ? l10n.apnaClinicAiGuest.capitalize
                      : state.userDisplayName.capitalize,
                  onClose: () {
                    if (context.canPop()) context.pop();
                  },
                  onSettings: () => _openSettings(cubit),
                ),
              AppScaffoldGradientPanel(
                child: state.showChat
                    ? ApnaClinicAiChatView(state: state, cubit: cubit)
                    : ApnaClinicAiHomeView(state: state, cubit: cubit),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _HomeHeader extends StatelessWidget {
  const _HomeHeader({
    required this.greeting,
    required this.displayName,
    required this.onClose,
    required this.onSettings,
  });

  final String greeting;
  final String displayName;
  final VoidCallback onClose;
  final VoidCallback onSettings;

  @override
  Widget build(BuildContext context) {
    final initial = displayName.isNotEmpty ? displayName[0].toUpperCase() : 'A';
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 10.h, 12.w, 6.h),
      child: Row(
        children: [
          Container(
            width: 42.r,
            height: 42.r,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: ApnaClinicAiUiConfig.ctaSoft,
              border: Border.all(color: ApnaClinicAiUiConfig.border),
            ),
            alignment: Alignment.center,
            child: Text(
              initial,
              style: TextStyle(
                color: ApnaClinicAiUiConfig.ctaDeep,
                fontWeight: FontWeight.w700,
                fontSize: 16.sp,
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  greeting,
                  style: TextStyle(
                    color: ApnaClinicAiUiConfig.muted,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  displayName,
                  style: TextStyle(
                    color: ApnaClinicAiUiConfig.primaryText,
                    fontWeight: FontWeight.w700,
                    fontSize: 17.sp,
                    letterSpacing: -0.2,
                  ),
                ),
              ],
            ),
          ),
          _HeaderIconButton(icon: Icons.tune_rounded, onPressed: onSettings),
          _HeaderIconButton(icon: Icons.close_rounded, onPressed: onClose),
        ],
      ),
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
    required this.onSettings,
  });

  final String assistantName;
  final String subtitle;
  final bool streaming;
  final VoidCallback onBack;
  final VoidCallback onNewChat;
  final VoidCallback onSettings;

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
          _HeaderIconButton(icon: Icons.tune_rounded, onPressed: onSettings),
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
  });

  final IconData icon;
  final VoidCallback onPressed;
  final String? tooltip;
  final double size;

  @override
  Widget build(BuildContext context) {
    final button = Material(
      color: ApnaClinicAiUiConfig.panel,
      borderRadius: BorderRadius.circular(10.r),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(10.r),
        child: Container(
          width: 36.r,
          height: 36.r,
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
