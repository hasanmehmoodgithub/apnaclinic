import 'package:flutter/material.dart';

import '../../../../components/shimmer/app_shimmer.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/enums/state_status.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../domain/entities/our_service_entity.dart';
import '../cubit/dashboard_services_state.dart';
import 'service_card.dart';

class OurServicesWidget extends StatelessWidget {
  const OurServicesWidget({
    super.key,
    required this.state,
    required this.onServiceTap,
  });

  final DashboardServicesState state;
  final ValueChanged<OurServiceEntity> onServiceTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (state.ourServicesLoadingStateStatus == StateStatus.loading) {
      return SliverPadding(
        padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 0),
        sliver: SliverToBoxAdapter(
          child: AppShimmerList(
            itemCount: 4,
            itemHeight: 100.h,
            borderRadius: 16.r,
            spacing: 10.h,
          ),
        ),
      );
    }

    if (state.ourServicesLoadingStateStatus == StateStatus.error) {
      return SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 8.h),
          child: Text(
            state.servicesErrorMessage ?? AppStrings.ourServicesLoadError,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: Colors.red,
            ),
          ),
        ),
      );
    }

    return SliverPadding(
      padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 0),
      sliver: SliverList.separated(
        itemCount: state.servicesList.length,
        separatorBuilder: (context, index) => SizedBox(height: 10.h),
        itemBuilder: (context, index) {
          final service = state.servicesList[index];
          return ServiceCard(
            title: service.title,
            subtitle: service.subtitle,
            discountLabel: service.offerUpto,
            imageAsset: service.thumb,
            onTap: () => onServiceTap(service),
          );
        },
      ),
    );
  }
}

