// Lab test hub: city + labs grid. Tests load after a lab is picked.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/analytics/analytics_event_keys.dart';
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
import '../../domain/entities/lab_test_vendor_entity.dart';
import '../cubit/lab_test_cart_cubit.dart';
import '../cubit/lab_test_cubit.dart';
import '../cubit/lab_test_state.dart';
import '../lab_test_analytics.dart';
import '../lab_test_cart_change_guard.dart';
import '../lab_test_navigation.dart';
import '../lab_test_route_args.dart';
import '../widgets/lab_test_browse_header_widget.dart';
import '../widgets/lab_test_browse_white_panel_widget.dart';
import '../widgets/lab_test_city_selector_field_widget.dart';
import '../widgets/lab_test_labs_grid_block_widget.dart';

class LabTestScreen extends StatefulWidget {
  const LabTestScreen({super.key});

  @override
  State<LabTestScreen> createState() => _LabTestScreenState();
}

class _LabTestScreenState extends State<LabTestScreen> {
  final AppPref _appPref = sl<AppPref>();

  bool _hasResolvedInitialCity = false;
  bool _hasPromptedCitySelection = false;
  bool _isCityDialogOpen = false;
  String? _savedCity;

  @override
  void initState() {
    super.initState();
    final rawSavedCity =
        _appPref.getString(AppPrefKeys.labTestSelectedCity)?.trim();
    _savedCity = (rawSavedCity == null || rawSavedCity.isEmpty)
        ? null
        : rawSavedCity;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      LabTestAnalytics.logModule();
      if (!AuthGuard.isLoggedIn(_appPref)) return;
      context.read<LabTestCartCubit>().load();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocListener<LabTestCubit, LabTestState>(
      listenWhen: (previous, current) =>
          previous.labsLoadingStateStatus != current.labsLoadingStateStatus ||
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
              cartCount: 0,
              cartBadgeOverflowLabel: l10n.labTestCartBadgeOverflow,
              showCart: false,
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
                      l10n.labTestSelectLabHeading,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: const Color(0xFF061E40),
                            fontWeight: FontWeight.w500,
                            fontSize: 16.sp,
                          ),
                    ),
                    SizedBox(height: 12.h),
                    Expanded(
                      child: LabTestLabsGridBlockWidget(
                        loadFailedMessage: l10n.labTestLabsLoadFailed,
                        emptyMessage: l10n.labTestNoLabsFound,
                        selectCityFirstMessage:
                            l10n.labTestPleaseSelectCityFirst,
                        onLabTap: (lab) => _onLabTap(context, lab),
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
        if (!mounted) return;
        await context.read<LabTestCartCubit>().load();
      },
    );
  }

  void _resolveInitialCitySelection(
    BuildContext context,
    LabTestState state,
  ) {
    if (_hasResolvedInitialCity) return;
    if (state.labsLoadingStateStatus == StateStatus.loading) {
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
      if (state.labsLoadingStateStatus == StateStatus.error) {
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

  Future<void> _onLabTap(
    BuildContext context,
    LabTestVendorEntity lab,
  ) async {
    if (!context.requireLogin(loginSource: AnalyticsAuthSourceKeys.lab)) {
      return;
    }

    final cubit = context.read<LabTestCubit>();
    final city = cubit.state.selectedCity;
    if (city == null || city.isEmpty) return;

    await context.pushNamed(
      AppRoutes.labTestSelectTest,
      extra: LabTestSelectTestArgs(
        city: city,
        lab: lab,
        requirementLines: cubit.state.requirementLines,
      ),
    );
    if (!context.mounted) return;
    await context.read<LabTestCartCubit>().load();
  }
}
