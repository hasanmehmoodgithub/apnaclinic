// Lab test browse: composes gradient shell + white panel; city prompt runs once
// after catalog load via BlocListener + post-frame (avoids sheet during loading).

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/cities/presentation/show_select_city_dialog.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../core/enums/state_status.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/preference/app_pref.dart';
import '../../../../core/preference/app_pref_keys.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/utils/auth_guard.dart';
import '../../../../core/widgets/app_scaffold_gradient.dart';
import '../../domain/entities/lab_test_item_entity.dart';
import '../cubit/lab_test_cubit.dart';
import '../cubit/lab_test_state.dart';
import '../lab_test_cart_change_guard.dart';
import '../lab_test_navigation.dart';
import '../lab_test_route_args.dart';
import '../widgets/lab_test_browse_header_widget.dart';
import '../widgets/lab_test_browse_search_field_widget.dart';
import '../widgets/lab_test_browse_white_panel_widget.dart';
import '../widgets/lab_test_catalog_list_block_widget.dart';
import '../widgets/lab_test_city_selector_field_widget.dart';

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
                await labTestOpenCart(context);
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
                      onSearch: cubit.submitSearch,
                    ),
                    Expanded(
                      child: LabTestCatalogListBlockWidget(
                        loadFailedMessage: l10n.labTestCatalogLoadFailed,
                        emptyMessage: l10n.labTestNoRecordFound,
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
    final cubit = context.read<LabTestCubit>();
    final picked = await showSelectCityDialog(
      context,
      cities: cities,
      title: l10n.selectCityTitle,
      searchHint: l10n.selectCitySearchHint,
      initialSelectedCity: cubit.state.selectedCity,
    );
    _isCityDialogOpen = false;
    if (picked == null || !context.mounted) return;

    final currentCity = cubit.state.selectedCity;
    if (picked == currentCity) return;

    await labTestGuardCartClearingChange(
      context,
      onProceed: () async {
        _savedCity = picked;
        await cubit.selectCity(picked);
        if (mounted) setState(() {});
      },
      onViewCart: () async {
        await labTestOpenCart(context);
        if (mounted) setState(() {});
      },
    );
  }

  void _resolveInitialCitySelection(
    BuildContext context,
    LabTestState state,
  ) {
    if (_hasResolvedInitialCity) return;
    if (state.catalogLoadingStateStatus == StateStatus.loading ||
        state.catalogLoadingStateStatus == StateStatus.refreshing) {
      return;
    }

    final savedCity = _savedCity?.trim();
    final hasSavedCity = savedCity != null && savedCity.isNotEmpty;

    final cubit = context.read<LabTestCubit>();
    if (hasSavedCity &&
        state.cities.isNotEmpty &&
        !cubit.isCityInList(savedCity)) {
      _savedCity = null;
      _appPref.remove(AppPrefKeys.labTestSelectedCity);
    }

    final selectedCity = state.selectedCity;
    if (selectedCity != null && selectedCity.isNotEmpty) {
      _hasResolvedInitialCity = true;
      return;
    }

    if (state.cities.isEmpty) {
      if (state.catalogLoadingStateStatus == StateStatus.error) {
        _hasResolvedInitialCity = true;
      }
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
    if (!context.requireLogin()) return;

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

    final testId = int.tryParse(item.id);
    if (testId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.labTestBookingDataUnavailable)),
      );
      return;
    }

    context.pushNamed(
      AppRoutes.labTestBooking,
      extra: LabTestBookingArgs.pending(
        testId: testId,
        city: selectedCity,
        requirementLines: state.requirementLines,
        testTitle: item.title,
      ),
    );
  }

  int _cartCount() {
    if (!AuthGuard.isLoggedIn(_appPref)) return 0;
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
