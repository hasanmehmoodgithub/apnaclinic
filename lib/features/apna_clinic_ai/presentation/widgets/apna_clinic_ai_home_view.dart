import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../domain/entities/apna_clinic_ai_home_tile_entity.dart';
import '../apna_clinic_ai_copy.dart';
import '../constants/apna_clinic_ai_ui_config.dart';
import '../cubit/apna_clinic_ai_cubit.dart';
import '../cubit/apna_clinic_ai_state.dart';
import 'apna_clinic_ai_composer.dart';

class ApnaClinicAiHomeView extends StatefulWidget {
  const ApnaClinicAiHomeView({
    super.key,
    required this.state,
    required this.cubit,
  });

  final ApnaClinicAiState state;
  final ApnaClinicAiCubit cubit;

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

  void _send({String? raw, bool resumeThread = false}) {
    final text = (raw ?? _controller.text).trim();
    if (text.isEmpty) return;
    _controller.clear();
    widget.cubit.sendText(text, resumeThread: resumeThread);
  }

  bool _isResumeTile(ApnaClinicAiHomeTileEntity tile) {
    final key = '${tile.id} ${tile.title}'.toLowerCase();
    return key.contains('resume') || key.contains('continue');
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final state = widget.state;
    final welcome = state.welcomeMessage.trim().isNotEmpty
        ? state.welcomeMessage.trim()
        : l10n.apnaClinicAiLiveStats;
    final concerns = state.suggestions.isNotEmpty
        ? state.suggestions
        : <String>[
            l10n.apnaClinicAiSuggestFever,
            l10n.apnaClinicAiSuggestRash,
            l10n.apnaClinicAiSuggestDoctors,
            l10n.apnaClinicAiSuggestPanadol,
          ];
    final tiles = state.homeTiles.isNotEmpty
        ? state.homeTiles
        : _fallbackTiles(l10n);

    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: EdgeInsets.fromLTRB(16.w, 4.h, 16.w, 12.h),
            children: [
              _HeroCard(
                connecting: state.connecting,
                connected: !state.connecting && state.errorCode == null,
                headline: l10n.apnaClinicAiHeadline,
                welcome: welcome,
                voiceEnabled: state.voiceEnabled,
                voiceTitle: l10n.apnaClinicAiVoiceCta,
                voiceLangs: l10n.apnaClinicAiVoiceLangs,
                connectingLabel: l10n.apnaClinicAiConnecting,
                onlineLabel: l10n.apnaClinicAiOnline,
                onVoice: () {
                  widget.cubit.toggleListening(
                    languageCode: Localizations.localeOf(context).languageCode,
                  );
                },
              ),
              if (state.lastComplaint != null &&
                  state.lastComplaint!.isNotEmpty) ...[
                SizedBox(height: 14.h),
                _ContinueCard(
                  title: l10n.apnaClinicAiContinue,
                  complaint: state.lastComplaint!,
                  relative: state.lastComplaintAtMillis == null
                      ? null
                      : apnaClinicAiRelativeTime(
                          l10n,
                          state.lastComplaintAtMillis!,
                        ),
                  onTap: widget.cubit.resumeLastComplaint,
                ),
              ],
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
                      onTap: () => _send(raw: concern),
                    ),
                ],
              ),
              SizedBox(height: 18.h),
              _LabelRow(title: l10n.apnaClinicAiWhatICanDo),
              SizedBox(height: 10.h),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: tiles.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10.w,
                  mainAxisSpacing: 10.h,
                  childAspectRatio: 1.15,
                ),
                itemBuilder: (context, index) {
                  final tile = tiles[index];
                  return _HomeTile(
                    tile: tile,
                    colorIndex: index,
                    onTap: () => _send(
                      raw: tile.send,
                      resumeThread: _isResumeTile(tile),
                    ),
                  );
                },
              ),
              SizedBox(height: 16.h),
              const _SosBanner(),
              SizedBox(height: 12.h),
              Text(
                l10n.apnaClinicAiFinePrint,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: ApnaClinicAiUiConfig.muted,
                  fontSize: 11.sp,
                  height: 1.35,
                ),
              ),
              if (state.errorCode != null) ...[
                SizedBox(height: 10.h),
                Text(
                  apnaClinicAiFailureText(l10n, state.errorCode),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: ApnaClinicAiUiConfig.emergencyText,
                    fontSize: 12.sp,
                  ),
                ),
              ],
            ],
          ),
        ),
        SafeArea(
          top: false,
          child: ApnaClinicAiComposer(
            controller: _controller,
            hintText: l10n.apnaClinicAiComposerHint,
            enabled: !state.streaming && !state.connecting && !state.recording,
            recording: state.recording,
            showMic: true,
            onSend: state.recording ? widget.cubit.stopListeningAndSend : _send,
            onMicTap: () => widget.cubit.toggleListening(
              languageCode: Localizations.localeOf(context).languageCode,
            ),
          ),
        ),
      ],
    );
  }

  List<ApnaClinicAiHomeTileEntity> _fallbackTiles(AppLocalizations l10n) {
    return [
      ApnaClinicAiHomeTileEntity(
        id: 'symptoms',
        title: l10n.apnaClinicAiStartTalkingTitle,
        subtitle: l10n.apnaClinicAiStartTalkingBody,
        send: l10n.apnaClinicAiSuggestFever,
      ),
      ApnaClinicAiHomeTileEntity(
        id: 'doctors',
        title: l10n.apnaClinicAiDoctors,
        subtitle: l10n.apnaClinicAiLiveStats,
        send: l10n.apnaClinicAiSuggestDoctors,
      ),
      ApnaClinicAiHomeTileEntity(
        id: 'medicine',
        title: l10n.apnaClinicAiMedicines,
        subtitle: l10n.apnaClinicAiFinePrint,
        send: l10n.apnaClinicAiSuggestPanadol,
      ),
      ApnaClinicAiHomeTileEntity(
        id: 'report',
        title: l10n.apnaClinicAiPrescriptionTitle,
        subtitle: l10n.apnaClinicAiPrescriptionBody,
        send: l10n.apnaClinicAiPrescriptionHint,
      ),
    ];
  }
}

