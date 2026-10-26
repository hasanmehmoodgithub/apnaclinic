import 'package:flutter/material.dart';

import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/widgets/apna_clinic_bot_animation.dart';
import '../../data/services/apna_clinic_ai_audio_player_service.dart';
import '../../domain/entities/apna_clinic_ai_home_tile_entity.dart';
import '../apna_clinic_ai_copy.dart';
import '../constants/apna_clinic_ai_ui_config.dart';
import '../cubit/apna_clinic_ai_cubit.dart';
import '../cubit/apna_clinic_ai_state.dart';
import 'apna_clinic_ai_composer.dart';
import 'apna_clinic_ai_home_speaking_panel.dart';
import 'apna_clinic_ai_listening_bar.dart';

class ApnaClinicAiHomeView extends StatefulWidget {
  const ApnaClinicAiHomeView({
    super.key,
    required this.state,
    required this.cubit,
    required this.audioPlayer,
    required this.onClose,
  });

  final ApnaClinicAiState state;
  final ApnaClinicAiCubit cubit;
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
    widget.cubit.sendText(
      text,
      resumeThread: resumeThread,
      forceNewThread: forceNewThread,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final state = widget.state;
    final connecting = state.connecting;

    final concerns = state.suggestions;
    final headline = state.assistantName.trim().isNotEmpty
        ? state.assistantName.trim()
        : l10n.apnaClinicAiHeadline;
    // Home cards are hidden for now (TODO below) — don't treat empty tiles as error.
    final hasError = !connecting && state.errorCode != null;
    final showComposer = !connecting && !hasError;
    final errorMessage = state.errorCode != null
        ? apnaClinicAiFailureText(l10n, state.errorCode)
        : l10n.apnaClinicAiConnectFailed;

    return Column(
      children: [
        Expanded(
          child: connecting
              ? Padding(
                  padding: EdgeInsets.fromLTRB(16.w, 4.h, 16.w, 12.h),
                  child: Column(
                    children: [
                      _HeroCard(
                        connecting: true,
                        connected: false,
                        headline: headline,
                        welcome: '',
                        connectingLabel: l10n.apnaClinicAiConnecting,
                        onlineLabel: l10n.apnaClinicAiOnline,
                        onClose: widget.onClose,
                      ),
                      SizedBox(height: 14.h),
                      const _DisclaimerText(),
                      const Expanded(
                        child: Center(
                          child: ApnaClinicBotAnimation(
                            headSize: 72,
                            style: ApnaClinicBotStyle.femaleAi,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : hasError
              ? Padding(
                  padding: EdgeInsets.fromLTRB(16.w, 4.h, 16.w, 12.h),
                  child: Column(
                    children: [
                      _HeroCard(
                        connecting: false,
                        connected: false,
                        headline: headline,
                        welcome: '',
                        connectingLabel: l10n.apnaClinicAiUnavailable,
                        onlineLabel: l10n.apnaClinicAiOnline,
                        onClose: widget.onClose,
                      ),
                      SizedBox(height: 14.h),
                      const _DisclaimerText(),
                      Expanded(
                        child: Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 12.w),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  errorMessage,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color:
                                        ApnaClinicAiUiConfig.emergencyText,
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w500,
                                    height: 1.4,
                                  ),
                                ),
                                SizedBox(height: 16.h),
                                Material(
                                  color: ApnaClinicAiUiConfig.cta,
                                  borderRadius: BorderRadius.circular(14.r),
                                  child: InkWell(
                                    onTap: () => widget.cubit
                                        .connect(forceRefresh: true),
                                    borderRadius: BorderRadius.circular(14.r),
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 22.w,
                                        vertical: 12.h,
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            Icons.refresh_rounded,
                                            size: 18.r,
                                            color: ApnaClinicAiUiConfig.panel,
                                          ),
                                          SizedBox(width: 8.w),
                                          Text(
                                            l10n.commonRetry,
                                            style: TextStyle(
                                              color:
                                                  ApnaClinicAiUiConfig.panel,
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : ListView(
                  padding: EdgeInsets.fromLTRB(16.w, 4.h, 16.w, 12.h),
                  children: [
                    _HeroCard(
                      connecting: false,
                      connected: true,
                      headline: headline,
                      // Greeting text shows on the speaking bar while audio plays.
                      welcome: '',
                      connectingLabel: l10n.apnaClinicAiConnecting,
                      onlineLabel: l10n.apnaClinicAiOnline,
                      onClose: widget.onClose,
                    ),
                    SizedBox(height: 14.h),
                    const _DisclaimerText(),
                    // TODO(apna-clinic-ai): re-enable Continue card
                    // (`homeResume` / last complaint) when resume UX returns.
                    if (concerns.isNotEmpty) ...[
                      SizedBox(height: 18.h),
                      _LabelRow(
                        title: l10n.apnaClinicAiCommonConcerns,
                        trailing: l10n.apnaClinicAiTapToStart,
                      ),
                      SizedBox(height: 10.h),
                      Wrap(
                        spacing: 8.w,
                        runSpacing: 8.h,
                        children: [
                          for (final concern in concerns)
                            _ConcernChip(
                              label: concern,
                              onTap: () =>
                                  _send(raw: concern, forceNewThread: true),
                            ),
                        ],
                      ),
                    ],
                    // TODO(apna-clinic-ai): re-enable `/sdk/home` `cards` as
                    // home tiles (Find a doctor, Browse doctors, medicine, cart).
                    // API still populates `state.homeTiles` — UI hidden for now.
                    // if (state.homeTiles.isNotEmpty) ...[
                    //   SizedBox(height: 18.h),
                    //   for (var i = 0; i < state.homeTiles.length; i++) ...[
                    //     if (i > 0) SizedBox(height: 6.h),
                    //     _HomeTile(
                    //       tile: state.homeTiles[i],
                    //       colorIndex: i,
                    //       onTap: () => _send(
                    //         raw: state.homeTiles[i].send,
                    //         forceNewThread: true,
                    //       ),
                    //     ),
                    //   ],
                    // ],
                  ],
                ),
        ),
        if (showComposer)
          SafeArea(
            top: false,
            child: StreamBuilder<ApnaClinicAiPlaybackSnapshot>(
              stream: widget.audioPlayer.snapshots,
              initialData: widget.audioPlayer.snapshot,
              builder: (context, snap) {
                final playback =
                    snap.data ?? const ApnaClinicAiPlaybackSnapshot();
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
                                  widget.audioPlayer.pause();
                                } else {
                                  widget.audioPlayer.resume();
                                }
                              },
                            )
                          : const SizedBox.shrink(
                              key: ValueKey('home_speaking_gone'),
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
                            showMic: true,
                            prominent: true,
                            onSend: () => _send(forceNewThread: true),
                            onMicTap: () => widget.cubit.toggleListening(
                              languageCode: Localizations.localeOf(
                                context,
                              ).languageCode,
                              forceNewThread: true,
                            ),
                          ),
                  ],
                );
              },
            ),
          ),
      ],
    );
  }
}

class _DisclaimerText extends StatelessWidget {
  const _DisclaimerText();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      width: double.infinity,
      margin: EdgeInsets.all(8.r),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: ApnaClinicAiUiConfig.caution.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: ApnaClinicAiUiConfig.caution.withValues(alpha: 0.22),
        ),
      ),
      child: Text(
        l10n.apnaClinicAiDisclaimer,
        textAlign: TextAlign.left,
        style: TextStyle(
          color: ApnaClinicAiUiConfig.cautionText,
          fontSize: 12.sp,
          height: 1.4,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}

class _HeroCard extends StatelessWidget {
  const _HeroCard({
    required this.connecting,
    required this.connected,
    required this.headline,
    required this.welcome,
    required this.connectingLabel,
    required this.onlineLabel,
    required this.onClose,
  });

  final bool connecting;
  final bool connected;
  final String headline;
  final String welcome;
  final String connectingLabel;
  final String onlineLabel;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final statusLabel = connecting
        ? connectingLabel
        : connected
        ? onlineLabel
        : connectingLabel;
    final statusColor = connecting
        ? ApnaClinicAiUiConfig.sand
        : connected
        ? ApnaClinicAiUiConfig.online
        : ApnaClinicAiUiConfig.emergencyText;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22.r),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF1AC4B2),
            Color(0xFF12B5A4),
            ApnaClinicAiUiConfig.cta,
            ApnaClinicAiUiConfig.ctaDeep,
          ],
          stops: [0.0, 0.35, 0.72, 1.0],
        ),
        boxShadow: [
          BoxShadow(
            color: ApnaClinicAiUiConfig.ctaDeep.withValues(alpha: 0.28),
            blurRadius: 24,
            offset: Offset(0, 10.h),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Positioned(
            right: -28.w,
            top: -36.h,
            child: Container(
              width: 120.r,
              height: 120.r,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.08),
              ),
            ),
          ),
          Positioned(
            right: 40.w,
            bottom: -48.h,
            child: Container(
              width: 100.r,
              height: 100.r,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.06),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 10.h, 10.w, 18.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10.w,
                            vertical: 5.h,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.16),
                            borderRadius: BorderRadius.circular(20.r),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.18),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 7.r,
                                height: 7.r,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: statusColor,
                                  boxShadow: [
                                    BoxShadow(
                                      color: statusColor.withValues(
                                        alpha: 0.55,
                                      ),
                                      blurRadius: 6,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 7.w),
                              Flexible(
                                child: Text(
                                  statusLabel,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: Colors.white.withValues(
                                      alpha: 0.96,
                                    ),
                                    fontSize: 11.sp,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.15,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Material(
                      color: Colors.white.withValues(alpha: 0.92),
                      borderRadius: BorderRadius.circular(8.r),
                      child: InkWell(
                        onTap: onClose,
                        borderRadius: BorderRadius.circular(8.r),
                        child: SizedBox(
                          width: 24.r,
                          height: 24.r,
                          child: Icon(
                            Icons.close_rounded,
                            size: 14.r,
                            color: ApnaClinicAiUiConfig.primaryText,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                Padding(
                  padding: EdgeInsets.only(right: 6.w),
                  child: Text(
                    headline.replaceAll('\n', ' '),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.sp,
                      height: 1.2,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.35,
                    ),
                  ),
                ),
                if (welcome.trim().isNotEmpty) ...[
                  SizedBox(height: 6.h),
                  Padding(
                    padding: EdgeInsets.only(right: 6.w),
                    child: Text(
                      welcome,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.88),
                        fontSize: 13.sp,
                        height: 1.35,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ContinueCard extends StatelessWidget {
  const _ContinueCard({
    required this.title,
    required this.complaint,
    required this.onTap,
    this.relative,
    this.badge,
  });

  final String title;
  final String complaint;
  final String? relative;
  final String? badge;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: ApnaClinicAiUiConfig.panel,
      borderRadius: BorderRadius.circular(16.r),
      child: InkWell(
        borderRadius: BorderRadius.circular(16.r),
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.all(14.r),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: ApnaClinicAiUiConfig.border),
          ),
          child: Row(
            children: [
              Container(
                width: 40.r,
                height: 40.r,
                decoration: const BoxDecoration(
                  color: ApnaClinicAiUiConfig.ctaSoft,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.history,
                  color: ApnaClinicAiUiConfig.cta,
                  size: 20.r,
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 12.sp,
                              color: ApnaClinicAiUiConfig.secondaryText,
                            ),
                          ),
                        ),
                        if ((badge ?? '').trim().isNotEmpty) ...[
                          SizedBox(width: 6.w),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 6.w,
                              vertical: 2.h,
                            ),
                            decoration: BoxDecoration(
                              color: ApnaClinicAiUiConfig.ctaSoft,
                              borderRadius: BorderRadius.circular(6.r),
                            ),
                            child: Text(
                              badge!.trim(),
                              style: TextStyle(
                                fontSize: 10.sp,
                                fontWeight: FontWeight.w700,
                                color: ApnaClinicAiUiConfig.ctaDeep,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    Text(
                      complaint,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 14.sp,
                        color: ApnaClinicAiUiConfig.primaryText,
                      ),
                    ),
                    if (relative != null)
                      Text(
                        relative!,
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: ApnaClinicAiUiConfig.secondaryText,
                        ),
                      ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: ApnaClinicAiUiConfig.secondaryText,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LabelRow extends StatelessWidget {
  const _LabelRow({required this.title, this.trailing});

  final String title;
  final String? trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.w700,
              color: ApnaClinicAiUiConfig.primaryText,
              letterSpacing: -0.2,
            ),
          ),
        ),
        if (trailing != null)
          Text(
            trailing!,
            style: TextStyle(
              fontSize: 11.sp,
              fontWeight: FontWeight.w500,
              color: ApnaClinicAiUiConfig.muted,
            ),
          ),
      ],
    );
  }
}

class _ConcernChip extends StatelessWidget {
  const _ConcernChip({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: ApnaClinicAiUiConfig.panel,
      borderRadius: BorderRadius.circular(12.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.r),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 9.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: ApnaClinicAiUiConfig.borderStrong),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: ApnaClinicAiUiConfig.primaryText,
            ),
          ),
        ),
      ),
    );
  }
}

