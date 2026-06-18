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

  int _rowCount(int itemCount) => (itemCount + _gridCrossAxisCount - 1) ~/ _gridCrossAxisCount;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final horizontalPadding = DashboardUiConfig.serviceGridHorizontalPadding.w;
    final gridSpacing = DashboardUiConfig.serviceGridSpacing;

    if (state.ourServicesLoadingStateStatus == StateStatus.loading) {
      return SliverPadding(
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
        sliver: SliverList(
          delegate: SliverChildBuilderDelegate(
            (_, rowIndex) => _ServiceGridRow(
              spacing: gridSpacing.w,
              bottomSpacing: rowIndex < 1 ? gridSpacing.h : 0,
              left: AppShimmerCard(
                height: DashboardUiConfig.serviceCardShimmerHeight.h,
                borderRadius: DashboardUiConfig.serviceCardBorderRadius.r,
              ),
              right: AppShimmerCard(
                height: DashboardUiConfig.serviceCardShimmerHeight.h,
                borderRadius: DashboardUiConfig.serviceCardBorderRadius.r,
              ),
            ),
            childCount: 2,
          ),
        ),
      );
    }

    if (state.ourServicesLoadingStateStatus == StateStatus.error) {
      return SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            horizontalPadding,
            8.h,
            horizontalPadding,
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

    final services = state.servicesList;
    final rows = _rowCount(services.length);

    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, rowIndex) {
            final leftIndex = rowIndex * _gridCrossAxisCount;
            final rightIndex = leftIndex + 1;

            return _ServiceGridRow(
              spacing: gridSpacing.w,
              bottomSpacing: rowIndex < rows - 1 ? gridSpacing.h : 0,
              left: OurServiceCardWidget(
                title: services[leftIndex].title,
                discountLabel: services[leftIndex].offerUpto,
                imageAsset: services[leftIndex].thumb,
                route: services[leftIndex].route,
                onTap: () => onServiceTap(services[leftIndex]),
              ),
              right: rightIndex < services.length
                  ? OurServiceCardWidget(
                      title: services[rightIndex].title,
                      discountLabel: services[rightIndex].offerUpto,
                      imageAsset: services[rightIndex].thumb,
                      route: services[rightIndex].route,
                      onTap: () => onServiceTap(services[rightIndex]),
                    )
                  : null,
            );
          },
          childCount: rows,
        ),
      ),
    );
  }
}

class _ServiceGridRow extends StatelessWidget {
  const _ServiceGridRow({
    required this.left,
    this.right,
    required this.spacing,
    required this.bottomSpacing,
  });

  final Widget left;
  final Widget? right;
  final double spacing;
  final double bottomSpacing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: bottomSpacing),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(child: left),
            SizedBox(width: spacing),
            Expanded(
              child: right ?? const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}
