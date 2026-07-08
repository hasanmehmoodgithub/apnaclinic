import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/enums/state_status.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../domain/entities/instant_doctor_provider_entity.dart';
import '../cubit/instant_doctor_state.dart';
import 'instant_doctor_consultation_header_widget.dart';
import 'instant_doctor_provider_card_widget.dart';

class InstantDoctorProvidersListWidget extends StatelessWidget {
  const InstantDoctorProvidersListWidget({
    super.key,
    required this.state,
    required this.onProviderAction,
    required this.onCancelSubscription,
  });

  final InstantDoctorState state;
  final ValueChanged<InstantDoctorProviderEntity> onProviderAction;
  final ValueChanged<InstantDoctorProviderEntity> onCancelSubscription;

  static const EdgeInsets _listPadding = EdgeInsets.fromLTRB(20, 12, 20, 32);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (state.loadingStateStatus == StateStatus.loading) {
      return ListView(
        padding: EdgeInsets.fromLTRB(
          _listPadding.left.w,
          _listPadding.top.h,
          _listPadding.right.w,
          _listPadding.bottom.h,
        ),
        children: [
          const InstantDoctorConsultationHeaderWidget(),
          SizedBox(height: 16.h),
          const InstantDoctorProviderCardShimmer(),
          SizedBox(height: 14.h),
          const InstantDoctorProviderCardShimmer(),
        ],
      );
    }

    if (state.providers.isEmpty) {
      return ListView(
        padding: EdgeInsets.fromLTRB(
          _listPadding.left.w,
          _listPadding.top.h,
          _listPadding.right.w,
          _listPadding.bottom.h,
        ),
        children: [
          const InstantDoctorConsultationHeaderWidget(),
          SizedBox(height: 24.h),
          Text(
            l10n.instantDoctorNoProviders,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.clr6C7C92,
              fontSize: 15.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      );
    }

    return ListView.separated(
      padding: EdgeInsets.fromLTRB(
        _listPadding.left.w,
        _listPadding.top.h,
        _listPadding.right.w,
        _listPadding.bottom.h,
      ),
      itemCount: state.providers.length + 1,
      separatorBuilder: (context, index) {
        if (index == 0) return SizedBox(height: 16.h);
        return SizedBox(height: 14.h);
      },
      itemBuilder: (context, index) {
        if (index == 0) {
          return const InstantDoctorConsultationHeaderWidget();
        }

        final provider = state.providers[index - 1];
        return InstantDoctorProviderCardWidget(
          provider: provider,
          isLoading:
              state.openingProviderId == provider.providerId ||
              state.cancellingProviderId == provider.providerId ||
              (state.sendOtpStatus == StateStatus.loading &&
                  state.activeOtpProvider?.providerId == provider.providerId),
          onPrimaryAction: () => onProviderAction(provider),
          onCancelSubscription: () => onCancelSubscription(provider),
        );
      },
    );
  }
}
