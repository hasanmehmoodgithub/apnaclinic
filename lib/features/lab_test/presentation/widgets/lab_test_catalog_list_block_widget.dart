import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_colors.dart';
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
class LabTestCatalogListBlockWidget extends StatefulWidget {
  const LabTestCatalogListBlockWidget({
    super.key,
    required this.onItemTap,
    required this.loadFailedMessage,
    required this.emptyMessage,
    required this.selectCityFirstMessage,
    required this.requirementLabel,
    required this.sampleTypeLabel,
    required this.feeFallbackText,
    this.showLabsSummary = true,
  });

  final ValueChanged<LabTestItemEntity> onItemTap;
  final String loadFailedMessage;
  final String emptyMessage;
  final String selectCityFirstMessage;
  final String requirementLabel;
  final String sampleTypeLabel;
  final String feeFallbackText;
  final bool showLabsSummary;

  @override
  State<LabTestCatalogListBlockWidget> createState() =>
      _LabTestCatalogListBlockWidgetState();
}

class _LabTestCatalogListBlockWidgetState
    extends State<LabTestCatalogListBlockWidget> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final position = _scrollController.position;
    if (position.pixels < position.maxScrollExtent - 200) return;
    context.read<LabTestCubit>().loadMoreCatalog();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LabTestCubit, LabTestState>(
      buildWhen: (previous, current) =>
          previous.catalogLoadingStateStatus !=
              current.catalogLoadingStateStatus ||
          previous.filteredItems != current.filteredItems ||
          previous.selectedCity != current.selectedCity ||
          previous.searchQuery != current.searchQuery ||
          previous.errorMessage != current.errorMessage ||
          previous.isLoadingMore != current.isLoadingMore ||
          previous.hasMoreItems != current.hasMoreItems,
      builder: (context, state) {
        final selectedCity = state.selectedCity;
        if (selectedCity == null || selectedCity.isEmpty) {
          if (state.catalogLoadingStateStatus == StateStatus.loading) {
            return const LabTestCatalogShimmerWidget();
          }
          return LabTestCatalogEmptyWidget(
            message: widget.selectCityFirstMessage,
            showIllustration: false,
            fontSize: 13.sp,
          );
        }

        if (state.catalogLoadingStateStatus == StateStatus.loading ||
            state.catalogLoadingStateStatus == StateStatus.refreshing) {
          return const LabTestCatalogShimmerWidget();
        }

        if (state.catalogLoadingStateStatus == StateStatus.error &&
            state.filteredItems.isEmpty) {
          return LabTestCatalogErrorWidget(
            fallbackMessage: widget.loadFailedMessage,
            detailMessage: state.errorMessage,
          );
        }

        if (state.filteredItems.isEmpty) {
          return LabTestCatalogEmptyWidget(
            message: widget.emptyMessage,
            fontSize: 13.sp,
          );
        }

        final showFooter = state.isLoadingMore;
        final itemCount =
            state.filteredItems.length + (showFooter ? 1 : 0);

        return ListView.separated(
          controller: _scrollController,
          padding: EdgeInsets.only(top: 8.h, bottom: 10.h),
          itemCount: itemCount,
          separatorBuilder: (context, index) => SizedBox(height: 12.h),
          itemBuilder: (context, index) {
            if (index >= state.filteredItems.length) {
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 16.h),
                child: Center(
                  child: SizedBox(
                    width: 24.r,
                    height: 24.r,
                    child: const CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.clr0FAA9A,
                    ),
                  ),
                ),
              );
            }

            final item = state.filteredItems[index];
            return LabTestBrowseItemTileWidget(
              item: item,
              onTap: () => widget.onItemTap(item),
              requirementLabel: widget.requirementLabel,
              sampleTypeLabel: widget.sampleTypeLabel,
              feeFallbackText: widget.feeFallbackText,
              showLabsSummary: widget.showLabsSummary,
              compactText: true,
            );
          },
        );
      },
    );
  }
}
