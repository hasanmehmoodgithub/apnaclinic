import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/enums/state_status.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/router/app_routes.dart';
import '../../domain/entities/pharmacy_medicine_entity.dart';
import '../cubit/pharmacy_cubit.dart';
import '../cubit/pharmacy_state.dart';
import 'pharmacy_add_to_cart_sheet.dart';
import 'pharmacy_main_medicines_grid_widget.dart';
import 'pharmacy_main_search_field_widget.dart';
import 'pharmacy_main_section_title_widget.dart';
import 'pharmacy_screen_state_view.dart';

/// Hub white panel: load / error / empty / search + grid. Rebuilds when medicines or search change, not on cart-only updates.
class PharmacyMainMedicinesBodyWidget extends StatelessWidget {
  const PharmacyMainMedicinesBodyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BlocBuilder<PharmacyCubit, PharmacyState>(
      buildWhen: (previous, current) =>
          previous.medicinesLoadingStateStatus !=
              current.medicinesLoadingStateStatus ||
          previous.medicinesErrorMessage != current.medicinesErrorMessage ||
          previous.medicines != current.medicines ||
          previous.searchQuery != current.searchQuery,
      builder: (context, state) {
        return _buildContent(context, l10n, state);
      },
    );
  }

  Widget _buildContent(
    BuildContext context,
    AppLocalizations l10n,
    PharmacyState state,
  ) {
    if (state.medicinesLoadingStateStatus == StateStatus.loading) {
      return const PharmacyScreenStateView.loading();
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

    final medicines = state.medicines.where((medicine) {
      final query = state.searchQuery.trim().toLowerCase();
      if (query.isEmpty) return true;
      return medicine.name.toLowerCase().contains(query);
    }).toList();

    return ListView(
      padding: EdgeInsets.fromLTRB(18.w, 16.h, 18.w, 24.h),
      children: [
        PharmacyMainSectionTitleWidget(
          title: l10n.pharmacyMainChooseMedicineTitle,
        ),
        SizedBox(height: 10.h),
        PharmacyMainSearchFieldWidget(
          searchQuery: state.searchQuery,
          searchHint: l10n.pharmacyMainSearchHint,
          onSearchChanged: (value) =>
              context.read<PharmacyCubit>().updateSearchQuery(value),
        ),
        SizedBox(height: 8.h),
        if (medicines.isEmpty)
          Padding(
            padding: EdgeInsets.symmetric(vertical: 28.h),
            child: Center(
              child: Text(
                l10n.pharmacyEmptyMedicines,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: const Color(0xFF6C7C92),
                ),
              ),
            ),
          )
        else
          PharmacyMainMedicinesGridWidget(
            medicines: medicines,
            onMedicineTap: (medicine) => _openPharmacyDetail(context, medicine),
            onAddToCartTap: (medicine) =>
                _openAddToCartSheet(context, medicine),
          ),
      ],
    );
  }

  void _openPharmacyDetail(
    BuildContext context,
    PharmacyMedicineEntity medicine,
  ) {
    context.pushNamed(
      AppRoutes.pharmacy,
      extra: {'selectedMedicine': medicine},
    );
  }

  Future<void> _openAddToCartSheet(
    BuildContext context,
    PharmacyMedicineEntity medicine,
  ) async {
    await showPharmacyAddToCartSheet(
      context,
      medicine,
      loaderIdPrefix: 'pharmacy_main_add_to_cart',
    );
  }
}
