import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/enums/state_status.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/router/app_routes.dart';
import '../../domain/entities/pharmacy_medicine_entity.dart';
import '../cubit/pharmacy_cubit.dart';
import '../cubit/pharmacy_state.dart';
import 'pharmacy_add_to_cart_sheet.dart';
import 'pharmacy_medicine_content_section.dart';
import 'pharmacy_screen_state_view.dart';

/// Featured medicine + grid. [buildWhen] avoids rebuilds when only the cart changes.
class PharmacyScreenMedicinesPanelWidget extends StatelessWidget {
  const PharmacyScreenMedicinesPanelWidget({
    super.key,
    this.initialFeaturedMedicine,
  });

  final PharmacyMedicineEntity? initialFeaturedMedicine;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BlocBuilder<PharmacyCubit, PharmacyState>(
      buildWhen: (previous, current) =>
          previous.medicinesLoadingStateStatus !=
              current.medicinesLoadingStateStatus ||
          previous.medicinesErrorMessage != current.medicinesErrorMessage ||
          previous.medicines != current.medicines,
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

    final featuredMedicine = initialFeaturedMedicine == null
        ? state.medicines.first
        : state.medicines.firstWhere(
            (medicine) => medicine.id == initialFeaturedMedicine!.id,
            orElse: () => initialFeaturedMedicine!,
          );

    return PharmacyMedicineContentSection(
      medicines: state.medicines,
      featuredMedicine: featuredMedicine,
      onAddToCart: (medicine) => _openAddToCartSheet(context, medicine),
      onMedicineTap: (medicine) => _openPharmacyDetail(context, medicine),
    );
  }

  Future<void> _openAddToCartSheet(
    BuildContext context,
    PharmacyMedicineEntity medicine,
  ) async {
    await showPharmacyAddToCartSheet(
      context,
      medicine,
      loaderIdPrefix: 'pharmacy_add_to_cart',
    );
  }

  void _openPharmacyDetail(
    BuildContext context,
    PharmacyMedicineEntity medicine,
  ) {
    context.pushReplacementNamed(
      AppRoutes.pharmacy,
      extra: {'selectedMedicine': medicine},
    );
  }
}
