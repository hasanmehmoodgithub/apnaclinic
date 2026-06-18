import 'package:flutter/material.dart';

import '../../../../components/shimmer/app_shimmer.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/enums/state_status.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../domain/entities/our_service_entity.dart';
import '../constants/dashboard_ui_config.dart';
import '../cubit/dashboard_services_state.dart';
import 'our_service_card.dart';

class OurServicesWidget extends StatelessWidget {
  const OurServicesWidget({
    super.key,
    required this.state,
    required this.onServiceTap,
  });

  final DashboardServicesState state;
  final ValueChanged<OurServiceEntity> onServiceTap;

  static const int _gridCrossAxisCount = 2;

  static SliverGridDelegate get _gridDelegate =>
      SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: _gridCrossAxisCount,
        mainAxisSpacing: DashboardUiConfig.serviceGridSpacing.h,
        crossAxisSpacing: DashboardUiConfig.serviceGridSpacing.w,
        childAspectRatio: DashboardUiConfig.serviceCardAspectRatio,
      );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (state.ourServicesLoadingStateStatus == StateStatus.loading) {
      return SliverPadding(
        padding: EdgeInsets.symmetric(
          horizontal: DashboardUiConfig.serviceGridHorizontalPadding.w,
        ),
        sliver: SliverGrid(
          gridDelegate: _gridDelegate,
          delegate: SliverChildBuilderDelegate(
            (_, _) => AppShimmerCard(
              borderRadius: DashboardUiConfig.serviceCardBorderRadius.r,
            ),
            childCount: 4,
          ),
        ),
      );
    }

    if (state.ourServicesLoadingStateStatus == StateStatus.error) {
      return SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            DashboardUiConfig.serviceGridHorizontalPadding.w,
            8.h,
            DashboardUiConfig.serviceGridHorizontalPadding.w,
            8.h,
          ),
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
      padding: EdgeInsets.symmetric(
        horizontal: DashboardUiConfig.serviceGridHorizontalPadding.w,
      ),
      sliver: SliverGrid(
        gridDelegate: _gridDelegate,
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final service = state.servicesList[index];
            return OurServiceCardWidget(
              title: service.title,
              discountLabel: service.offerUpto,
              imageAsset: service.thumb,
              route: service.route,
              onTap: () => onServiceTap(service),
            );
          },
          childCount: state.servicesList.length,
        ),
      ),
    );
  }
}
