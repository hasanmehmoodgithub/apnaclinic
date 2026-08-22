import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/analytics/analytics_event_keys.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/widgets/app_scaffold_gradient.dart';
import '../../domain/entities/pharmacy_medicine_entity.dart';
import '../cubit/pharmacy_cubit.dart';
import '../cubit/pharmacy_state.dart';
import '../pharmacy_navigation.dart';
import '../widgets/pharmacy_screen_header_widget.dart';
import '../widgets/pharmacy_screen_medicines_panel_widget.dart';

/// Detail pharmacy: featured item + grid (opened from hub or in-flow replacement).
class PharmacyScreen extends StatefulWidget {
  const PharmacyScreen({
    super.key,
    this.initialFeaturedMedicine,
    this.moduleSource,
  });

  final PharmacyMedicineEntity? initialFeaturedMedicine;
  final String? moduleSource;

  @override
  State<PharmacyScreen> createState() => _PharmacyScreenState();
}

class _PharmacyScreenState extends State<PharmacyScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (widget.moduleSource != AnalyticsPharmacySourceKeys.search) return;
      context.read<PharmacyCubit>().logPharmacyModule(widget.moduleSource!);
    });
  }

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
                onCartTap: () => pharmacyOpenCart(context),
              );
            },
          ),
          AppScaffoldGradientPanel(
            child: PharmacyScreenMedicinesPanelWidget(
              initialFeaturedMedicine: widget.initialFeaturedMedicine,
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
