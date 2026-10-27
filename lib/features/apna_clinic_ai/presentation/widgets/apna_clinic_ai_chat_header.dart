import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../generated/assets.dart';
import '../constants/apna_clinic_ai_ui_config.dart';
import '../cubit/apna_clinic_ai_cubit.dart';
import '../cubit/apna_clinic_ai_state.dart';

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
        name: state.assistantName.isEmpty
            ? l10n.apnaClinicAiTitle
            : state.assistantName,
        subtitle: state.streaming
            ? l10n.apnaClinicAiJustAMoment
            : (state.headerSubtitle.trim().isNotEmpty
                  ? state.headerSubtitle.trim()
                  : l10n.apnaClinicAiOnline),
        streaming: state.streaming,
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
                    Row(
                      children: [
                        Container(
                          width: 6.r,
                          height: 6.r,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: vm.streaming
                                ? ApnaClinicAiUiConfig.cta
                                : ApnaClinicAiUiConfig.online,
                          ),
                        ),
                        SizedBox(width: 6.w),
                        Expanded(
                          child: Text(
                            vm.subtitle,
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
                tooltip: l10n.apnaClinicAiNewChat,
              ),
            ],
          ),
        );
      },
    );
  }
}

class _HeaderVm {
  const _HeaderVm({
    required this.name,
    required this.subtitle,
    required this.streaming,
  });

  final String name;
  final String subtitle;
  final bool streaming;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _HeaderVm &&
          name == other.name &&
          subtitle == other.subtitle &&
          streaming == other.streaming;

  @override
  int get hashCode => Object.hash(name, subtitle, streaming);
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
      borderRadius: BorderRadius.circular(10.r),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(10.r),
        child: Container(
          width: _extent.r,
          height: _extent.r,
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
    return Padding(
      padding: EdgeInsets.only(left: 4.w),
      child: tooltip == null ? button : Tooltip(message: tooltip!, child: button),
    );
  }
}