class _HomeTile extends StatelessWidget {
  const _HomeTile({
    required this.tile,
    required this.colorIndex,
    required this.onTap,
  });

  final ApnaClinicAiHomeTileEntity tile;
  final int colorIndex;
  final VoidCallback onTap;

  static const _icons = [
    Icons.favorite_outline_rounded,
    Icons.medical_services_outlined,
    Icons.medication_outlined,
    Icons.description_outlined,
  ];

  @override
  Widget build(BuildContext context) {
    final icon = _tileIcon(tile.id, colorIndex);
    final subtitle = (tile.subtitle ?? '').trim();
    return Material(
      color: ApnaClinicAiUiConfig.panel,
      borderRadius: BorderRadius.circular(12.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.r),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: ApnaClinicAiUiConfig.borderStrong),
          ),
          child: Row(
            children: [
              Container(
                width: 28.r,
                height: 28.r,
                decoration: BoxDecoration(
                  color: ApnaClinicAiUiConfig.ctaSoft,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(
                  icon,
                  color: ApnaClinicAiUiConfig.ctaDeep,
                  size: 15.r,
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      tile.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 12.sp,
                        color: ApnaClinicAiUiConfig.primaryText,
                        height: 1.2,
                        letterSpacing: -0.1,
                      ),
                    ),
                    if (subtitle.isNotEmpty) ...[
                      SizedBox(height: 1.h),
                      Text(
                        subtitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 10.sp,
                          color: ApnaClinicAiUiConfig.muted,
                          height: 1.2,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                size: 18.r,
                color: ApnaClinicAiUiConfig.muted,
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _tileIcon(String id, int index) {
    final key = id.toLowerCase();
    if (key.contains('doctor') || key.contains('special')) {
      return Icons.medical_services_outlined;
    }
    if (key.contains('med') || key.contains('pharm')) {
      return Icons.medication_outlined;
    }
    if (key.contains('report') || key.contains('lab')) {
      return Icons.description_outlined;
    }
    if (key.contains('symptom') || key.contains('triage')) {
      return Icons.favorite_outline_rounded;
    }
    if (key.contains('browse')) return Icons.medical_services_outlined;
    if (key.contains('cart')) return Icons.shopping_bag_outlined;
    return _icons[index % _icons.length];
  }
}

