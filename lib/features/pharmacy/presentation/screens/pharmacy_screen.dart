import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/widgets/app_scaffold_gradient.dart';
import '../../domain/entities/pharmacy_medicine_entity.dart';
import '../cubit/pharmacy_cubit.dart';
import '../cubit/pharmacy_state.dart';
import '../widgets/pharmacy_screen_header_widget.dart';
import '../widgets/pharmacy_screen_medicines_panel_widget.dart';

/// Detail pharmacy: featured item + grid (opened from hub or in-flow replacement).
class PharmacyScreen extends StatelessWidget {
  const PharmacyScreen({super.key, this.initialFeaturedMedicine});

  final PharmacyMedicineEntity? initialFeaturedMedicine;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return AppScaffoldGradient(
      child: Column(
        children: [
          BlocSelector<PharmacyCubit, PharmacyState, int>(
            selector: (state) => state.cartCount,
            builder: (context, cartCount) {
              return PharmacyScreenHeaderWidget(
                title: l10n.pharmacyScreenTitle,
                cartCount: cartCount,
                onBackTap: () => _popOrIgnore(context),
                onCartTap: () => context.pushNamed(AppRoutes.pharmacyCart),
              );
            },
          ),
          AppScaffoldGradientPanel(
            child: PharmacyScreenMedicinesPanelWidget(
              initialFeaturedMedicine: initialFeaturedMedicine,
            ),
          ),
        ],
      ),
    );
  }

  /// Prefer go_router; if there is nothing to pop, do nothing (e.g. cold start deep link).
  void _popOrIgnore(BuildContext context) {
    if (context.canPop()) {
      context.pop();
    }
  }
}
