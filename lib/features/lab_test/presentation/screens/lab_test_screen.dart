// Lab test browse: composes gradient shell + white panel; city prompt runs once
// after catalog load via BlocListener + post-frame (avoids sheet during loading).

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/dependency_injection.dart';
import '../../../../core/enums/state_status.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/preference/app_pref.dart';
import '../../../../core/preference/app_pref_keys.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/widgets/app_scaffold_gradient.dart';
import '../../domain/entities/lab_test_item_entity.dart';
import '../../domain/utils/lab_test_item_booking_helper.dart';
import '../cubit/lab_test_cubit.dart';
import '../cubit/lab_test_state.dart';
import '../lab_test_route_args.dart';
import '../widgets/lab_test_browse_header_widget.dart';
import '../widgets/lab_test_browse_search_field_widget.dart';
import '../widgets/lab_test_browse_white_panel_widget.dart';
import '../widgets/lab_test_catalog_list_block_widget.dart';
import '../widgets/lab_test_city_selector_field_widget.dart';
import '../widgets/lab_test_select_city_dialog_widget.dart';

class LabTestScreen extends StatefulWidget {
  const LabTestScreen({super.key});

  @override
  State<LabTestScreen> createState() => _LabTestScreenState();
}

class _LabTestScreenState extends State<LabTestScreen> {
  final TextEditingController _searchController = TextEditingController();
  final AppPref _appPref = sl<AppPref>();

  static const String _cartPrefKey = 'lab_test_cart_items';

  bool _hasResolvedInitialCity = false;
  bool _hasPromptedCitySelection = false;
  bool _isCityDialogOpen = false;
  String? _savedCity;

