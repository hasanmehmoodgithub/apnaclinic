import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/analytics/analytics_event_keys.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/preference/app_pref.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/session/auth_session_refresh.dart';
import '../../../../core/utils/auth_guard.dart';
import '../../../../core/widgets/app_scaffold_gradient.dart';
import '../../domain/entities/lab_test_item_entity.dart';
import '../cubit/lab_test_cart_cubit.dart';
import '../cubit/lab_test_cart_state.dart';
import '../cubit/lab_test_cubit.dart';
import '../lab_test_analytics.dart';
import '../lab_test_navigation.dart';
import '../lab_test_route_args.dart';
import '../widgets/lab_test_browse_header_widget.dart';
import '../widgets/lab_test_browse_search_field_widget.dart';
import '../widgets/lab_test_browse_white_panel_widget.dart';
import '../widgets/lab_test_catalog_list_block_widget.dart';
import '../widgets/lab_test_selected_lab_field_widget.dart';

class LabTestSelectTestScreen extends StatefulWidget {
  const LabTestSelectTestScreen({super.key});

  @override
  State<LabTestSelectTestScreen> createState() => _LabTestSelectTestScreenState();
}

class _LabTestSelectTestScreenState extends State<LabTestSelectTestScreen> {
  final TextEditingController _searchController = TextEditingController();
  final AppPref _appPref = sl<AppPref>();
  late final AuthSessionRefresh _sessionRefresh;
  late int _appliedProRevision;

  @override
  void initState() {
    super.initState();
    _sessionRefresh = sl<AuthSessionRefresh>();
    _appliedProRevision = _sessionRefresh.proMembershipRevision;
    _sessionRefresh.addListener(_onAuthSessionChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (!AuthGuard.isLoggedIn(_appPref)) return;
      context.read<LabTestCartCubit>().load();
    });
  }

  void _onAuthSessionChanged() {
    if (!mounted) return;
    final revision = _sessionRefresh.proMembershipRevision;
    if (revision == _appliedProRevision) return;
    _appliedProRevision = revision;
    final cubit = context.read<LabTestCubit>();
    final city = cubit.state.selectedCity?.trim() ?? '';
    if (city.isEmpty) return;
    cubit.loadCatalog(
      cityName: city,
      lab: cubit.state.selectedLab,
      refresh: true,
      search: _searchController.text.trim().isEmpty
          ? null
          : _searchController.text.trim(),
    );
  }

  @override
  void dispose() {
    _sessionRefresh.removeListener(_onAuthSessionChanged);
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final cubit = context.read<LabTestCubit>();
    final lab = cubit.state.selectedLab;

    return AppScaffoldGradient(
      child: Column(
        children: [
          BlocBuilder<LabTestCartCubit, LabTestCartState>(
            buildWhen: (previous, current) =>
                previous.items.length != current.items.length,
            builder: (context, cartState) {
              final cartCount = AuthGuard.isLoggedIn(_appPref)
                  ? cartState.items.length
                  : 0;
              return LabTestBrowseHeaderWidget(
                padding: EdgeInsets.fromLTRB(12.w, 4.h, 16.w, 18.h),
                titleFontSize: 19.sp,
                title: l10n.labTestSelectTestHeading,
                cartCount: cartCount,
                cartBadgeOverflowLabel: l10n.labTestCartBadgeOverflow,
                onCartTap: () async {
                  await labTestOpenCart(context);
                  if (!mounted) return;
                  await context.read<LabTestCartCubit>().load();
                },
              );
            },
          ),
          Expanded(
            child: LabTestBrowseWhitePanelWidget(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (lab != null) ...[
                    LabTestSelectedLabFieldWidget(
                      lab: lab,
                      changeCta: l10n.labTestChangeCityCta,
                      onTap: () => context.pop(),
                    ),
                    SizedBox(height: 14.h),
                  ],
                  LabTestBrowseSearchFieldWidget(
                    controller: _searchController,
                    hintText: l10n.labTestSearchFieldHint,
                    onSearchTapped: LabTestAnalytics.logSearchClicked,
                    onSearch: cubit.submitSearch,
                    onClear: () => cubit.submitSearch(''),
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    l10n.labTestSelectTestHeading,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: AppColors.clr061E40,
                          fontWeight: FontWeight.w500,
                          fontSize: 15.sp,
                        ),
                  ),
                  SizedBox(height: 4.h),
                  Expanded(
                    child: LabTestCatalogListBlockWidget(
                      loadFailedMessage: l10n.labTestCatalogLoadFailed,
                      emptyMessage: l10n.labTestNoRecordFound,
                      selectCityFirstMessage: l10n.labTestPleaseSelectCityFirst,
                      requirementLabel: l10n.labTestRequirementLabel,
                      sampleTypeLabel: l10n.labTestSampleTypeLabel,
                      feeFallbackText: l10n.labTestBrowseItemFeeFallback,
                      showLabsSummary: false,
                      onItemTap: (item) => _onTestTap(context, item),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _onTestTap(BuildContext context, LabTestItemEntity item) async {
    if (!context.requireLogin(loginSource: AnalyticsAuthSourceKeys.lab)) {
      return;
    }

    final l10n = AppLocalizations.of(context)!;
    final cubit = context.read<LabTestCubit>();
    final state = cubit.state;
    final selectedCity = state.selectedCity;
    final lab = state.selectedLab;
    if (selectedCity == null || lab == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.labTestPleaseSelectCityFirst)),
      );
      return;
    }

    final testId = int.tryParse(item.id);
    if (testId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.labTestBookingDataUnavailable)),
      );
      return;
    }

    LabTestAnalytics.logItemSelectFromCatalog(item);

    await context.pushNamed(
      AppRoutes.labTestBooking,
      extra: LabTestBookingArgs.pending(
        testId: testId,
        city: selectedCity,
        requirementLines: state.requirementLines,
        testTitle: item.title,
        preferredLabId: lab.id,
        preferredLabName: lab.name,
        preferredLabLogoUrl: lab.logoUrl,
      ),
    );
    if (!context.mounted) return;
    await context.read<LabTestCartCubit>().load();
  }
}
