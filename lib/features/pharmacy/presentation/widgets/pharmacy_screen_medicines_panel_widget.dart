import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/analytics/analytics_event_keys.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/enums/state_status.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/utils/auth_guard.dart';
import '../../../../core/widgets/app_button_widget.dart';
import '../../domain/entities/pharmacy_medicine_entity.dart';
import '../cubit/pharmacy_cubit.dart';
import '../cubit/pharmacy_state.dart';
import '../pharmacy_city_flow.dart';
import '../pharmacy_navigation.dart';
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
          previous.productUnavailableInCity !=
              current.productUnavailableInCity ||
          previous.selectedCity != current.selectedCity ||
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
      if (state.productUnavailableInCity) {
        final city = state.selectedCity.trim();
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                city.isEmpty
                    ? (state.productDetailErrorMessage ?? l10n.pharmacyLoadError)
                    : l10n.pharmacyProductNotAvailableInCity(city),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.clr5D758F,
                  fontSize: 14.sp,
                ),
              ),
              SizedBox(height: 16.h),
              AppButtonWidget(
                title: l10n.pharmacyChangeCityCta,
                onTap: () async {
                  final changed = await openPharmacyCityPicker(
                    context,
                    barrierDismissible: true,
                  );
                  if (!context.mounted || !changed) return;
                  _loadProductDetail();
                },
              ),
            ],
          ),
        );
      }
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
    if (!context.requireLogin(
      loginSource: AnalyticsAuthSourceKeys.pharmacy,
    )) {
      return;
    }
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
    context.read<PharmacyCubit>().logMedicineItemClicked(medicine);
    context.pushReplacementNamed(
      AppRoutes.pharmacy,
      extra: {PharmacyRouteExtraKeys.selectedMedicine: medicine},
    );
  }
}