  @override
  void initState() {
    super.initState();
    final rawSavedCity = _appPref.getString(AppPrefKeys.labTestSelectedCity)?.trim();
    _savedCity = (rawSavedCity == null || rawSavedCity.isEmpty)
        ? null
        : rawSavedCity;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _resolveInitialCitySelection(
        context,
        context.read<LabTestCubit>().state,
      );
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final cubit = context.read<LabTestCubit>();

    return BlocListener<LabTestCubit, LabTestState>(
      listenWhen: (previous, current) =>
          previous.catalogLoadingStateStatus !=
              current.catalogLoadingStateStatus ||
          previous.cities != current.cities ||
          previous.selectedCity != current.selectedCity,
      listener: (context, state) =>
          _resolveInitialCitySelection(context, state),
      child: AppScaffoldGradient(
        child: Column(
          children: [
            LabTestBrowseHeaderWidget(
              padding: EdgeInsets.fromLTRB(12.w, 4.h, 16.w, 18.h),
              title: l10n.labTestScreenTitle,
              cartCount: _cartCount(),
              cartBadgeOverflowLabel: l10n.labTestCartBadgeOverflow,
              onCartTap: () async {
                await context.pushNamed(AppRoutes.labTestCart);
                if (mounted) setState(() {});
              },
            ),
            Expanded(
              child: LabTestBrowseWhitePanelWidget(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    LabTestCitySelectorFieldWidget(
                      selectCityPlaceholder: l10n.labTestSelectCityPlaceholder,
                      cityFieldLabel: l10n.labTestCityFieldLabel,
                      changeCityCta: l10n.labTestChangeCityCta,
                      onTap: () => _openCityDialog(
                        context,
                        context.read<LabTestCubit>().state.cities,
                        l10n,
                      ),
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      l10n.labTestSelectTestHeading,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: const Color(0xFF061E40),
                            fontWeight: FontWeight.w500,
                            fontSize: 16.sp,
                          ),
                    ),
                    SizedBox(height: 12.h),
                    LabTestBrowseSearchFieldWidget(
                      controller: _searchController,
                      hintText: l10n.labTestSearchFieldHint,
                      onChanged: cubit.onSearchChanged,
                    ),
                    Expanded(
                      child: LabTestCatalogListBlockWidget(
                        loadFailedMessage: l10n.labTestCatalogLoadFailed,
                        emptyMessage: l10n.labTestNoTestsFound,
                        selectCityFirstMessage: l10n.labTestPleaseSelectCityFirst,
                        requirementLabel: l10n.labTestRequirementLabel,
                        sampleTypeLabel: l10n.labTestSampleTypeLabel,
                        feeFallbackText: l10n.labTestBrowseItemFeeFallback,
                        onItemTap: (item) => _onTestTap(context, item),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openCityDialog(
    BuildContext context,
    List<String> cities,
    AppLocalizations l10n,
  ) async {
    if (_isCityDialogOpen) return;
    _isCityDialogOpen = true;
    final picked = await showLabTestSelectCityDialog(
      context,
      cities: cities,
      title: l10n.labTestSelectCitySheetTitle,
      searchHint: l10n.labTestSelectCitySheetSearchHint,
      initialSelectedCity: context.read<LabTestCubit>().state.selectedCity,
    );
    _isCityDialogOpen = false;
    if (picked != null && context.mounted) {
      context.read<LabTestCubit>().selectCity(picked);
      _savedCity = picked;
      await _appPref.setString(AppPrefKeys.labTestSelectedCity, picked);
    }
  }

  void _resolveInitialCitySelection(
    BuildContext context,
    LabTestState state,
  ) {
    if (_hasResolvedInitialCity) return;
    if (state.catalogLoadingStateStatus == StateStatus.loading) return;

    final savedCity = _savedCity?.trim();
    final hasSavedCity = savedCity != null && savedCity.isNotEmpty;

    if (hasSavedCity) {
      if (state.cities.isNotEmpty && !state.cities.contains(savedCity)) {
        _savedCity = null;
        _appPref.remove(AppPrefKeys.labTestSelectedCity);
      } else if (state.cities.isEmpty &&
          state.catalogLoadingStateStatus != StateStatus.error) {
        return;
      } else {
        if (state.selectedCity != savedCity) {
          context.read<LabTestCubit>().selectCity(savedCity);
        }
        _hasResolvedInitialCity = true;
        return;
      }
    }

    if (state.selectedCity != null && state.selectedCity!.isNotEmpty) {
      _hasResolvedInitialCity = true;
      return;
    }

    if (state.cities.isEmpty) {
      if (state.catalogLoadingStateStatus == StateStatus.error) return;
      return;
    }

    _hasResolvedInitialCity = true;
    if (!_hasPromptedCitySelection) {
      _hasPromptedCitySelection = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!context.mounted) return;
        final l10n = AppLocalizations.of(context)!;
        final cities = context.read<LabTestCubit>().state.cities;
        if (cities.isEmpty) return;
        _openCityDialog(context, cities, l10n);
      });
    }
  }

  void _onTestTap(BuildContext context, LabTestItemEntity item) {
    final l10n = AppLocalizations.of(context)!;
    final cubit = context.read<LabTestCubit>();
    final state = cubit.state;
    final selectedCity = state.selectedCity;
    if (selectedCity == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.labTestPleaseSelectCityFirst)),
      );
      _openCityDialog(context, state.cities, l10n);
      return;
    }

    final vendors = LabTestItemBookingHelper.vendorsForItem(item);
    if (vendors.isEmpty || state.partners.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.labTestDataStillLoading)),
      );
      return;
    }

    final pricing = LabTestItemBookingHelper.pricingForItem(item);
    context.pushNamed(
      AppRoutes.labTestBooking,
      extra: LabTestBookingArgs(
        city: selectedCity,
        testTitle: item.title,
        sampleType: item.sampleType,
        requirementLabel: item.requirement,
        requirementLines: state.requirementLines,
        partners: state.partners
            .map(
              (p) => LabTestBookingPartnerOption(
                id: p.id,
                name: p.name,
                logoUrl: p.logoUrl,
              ),
            )
            .toList(growable: false),
        vendors: vendors
            .map(
              (v) => LabTestBookingVendorOption(
                id: v.id,
                name: v.name,
                logoUrl: v.logoUrl,
                markUrl: v.markUrl,
              ),
            )
            .toList(growable: false),
        discountedFee: item.discountedFee ?? pricing.discountedFee,
        originalFee: item.originalFee ?? pricing.originalFee,
        discountPercent: pricing.discountPercent,
        discountAmount: pricing.discountAmount,
        discountCode: pricing.discountCode,
        totalAmount: pricing.totalAmount,
      ),
    );
  }

  int _cartCount() {
    final raw = _appPref.getString(_cartPrefKey)?.trim();
    if (raw == null || raw.isEmpty) return 0;
    try {
      final decoded = jsonDecode(raw);
      if (decoded is List) return decoded.length;
      return 0;
    } catch (_) {
      return 0;
    }
  }
}
