import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/analytics/analytics_event_keys.dart';
import '../../../../core/enums/state_status.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/utils/auth_guard.dart';
import '../../domain/entities/pharmacy_medicine_entity.dart';
import '../cubit/pharmacy_cubit.dart';
import '../cubit/pharmacy_state.dart';
import '../pharmacy_navigation.dart';
import 'pharmacy_add_to_cart_sheet.dart';
import 'pharmacy_main_medicines_grid_widget.dart';
import 'pharmacy_main_search_field_widget.dart';
import 'pharmacy_main_section_title_widget.dart';
import 'pharmacy_scan_prescription_search_button.dart';
import 'pharmacy_screen_state_view.dart';

/// Hub white panel: load / error / empty / search + grid. Rebuilds when medicines or search change, not on cart-only updates.
class PharmacyMainMedicinesBodyWidget extends StatefulWidget {
  const PharmacyMainMedicinesBodyWidget({super.key});

  @override
  State<PharmacyMainMedicinesBodyWidget> createState() =>
      _PharmacyMainMedicinesBodyWidgetState();
}

class _PharmacyMainMedicinesBodyWidgetState
    extends State<PharmacyMainMedicinesBodyWidget> {
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

    context.read<PharmacyCubit>().loadMoreMedicines();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BlocBuilder<PharmacyCubit, PharmacyState>(
      buildWhen: (previous, current) =>
          previous.medicinesLoadingStateStatus !=
              current.medicinesLoadingStateStatus ||
          previous.medicinesErrorMessage != current.medicinesErrorMessage ||
          previous.medicines != current.medicines ||
          previous.searchQuery != current.searchQuery ||
          previous.isLoadingMore != current.isLoadingMore,
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(18.w, 16.h, 18.w, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  PharmacyMainSectionTitleWidget(
                    title: l10n.pharmacyMainChooseMedicineTitle,
                  ),
                  SizedBox(height: 10.h),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: PharmacyMainSearchFieldWidget(
                          searchQuery: state.searchQuery,
                          searchHint: l10n.pharmacyMainSearchHint,
                          onSearchTapped: () =>
                              context.read<PharmacyCubit>().logSearchClicked(),
                          onSearchSubmitted: (value) =>
                              context.read<PharmacyCubit>().submitSearch(value),
                          onSearchCleared: () =>
                              context.read<PharmacyCubit>().submitSearch(''),
                        ),
                      ),
                      SizedBox(width: 10.w),
                      const PharmacyScanPrescriptionSearchButton(),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 8.h),
            Expanded(child: _buildResults(context, l10n, state)),
          ],
        );
      },
    );
  }

  Widget _buildResults(
    BuildContext context,
    AppLocalizations l10n,
    PharmacyState state,
  ) {
    if (state.medicinesLoadingStateStatus == StateStatus.loading ||
        state.medicinesLoadingStateStatus == StateStatus.refreshing) {
      return const PharmacyMainMedicinesGridShimmer();
    }

    if (state.medicinesLoadingStateStatus == StateStatus.error) {
      return PharmacyScreenStateView.error(
        message: state.medicinesErrorMessage ?? l10n.pharmacyLoadError,
      );
    }

    if (state.medicines.isEmpty) {
      return PharmacyScreenStateView.empty(
        message: l10n.pharmacyEmptyMedicines,
      );
    }

    return ListView(
      controller: _scrollController,
      padding: EdgeInsets.fromLTRB(18.w, 0, 18.w, 24.h),
      children: [
        PharmacyMainMedicinesGridWidget(
          medicines: state.medicines,
          onMedicineTap: (medicine) => _openPharmacyDetail(context, medicine),
          onAddToCartTap: (medicine) => _openAddToCartSheet(context, medicine),
        ),
        if (state.isLoadingMore)
          Padding(
            padding: EdgeInsets.symmetric(vertical: 16.h),
            child: const Center(
              child: CircularProgressIndicator(
                color: AppColors.clr40AFA2,
                strokeWidth: 2,
              ),
            ),
          ),
      ],
    );
  }

  void _openPharmacyDetail(
    BuildContext context,
    PharmacyMedicineEntity medicine,
  ) {
    context.read<PharmacyCubit>().logMedicineItemClicked(medicine);
    context.pushNamed(
      AppRoutes.pharmacy,
      extra: {PharmacyRouteExtraKeys.selectedMedicine: medicine},
    );
  }

  Future<void> _openAddToCartSheet(
    BuildContext context,
    PharmacyMedicineEntity medicine,
  ) async {
    if (!context.requireLogin(
      loginSource: AnalyticsAuthSourceKeys.pharmacy,
    )) {
      return;
    }
    await showPharmacyAddToCartSheet(
      context,
      medicine,
      loaderIdPrefix: 'pharmacy_main_add_to_cart',
    );
  }
}
