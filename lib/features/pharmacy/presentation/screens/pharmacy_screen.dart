import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/enums/state_status.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/widgets/app_scaffold_gradient.dart';
import '../../domain/entities/pharmacy_medicine_entity.dart';
import '../cubit/pharmacy_cubit.dart';
import '../cubit/pharmacy_state.dart';
import '../widgets/pharmacy_add_to_cart_sheet.dart';
import '../widgets/pharmacy_medicine_content_section.dart';
import '../widgets/pharmacy_screen_header.dart';
import '../widgets/pharmacy_screen_state_view.dart';

class PharmacyScreen extends StatelessWidget {
  const PharmacyScreen({
    super.key,
    this.initialFeaturedMedicine,
  });

  final PharmacyMedicineEntity? initialFeaturedMedicine;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PharmacyCubit, PharmacyState>(
      builder: (context, state) {
        return AppScaffoldGradient(
          child: Column(
            children: [
              PharmacyScreenHeader(
                cartCount: state.cartCount,
                onBackTap: () => Navigator.of(context).maybePop(),
                onCartTap: () => _openCart(context),
              ),
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Colors.white,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(42.r)),
                  ),
                  child: _buildBody(context, state),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, PharmacyState state) {

    if (state.medicinesLoadingStateStatus == StateStatus.loading) {
      return const PharmacyScreenStateView.loading();
    }


    if (state.medicinesLoadingStateStatus == StateStatus.error) {
      return PharmacyScreenStateView.error(
        message: state.medicinesErrorMessage ?? AppStrings.pharmacyLoadError,
      );
    }

    if (state.medicines.isEmpty) {
      return const PharmacyScreenStateView.empty();
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
      onMedicineTap: (medicine) => _openPharmacyScreen(context, medicine),
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

  void _openCart(BuildContext context) {
    context.pushNamed(AppRoutes.pharmacyCart);
  }

  void _openPharmacyScreen(BuildContext context, PharmacyMedicineEntity medicine) {
    context.pushReplacementNamed(
      AppRoutes.pharmacy,
      extra: {
        'selectedMedicine': medicine,
      },
    );
  }
}
