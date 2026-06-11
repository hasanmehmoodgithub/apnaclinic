import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/enums/state_status.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../domain/entities/lab_test_item_entity.dart';
import '../cubit/lab_test_cubit.dart';
import '../cubit/lab_test_state.dart';
import 'lab_test_browse_item_tile_widget.dart';
import 'lab_test_catalog_empty_widget.dart';
import 'lab_test_catalog_error_widget.dart';
import 'lab_test_catalog_shimmer_widget.dart';

/// Scrollable catalog area: loading, error, empty, or list — scoped Bloc rebuilds.
class LabTestCatalogListBlockWidget extends StatelessWidget {
  const LabTestCatalogListBlockWidget({
    super.key,
    required this.onItemTap,
    required this.loadFailedMessage,
    required this.emptyMessage,
    required this.selectCityFirstMessage,
    required this.requirementLabel,
    required this.sampleTypeLabel,
    required this.feeFallbackText,
  });

  final ValueChanged<LabTestItemEntity> onItemTap;
  final String loadFailedMessage;
  final String emptyMessage;
  final String selectCityFirstMessage;
  final String requirementLabel;
  final String sampleTypeLabel;
  final String feeFallbackText;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LabTestCubit, LabTestState>(
      buildWhen: (previous, current) =>
          previous.catalogLoadingStateStatus !=
              current.catalogLoadingStateStatus ||
          previous.filteredItems != current.filteredItems ||
          previous.selectedCity != current.selectedCity ||
          previous.errorMessage != current.errorMessage,
      builder: (context, state) {
        final selectedCity = state.selectedCity;
        if (selectedCity == null || selectedCity.isEmpty) {
          if (state.catalogLoadingStateStatus == StateStatus.loading) {
            return const LabTestCatalogShimmerWidget();
          }
          return LabTestCatalogEmptyWidget(message: selectCityFirstMessage);
        }

        if (state.catalogLoadingStateStatus == StateStatus.loading ||
            state.catalogLoadingStateStatus == StateStatus.refreshing) {
          return const LabTestCatalogShimmerWidget();
        }

        if (state.catalogLoadingStateStatus == StateStatus.error) {
          return LabTestCatalogErrorWidget(
            fallbackMessage: loadFailedMessage,
            detailMessage: state.errorMessage,
          );
        }

        if (state.filteredItems.isEmpty) {
          return LabTestCatalogEmptyWidget(message: emptyMessage);
        }

        return ListView.separated(
          padding: EdgeInsets.symmetric(vertical: 10.h),
          itemCount: state.filteredItems.length,
          separatorBuilder: (context, index) => SizedBox(height: 14.h),
          itemBuilder: (context, index) {
            final item = state.filteredItems[index];
            return LabTestBrowseItemTileWidget(
              item: item,
              onTap: () => onItemTap(item),
              requirementLabel: requirementLabel,
              sampleTypeLabel: sampleTypeLabel,
              feeFallbackText: feeFallbackText,
            );
          },
        );
      },
    );
  }
}
