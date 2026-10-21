import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../constants/apna_clinic_ai_ui_config.dart';
import '../cubit/apna_clinic_ai_cubit.dart';
import '../cubit/apna_clinic_ai_state.dart';

class ApnaClinicAiSettingsSheet extends StatelessWidget {
  const ApnaClinicAiSettingsSheet({super.key, required this.cubit});

  final ApnaClinicAiCubit cubit;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BlocBuilder<ApnaClinicAiCubit, ApnaClinicAiState>(
      bloc: cubit,
      builder: (context, state) {
        return Padding(
          padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 24.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: ApnaClinicAiUiConfig.border,
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                ),
              ),
              SizedBox(height: 12.h),
              Text(
                l10n.settings,
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w800,
                  color: ApnaClinicAiUiConfig.primaryText,
                ),
              ),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(
                  l10n.apnaClinicAiSpeakReplies,
                  style: TextStyle(
                    color: ApnaClinicAiUiConfig.primaryText,
                    fontWeight: FontWeight.w600,
                    fontSize: 14.sp,
                  ),
                ),
                value: state.speakReplies,
                activeThumbColor: ApnaClinicAiUiConfig.cta,
                activeTrackColor: ApnaClinicAiUiConfig.cta.withValues(alpha: 0.35),
                onChanged: cubit.setSpeakReplies,
              ),
              SizedBox(
                width: double.infinity,
                height: 44.h,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: ApnaClinicAiUiConfig.cta,
                    side: const BorderSide(color: ApnaClinicAiUiConfig.cta),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                  ),
                  onPressed: () {
                    cubit.newChat();
                    context.pop();
                  },
                  child: Text(
                    l10n.apnaClinicAiNewChat,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 14.sp,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
