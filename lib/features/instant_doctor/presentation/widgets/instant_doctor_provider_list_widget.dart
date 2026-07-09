import 'package:apnaclinic/components/shimmer/app_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/enums/state_status.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../domain/entities/instant_doctor_provider_entity.dart';
import '../cubit/instant_doctor_cubit.dart';
import '../cubit/instant_doctor_state.dart';
import 'instant_doctor_consultation_header_widget.dart';
import 'instant_doctor_provider_card_widget.dart';

class InstantDoctorProviderListWidget extends StatelessWidget {
  const InstantDoctorProviderListWidget({
    super.key,
    required this.onProviderPrimaryTap,
    required this.onCancelSubscription,
  });

  final ValueChanged<InstantDoctorProviderEntity> onProviderPrimaryTap;
  final ValueChanged<InstantDoctorProviderEntity> onCancelSubscription;

  static const EdgeInsets _listPadding = EdgeInsets.fromLTRB(20, 12, 20, 32);

  @override
  Widget build(BuildContext context) {
    return BlocSelector<InstantDoctorCubit, InstantDoctorState, StateStatus>(
      selector: (state) => state.loadingStateStatus,
      builder: (context, loadingStatus) {
        if (loadingStatus == StateStatus.loading) {
          return const _InstantDoctorProviderListLoading();
        }

        return BlocSelector<InstantDoctorCubit, InstantDoctorState,
            List<InstantDoctorProviderEntity>>(
          selector: (state) => state.providers,
          builder: (context, providers) {
            if (providers.isEmpty) {
              return const _InstantDoctorProviderListEmpty();
            }

            return _InstantDoctorProviderListContent(
              providers: providers,
              onProviderPrimaryTap: onProviderPrimaryTap,
              onCancelSubscription: onCancelSubscription,
            );
          },
        );
      },
    );
  }
}

class _InstantDoctorProviderListLoading extends StatelessWidget {
  const _InstantDoctorProviderListLoading();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.fromLTRB(
        InstantDoctorProviderListWidget._listPadding.left.w,
        InstantDoctorProviderListWidget._listPadding.top.h,
        InstantDoctorProviderListWidget._listPadding.right.w,
        InstantDoctorProviderListWidget._listPadding.bottom.h,
      ),
      children: [
        const AppShimmerText(),
        SizedBox(height: 16.h),
        const AppShimmerText(),
        SizedBox(height: 16.h),
        const InstantDoctorProviderCardShimmer(),
        SizedBox(height: 14.h),
        const InstantDoctorProviderCardShimmer(),
      ],
    );
  }
}

class _InstantDoctorProviderListEmpty extends StatelessWidget {
  const _InstantDoctorProviderListEmpty();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return ListView(
      padding: EdgeInsets.fromLTRB(
        InstantDoctorProviderListWidget._listPadding.left.w,
        InstantDoctorProviderListWidget._listPadding.top.h,
        InstantDoctorProviderListWidget._listPadding.right.w,
        InstantDoctorProviderListWidget._listPadding.bottom.h,
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
}

class _InstantDoctorProviderListContent extends StatelessWidget {
  const _InstantDoctorProviderListContent({
    required this.providers,
    required this.onProviderPrimaryTap,
    required this.onCancelSubscription,
  });

  final List<InstantDoctorProviderEntity> providers;
  final ValueChanged<InstantDoctorProviderEntity> onProviderPrimaryTap;
  final ValueChanged<InstantDoctorProviderEntity> onCancelSubscription;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.fromLTRB(
        InstantDoctorProviderListWidget._listPadding.left.w,
        InstantDoctorProviderListWidget._listPadding.top.h,
        InstantDoctorProviderListWidget._listPadding.right.w,
        InstantDoctorProviderListWidget._listPadding.bottom.h,
      ),
      itemCount: providers.length + 1,
      separatorBuilder: (context, index) {
        if (index == 0) return SizedBox(height: 16.h);
        return SizedBox(height: 14.h);
      },
      itemBuilder: (context, index) {
        if (index == 0) {
          return const InstantDoctorConsultationHeaderWidget();
        }

        final provider = providers[index - 1];
        return InstantDoctorProviderCardWidget(
          provider: provider,
          onPrimaryAction: () => onProviderPrimaryTap(provider),
          onCancelSubscription: () => onCancelSubscription(provider),
        );
      },
    );
  }
}
