import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/analytics/analytics_event_keys.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../cubit/pharmacy_cubit.dart';
import '../cubit/pharmacy_state.dart';
import '../pharmacy_city_flow.dart';
import '../pharmacy_navigation.dart';
import '../widgets/pharmacy_main_medicines_body_widget.dart';
import '../widgets/pharmacy_main_top_header_widget.dart';

/// Pharmacy hub: banner header, then medicines list / search in the white panel.
class PharmacyMainScreen extends StatefulWidget {
  const PharmacyMainScreen({
    super.key,
    this.source = AnalyticsPharmacySourceKeys.home,
  });

  final String source;

  @override
  State<PharmacyMainScreen> createState() => _PharmacyMainScreenState();
}

class _PharmacyMainScreenState extends State<PharmacyMainScreen> {
  static const double _topBannerFraction = 0.32;
  bool _cityFlowInProgress = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _bootstrap();
    });
  }

  Future<void> _bootstrap() async {
    final cubit = context.read<PharmacyCubit>();
    cubit.logPharmacyModule(widget.source);
    cubit.clearHubSearch();
    await _ensureCityThenLoad(required: true);
  }

  Future<void> _ensureCityThenLoad({required bool required}) async {
    if (_cityFlowInProgress || !mounted) return;
    _cityFlowInProgress = true;
    final cubit = context.read<PharmacyCubit>();
    try {
      final ready = await cubit.syncPharmacyCityOnOpen();
      if (!mounted) return;
      if (!ready || cubit.state.needsPharmacyCitySelection) {
        final confirmed = await openPharmacyCityPicker(
          context,
          barrierDismissible: !required || cubit.hasPharmacyCity,
        );
        if (!mounted || !confirmed) return;
      } else {
        await Future.wait([
          cubit.loadMedicines(),
          cubit.loadCart(),
        ]);
      }
    } finally {
      _cityFlowInProgress = false;
    }
  }

  Future<void> _onDeliveringToTap() async {
    if (_cityFlowInProgress || !mounted) return;
    _cityFlowInProgress = true;
    try {
      await openPharmacyCityPicker(context, barrierDismissible: true);
    } finally {
      _cityFlowInProgress = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final bannerHeight = MediaQuery.sizeOf(context).height * _topBannerFraction;
    return BlocListener<PharmacyCubit, PharmacyState>(
      listenWhen: (previous, current) =>
          !previous.needsPharmacyCitySelection &&
          current.needsPharmacyCitySelection,
      listener: (context, state) {
        _ensureCityThenLoad(required: true);
      },
      child: Scaffold(
        body: ColoredBox(
          color: AppColors.clrF4F6F8,
          child: Column(
            children: [
              SizedBox(
                height: bannerHeight,
                child: BlocBuilder<PharmacyCubit, PharmacyState>(
                  buildWhen: (previous, current) =>
                      previous.cartCount != current.cartCount ||
                      previous.selectedCity != current.selectedCity,
                  builder: (context, state) {
                    return PharmacyMainTopHeaderWidget(
                      title: l10n.pharmacyScreenTitle,
                      cartCount: state.cartCount,
                      deliveringToCity: state.selectedCity,
                      onDeliveringToTap: state.selectedCity.trim().isEmpty
                          ? null
                          : _onDeliveringToTap,
                      onBackTap: () => pharmacyPopOrGoHome(context),
                      onCartTap: () => pharmacyOpenCart(context),
                    );
                  },
                ),
              ),
              Expanded(
                child: SafeArea(
                  top: false,
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.clrWhite,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(42.r),
                      ),
                    ),
                    child: const PharmacyMainMedicinesBodyWidget(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