class _HeroCard extends StatelessWidget {
  const _HeroCard({
    required this.connecting,
    required this.connected,
    required this.headline,
    required this.welcome,
    required this.voiceEnabled,
    required this.voiceTitle,
    required this.voiceLangs,
    required this.connectingLabel,
    required this.onlineLabel,
    required this.onVoice,
  });

  final bool connecting;
  final bool connected;
  final String headline;
  final String welcome;
  final bool voiceEnabled;
  final String voiceTitle;
  final String voiceLangs;
  final String connectingLabel;
  final String onlineLabel;
  final VoidCallback onVoice;

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
      padding: EdgeInsets.fromLTRB(20.w, 18.h, 20.w, 18.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: ApnaClinicAiUiConfig.heroGradient,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x2800897B),
            blurRadius: 18,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(8.r),
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
                  ),
                ),
                SizedBox(width: 7.w),
                Text(
                  statusLabel,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.92),
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.2,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 14.h),
          Text(
            headline,
            style: TextStyle(
              color: Colors.white,
              fontSize: 26.sp,
              height: 1.15,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.4,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            welcome,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.82),
              fontSize: 13.sp,
              height: 1.4,
              fontWeight: FontWeight.w400,
            ),
          ),
          if (voiceEnabled) ...[
            SizedBox(height: 16.h),
            Material(
              color: Colors.white.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(14.r),
              child: InkWell(
                onTap: onVoice,
                borderRadius: BorderRadius.circular(14.r),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 11.h,
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 38.r,
                        height: 38.r,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        child: Icon(
                          Icons.mic_none_rounded,
                          color: ApnaClinicAiUiConfig.ctaDeep,
                          size: 20.r,
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              voiceTitle,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 14.sp,
                              ),
                            ),
                            Text(
                              voiceLangs,
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.72),
                                fontSize: 11.sp,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.chevron_right_rounded,
                        color: Colors.white.withValues(alpha: 0.7),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
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
  });

  final String title;
  final String complaint;
  final String? relative;
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
                    Text(
                      title,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 12.sp,
                        color: ApnaClinicAiUiConfig.secondaryText,
                      ),
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
    return Material(
      color: ApnaClinicAiUiConfig.panel,
      borderRadius: BorderRadius.circular(16.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16.r),
        child: Container(
          padding: EdgeInsets.all(14.r),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: ApnaClinicAiUiConfig.borderStrong),
            boxShadow: ApnaClinicAiUiConfig.cardShadow,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 36.r,
                height: 36.r,
                decoration: BoxDecoration(
                  color: ApnaClinicAiUiConfig.ctaSoft,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Icon(
                  icon,
                  color: ApnaClinicAiUiConfig.ctaDeep,
                  size: 18.r,
                ),
              ),
              SizedBox(height: 10.h),
              Text(
                tile.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 13.sp,
                  color: ApnaClinicAiUiConfig.primaryText,
                  height: 1.25,
                  letterSpacing: -0.1,
                ),
              ),
              if ((tile.subtitle ?? '').trim().isNotEmpty) ...[
                SizedBox(height: 4.h),
                Text(
                  tile.subtitle!.trim(),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: ApnaClinicAiUiConfig.muted,
                    height: 1.3,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
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
    return _icons[index % _icons.length];
  }
}

class _SosBanner extends StatelessWidget {
  const _SosBanner();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Material(
      color: ApnaClinicAiUiConfig.emergencyBg,
      borderRadius: BorderRadius.circular(14.r),
      child: InkWell(
        borderRadius: BorderRadius.circular(14.r),
        onTap: () => launchUrl(Uri.parse('tel:1122')),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14.r),
            border: Border.all(color: ApnaClinicAiUiConfig.emergencyBorder),
          ),
          child: Row(
            children: [
              Container(
                width: 34.r,
                height: 34.r,
                decoration: BoxDecoration(
                  color: ApnaClinicAiUiConfig.emergencyText.withValues(
                    alpha: 0.12,
                  ),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                alignment: Alignment.center,
                child: Icon(
                  Icons.emergency_outlined,
                  color: ApnaClinicAiUiConfig.emergencyText,
                  size: 18.r,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.apnaClinicAiSosTitle,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 12.sp,
                        color: ApnaClinicAiUiConfig.primaryText,
                        height: 1.3,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      l10n.apnaClinicAiSosBody,
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: ApnaClinicAiUiConfig.emergencyText,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.phone_in_talk_outlined,
                color: ApnaClinicAiUiConfig.emergencyText,
                size: 18.r,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
