import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/flavor/flavor_config.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../apna_clinic_ai_copy.dart';
import '../constants/apna_clinic_ai_ui_config.dart';
import '../cubit/apna_clinic_ai_cubit.dart';
import '../cubit/apna_clinic_ai_state.dart';
import 'apna_clinic_ai_bot_avatar.dart';
import 'apna_clinic_ai_home_disclaimer.dart';
import 'apna_clinic_ai_sdk_endpoint_dialog.dart';

class ApnaClinicAiChatHeader extends StatelessWidget {
  const ApnaClinicAiChatHeader({
    super.key,
    required this.onBack,
    required this.onNewChat,
  });

  final VoidCallback onBack;
  final VoidCallback onNewChat;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BlocSelector<ApnaClinicAiCubit, ApnaClinicAiState, _HeaderVm>(
      selector: (state) => _HeaderVm(
        name: l10n.apnaClinicAiTitle,
        subtitle: apnaClinicAiHeaderStatus(
          l10n,
          connecting: state.connecting,
          recording: state.recording,
          streaming: state.streaming,
          thinkingStage: state.thinkingStage,
        ),
      ),
      builder: (context, vm) {
        return Container(
          padding: EdgeInsets.fromLTRB(8.w, 6.h, 8.w, 10.h),
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(color: ApnaClinicAiUiConfig.border),
            ),
          ),
          child: Row(
            children: [
              _HeaderIconButton(
                icon: Icons.arrow_back_ios_new_rounded,
                onPressed: onBack,
                size: 18,
              ),
              SizedBox(width: 4.w),
              const ApnaClinicAiBotAvatar(size: 40, animate: true),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      vm.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: ApnaClinicAiUiConfig.primaryText,
                        fontWeight: FontWeight.w700,
                        fontSize: 15.sp,
                        letterSpacing: -0.2,
                      ),
                    ),
                    Text(
                      vm.subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: ApnaClinicAiUiConfig.ctaDeep,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              _HeaderIconButton(
                icon: Icons.info_outline_rounded,
                onPressed: () => _showDisclaimer(context),
                tooltip: l10n.apnaClinicAiDisclaimerTitle,
              ),
              // if (_showSdkEndpointTool)
              //   _HeaderIconButton(
              //     icon: Icons.tune_rounded,
              //     onPressed: () => showApnaClinicAiSdkEndpointDialog(context),
              //     tooltip: l10n.apnaClinicAiSdkEndpointTooltip,
              //   ),
              _HeaderIconButton(
                icon: Icons.refresh_rounded,
                onPressed: onNewChat,
                tooltip: l10n.apnaClinicAiNewChat,
              ),
            ],
          ),
        );
      },
    );
  }
}

bool get _showSdkEndpointTool =>
    kDebugMode ||
    FlavorConfig.enableDebugFeatures ||
    !FlavorConfig.isProduction;

class _HeaderVm {
  const _HeaderVm({required this.name, required this.subtitle});

  final String name;
  final String subtitle;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _HeaderVm && name == other.name && subtitle == other.subtitle;

  @override
  int get hashCode => Object.hash(name, subtitle);
}

void _showDisclaimer(BuildContext context) {
  showDialog<void>(
    context: context,
    builder: (_) {
      return Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        insetPadding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 24.h),
        child: const SingleChildScrollView(
          child: ApnaClinicAiHomeDisclaimer(margin: EdgeInsets.zero),
        ),
      );
    },
  );
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
  static const _extent = 36.0;

  @override
  Widget build(BuildContext context) {
    final button = Material(
      color: ApnaClinicAiUiConfig.panel,
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onPressed,
        customBorder: const CircleBorder(),
        child: Container(
          width: _extent.r,
          height: _extent.r,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
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
    return Padding(
      padding: EdgeInsets.only(left: 4.w),
      child: tooltip == null ? button : Tooltip(message: tooltip!, child: button),
    );
  }
}
