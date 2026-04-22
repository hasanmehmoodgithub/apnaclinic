import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/enums/state_status.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/router/app_routes.dart';
import '../../domain/entities/pharmacy_medicine_entity.dart';
import '../cubit/pharmacy_cubit.dart';
import '../cubit/pharmacy_state.dart';
import '../widgets/pharmacy_add_to_cart_sheet.dart';
import '../widgets/pharmacy_main_content_section.dart';
import '../widgets/pharmacy_main_top_header.dart';
import '../widgets/pharmacy_screen_state_view.dart';

class PharmacyMainScreen extends StatelessWidget {
  const PharmacyMainScreen({super.key});
  static const double _topBannerFraction = 0.32;

  @override
  Widget build(BuildContext context) {
    final bannerHeight = MediaQuery.sizeOf(context).height * _topBannerFraction;
    return Scaffold(
      body: BlocBuilder<PharmacyCubit, PharmacyState>(
        builder: (context, state) {
          return ColoredBox(
            color: const Color(0xFFF4F6F8),
            child: Column(
              children: [
                SizedBox(
                  height: bannerHeight,
                  child: PharmacyMainTopHeader(
                    cartCount: state.cartCount,
                    onBackTap: () => Navigator.of(context).maybePop(),
                    onCartTap: () => _openCart(context),
                  ),
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
      ),
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

    final medicines = state.medicines.where((medicine) {
      final query = state.searchQuery.trim().toLowerCase();
      if (query.isEmpty) return true;
      return medicine.name.toLowerCase().contains(query);
    }).toList();

    return PharmacyMainContentSection(
      medicines: medicines,
      searchQuery: state.searchQuery,
      onSearchChanged: (value) => context.read<PharmacyCubit>().updateSearchQuery(value),
      onMedicineTap: (medicine) => _openPharmacyScreen(context, medicine),
      onAddToCartTap: (medicine) => _openAddToCartSheet(context, medicine),
    );
  }

  void _openCart(BuildContext context) {
    context.pushNamed(AppRoutes.pharmacyCart);
  }

  void _openPharmacyScreen(BuildContext context, PharmacyMedicineEntity medicine) {
    context.pushNamed(
      AppRoutes.pharmacy,
      extra: {
        'selectedMedicine': medicine,
      },
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
