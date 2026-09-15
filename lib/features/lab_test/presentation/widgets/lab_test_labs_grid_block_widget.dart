import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/enums/state_status.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../domain/entities/lab_test_vendor_entity.dart';
import '../cubit/lab_test_cubit.dart';
import '../cubit/lab_test_state.dart';
import '../lab_test_route_args.dart';
import 'lab_test_booking_vendor_grid_widget.dart';
import 'lab_test_catalog_empty_widget.dart';
import 'lab_test_catalog_error_widget.dart';
import 'lab_test_labs_grid_shimmer_widget.dart';

/// Hub labs grid: loading / error / empty / selectable labs.
class LabTestLabsGridBlockWidget extends StatelessWidget {
  const LabTestLabsGridBlockWidget({
    super.key,
    required this.onLabTap,
    required this.loadFailedMessage,
    required this.emptyMessage,
    required this.selectCityFirstMessage,
  });

  final ValueChanged<LabTestVendorEntity> onLabTap;
  final String loadFailedMessage;
  final String emptyMessage;
  final String selectCityFirstMessage;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LabTestCubit, LabTestState>(
      buildWhen: (previous, current) =>
          previous.labsLoadingStateStatus != current.labsLoadingStateStatus ||
          previous.labs != current.labs ||
          previous.selectedCity != current.selectedCity ||
          previous.errorMessage != current.errorMessage,
      builder: (context, state) {
        final selectedCity = state.selectedCity;
        if (selectedCity == null || selectedCity.isEmpty) {
          if (state.labsLoadingStateStatus == StateStatus.loading) {
            return const LabTestLabsGridShimmerWidget();
          }
          return LabTestCatalogEmptyWidget(
            message: selectCityFirstMessage,
            showIllustration: false,
          );
        }

        if (state.labsLoadingStateStatus == StateStatus.loading) {
          return const LabTestLabsGridShimmerWidget();
        }

        if (state.labsLoadingStateStatus == StateStatus.error) {
          return LabTestCatalogErrorWidget(
            fallbackMessage: loadFailedMessage,
            detailMessage: state.errorMessage,
          );
        }

        if (state.labs.isEmpty) {
          return LabTestCatalogEmptyWidget(message: emptyMessage);
        }

        final vendors = state.labs
            .map(
              (lab) => LabTestBookingVendorOption(
                id: lab.id,
                name: lab.name,
                logoUrl: lab.logoUrl,
              ),
            )
            .toList(growable: false);

        return SingleChildScrollView(
          padding: EdgeInsets.only(top: 4.h, bottom: 16.h),
          child: LabTestBookingVendorGridWidget(
            vendors: vendors,
            selectedIndex: -1,
            onSelect: (index) => onLabTap(state.labs[index]),
          ),
        );
      },
    );
  }
}
