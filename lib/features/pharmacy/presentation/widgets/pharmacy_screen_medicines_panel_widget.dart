import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/enums/state_status.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/utils/auth_guard.dart';
import '../../domain/entities/pharmacy_medicine_entity.dart';
import '../cubit/pharmacy_cubit.dart';
import '../cubit/pharmacy_state.dart';
import 'pharmacy_add_to_cart_sheet.dart';
import 'pharmacy_medicine_content_section.dart';
import 'pharmacy_screen_state_view.dart';

/// Featured medicine + related products from product-detail API.
class PharmacyScreenMedicinesPanelWidget extends StatefulWidget {
  const PharmacyScreenMedicinesPanelWidget({
    super.key,
    this.initialFeaturedMedicine,
  });

  final PharmacyMedicineEntity? initialFeaturedMedicine;

  @override
  State<PharmacyScreenMedicinesPanelWidget> createState() =>
      _PharmacyScreenMedicinesPanelWidgetState();
}

class _PharmacyScreenMedicinesPanelWidgetState
    extends State<PharmacyScreenMedicinesPanelWidget> {
  @override
  void initState() {
    super.initState();
    _loadProductDetail();
  }

  @override
  void didUpdateWidget(covariant PharmacyScreenMedicinesPanelWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialFeaturedMedicine?.id !=
        widget.initialFeaturedMedicine?.id) {
      _loadProductDetail();
    }
  }

  void _loadProductDetail() {
    final productId = widget.initialFeaturedMedicine?.id;
    if (productId == null || productId.isEmpty) return;
    context.read<PharmacyCubit>().loadProductDetail(productId);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BlocBuilder<PharmacyCubit, PharmacyState>(
      buildWhen: (previous, current) =>
          previous.productDetailLoadingStateStatus !=
              current.productDetailLoadingStateStatus ||
          previous.productDetailErrorMessage !=
              current.productDetailErrorMessage ||
          previous.selectedProduct != current.selectedProduct ||
          previous.relatedProducts != current.relatedProducts,
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
    if (state.productDetailLoadingStateStatus == StateStatus.loading) {
      return const PharmacyScreenStateView.loading();
    }

    if (state.productDetailLoadingStateStatus == StateStatus.error) {
      return PharmacyScreenStateView.error(
        message: state.productDetailErrorMessage ?? l10n.pharmacyLoadError,
      );
    }

    final featured = state.selectedProduct;
    if (featured == null) {
      return PharmacyScreenStateView.empty(
        message: l10n.pharmacyEmptyMedicines,
      );
    }

    return PharmacyMedicineContentSection(
      medicines: state.relatedProducts,
      featuredMedicine: featured,
      onAddToCart: (medicine) => _openAddToCartSheet(context, medicine),
      onMedicineTap: (medicine) => _openPharmacyDetail(context, medicine),
    );
  }

  Future<void> _openAddToCartSheet(
    BuildContext context,
    PharmacyMedicineEntity medicine,
  ) async {
    if (!context.requireLogin()) return;
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
