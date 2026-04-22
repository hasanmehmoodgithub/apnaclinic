import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../../components/shimmer/app_shimmer.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../core/enums/state_status.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/preference/app_pref.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/widgets/app_scaffold_gradient.dart';
import '../../../../generated/assets.dart';
import '../../domain/entities/lab_test_item_entity.dart';
import '../cubit/lab_test_cubit.dart';
import '../cubit/lab_test_state.dart';
import '../lab_test_figma_assets.dart';
import '../lab_test_route_args.dart';
import '../widgets/lab_test_figma_image.dart';

class LabTestScreen extends StatefulWidget {
  const LabTestScreen({super.key});

  @override
  State<LabTestScreen> createState() => _LabTestScreenState();
}

class _LabTestScreenState extends State<LabTestScreen> {
  final _searchController = TextEditingController();
  final AppPref _appPref = sl<AppPref>();
  static const String _cityPrefKey = 'lab_test_selected_city';
  static const String _cartPrefKey = 'lab_test_cart_items';
  bool _hasResolvedInitialCity = false;
  bool _hasPromptedCitySelection = false;
  bool _isCitySheetOpen = false;
  String? _savedCity;

  @override
  void initState() {
    super.initState();
    final rawSavedCity = _appPref.getString(_cityPrefKey)?.trim();
    _savedCity = (rawSavedCity == null || rawSavedCity.isEmpty)
        ? null
        : rawSavedCity;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _openCitySheet(List<String> cities) async {
    if (_isCitySheetOpen) return;
    _isCitySheetOpen = true;
    final picked = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(top: MediaQuery.sizeOf(ctx).height * 0.1),
        child: _SelectCitySheet(cities: cities),
      ),
    );
    _isCitySheetOpen = false;
    if (picked != null && mounted) {
      context.read<LabTestCubit>().selectCity(picked);
      _savedCity = picked;
      await _appPref.setString(_cityPrefKey, picked);
    }
  }

  void _resolveInitialCitySelection(LabTestState state) {
    if (_hasResolvedInitialCity) return;
    if (state.catalogLoadingStateStatus == StateStatus.loading ||
        state.catalogLoadingStateStatus == StateStatus.refreshing) {
      return;
    }
    if (state.cities.isEmpty) return;

    if (state.selectedCity != null && state.selectedCity!.isNotEmpty) {
      _hasResolvedInitialCity = true;
      return;
    }

    final savedCity = _savedCity;
    if (savedCity != null && state.cities.contains(savedCity)) {
      context.read<LabTestCubit>().selectCity(savedCity);
      _hasResolvedInitialCity = true;
      return;
    }

    _hasResolvedInitialCity = true;
    if (!_hasPromptedCitySelection) {
      _hasPromptedCitySelection = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        _openCitySheet(state.cities);
      });
    }
  }

  void _onTestTap(LabTestItemEntity item, LabTestState state) {
    final selectedCity = state.selectedCity;
    if (selectedCity == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a city first.')),
      );
      _openCitySheet(state.cities);
      return;
    }
    final pricing = state.pricing;
    if (pricing == null || state.partners.isEmpty || state.vendors.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lab test data is still loading.')),
      );
      return;
    }
    context.push(
      AppRoutes.path(AppRoutes.labTestBooking),
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
        vendors: state.vendors
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

  @override
  Widget build(BuildContext context) {
    final state = context.watch<LabTestCubit>().state;
    final cubit = context.read<LabTestCubit>();
    final theme = Theme.of(context);
    final cartCount = _cartCount();

    return BlocListener<LabTestCubit, LabTestState>(
      listener: (context, currentState) => _resolveInitialCitySelection(
        currentState,
      ),
      child: AppScaffoldGradient(
        child: Column(
          children: [
            _BrowseHeader(
              cartCount: cartCount,
              onCartTap: () => context.push(AppRoutes.path(AppRoutes.labTestCart)),
            ),
            Expanded(
              child: Center(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(40),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 29, 24, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () => _openCitySheet(state.cities),
                            borderRadius: BorderRadius.circular(5.32),
                            child: Container(
                              height: 62,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 13,
                                vertical: 14,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5.32),
                                border: Border.all(
                                  color: const Color(0xFF9BA6A7),
                                  width: 1.0,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: state.selectedCity == null
                                        ? Text(
                                            'Select City',
                                            style: theme.textTheme.bodyMedium
                                                ?.copyWith(
                                                  color: const Color(
                                                    0xFF061E40,
                                                  ),
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 14.sp,
                                                ),
                                          )
                                        : Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                'City',
                                                style: theme.textTheme.bodySmall
                                                    ?.copyWith(
                                                      color: const Color(
                                                        0xFF667B99,
                                                      ),
                                                      fontSize: 12.sp,
                                                      height: 1,
                                                    ),
                                              ),
                                              Text(
                                                state.selectedCity!,
                                                style: theme
                                                    .textTheme
                                                    .bodyMedium
                                                    ?.copyWith(
                                                      color: const Color(
                                                        0xFF061E40,
                                                      ),
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 14.sp,
                                                      height: 1,
                                                    ),
                                              ),
                                            ],
                                          ),
                                  ),
                                  Text(
                                    'Change',
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: const Color(0xFF667B99),
                                      fontSize: 12.sp,
                                      height: 1,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  LabTestFigmaImage(
                                    url: LabTestFigmaAssets.citySheetChevron,
                                    width: 8,
                                    height: 4,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Select Test',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: const Color(0xFF061E40),
                            fontWeight: FontWeight.w500,
                            fontSize: 16.sp,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          height: 48,
                          padding: const EdgeInsets.symmetric(horizontal: 11),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(39.988),
                            border: Border.all(
                              color: const Color(0xFF9BA6A7),
                              width: 1.0,
                            ),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: _searchController,
                                  onChanged: cubit.onSearchChanged,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: const Color(0xFF061E40),
                                    fontSize: 14.sp,
                                  ),
                                  decoration: InputDecoration(
                                    isDense: true,
                                    border: InputBorder.none,
                                    hintText: 'Search',
                                    hintStyle: theme.textTheme.bodyMedium
                                        ?.copyWith(
                                          color: const Color(0xFF667B99),
                                          fontSize: 14.sp,
                                        ),
                                  ),
                                ),
                              ),
                              LabTestFigmaImage(
                                url: LabTestFigmaAssets.citySheetSearchGlyph,
                                width: 13,
                                height: 13,
                              ),
                            ],
                          ),
                        ),
                        Expanded(child: _testsSection(state)),
                        // Center(
                        //   child: Container(
                        //     width: 130,
                        //     height: 5,
                        //     margin: const EdgeInsets.only(top: 8),
                        //     decoration: BoxDecoration(
                        //       color: const Color(0xFFB9C0C9),
                        //       borderRadius: BorderRadius.circular(100),
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _testsSection(LabTestState state) {
    if (state.catalogLoadingStateStatus == StateStatus.loading ||
        state.catalogLoadingStateStatus == StateStatus.refreshing) {
      return const _LabTestBrowseShimmerView();
    }

    if (state.catalogLoadingStateStatus == StateStatus.error) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            state.errorMessage ?? 'Failed to load lab tests',
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    if (state.filteredItems.isEmpty) {
      return const Center(child: Text('No tests found'));
    }

    return ListView.separated(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      itemCount: state.filteredItems.length,
      separatorBuilder: (context, index) => const SizedBox(height: 14),
      itemBuilder: (context, index) {
        final item = state.filteredItems[index];
        return _LabTestBrowseCard(
          item: item,
          onTap: () => _onTestTap(item, state),
        );
      },
    );
  }
}

class _LabTestBrowseShimmerView extends StatelessWidget {
  const _LabTestBrowseShimmerView();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        SizedBox(height: 10.h),
        AppShimmerCard(height: 126.h, borderRadius: 14.r),
        SizedBox(height: 14.h),
        AppShimmerCard(height: 126.h, borderRadius: 14.r),
        SizedBox(height: 14.h),
        AppShimmerCard(height: 126.h, borderRadius: 14.r),
      ],
    );
  }
}

class _BrowseHeader extends StatelessWidget {
  const _BrowseHeader({required this.cartCount, required this.onCartTap});

  final int cartCount;
  final VoidCallback onCartTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 4, 16, 18),
      child: Row(
        children: [
          Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () => context.pop(),
              child: const SizedBox(
                width: 40,
                height: 40,
                child: Icon(
                  Icons.arrow_back_rounded,
                  color: Color(0xFF061E40),
                  size: 24,
                ),
              ),
            ),
          ),
          Expanded(
            child: Text(
              'Lab Test',
              textAlign: TextAlign.center,
              style: theme.textTheme.titleLarge?.copyWith(
                color: const Color(0xFF061E40),
                fontWeight: FontWeight.w700,
                fontSize: 20.sp,
                height: 30.9 / 20,
              ),
            ),
          ),
          InkWell(
            onTap: onCartTap,
            borderRadius: BorderRadius.circular(20),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  alignment: Alignment.center,
                  child: SvgPicture.asset(
                    Assets.iconsBasket,
                    width: 16.r,
                    height: 16.r,
                    colorFilter: const ColorFilter.mode(
                      Color(0xFF667B99),
                      BlendMode.srcIn,
                    ),
                  ),
                ),
                if (cartCount > 0)
                  Positioned(
                    right: 2,
                    top: 2,
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFFE43131),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        cartCount > 9 ? '9+' : '$cartCount',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.white,
                          fontSize: 8.sp,
                          fontWeight: FontWeight.w700,
                          height: 1,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LabTestBrowseCard extends StatelessWidget {
  const _LabTestBrowseCard({required this.item, required this.onTap});

  final LabTestItemEntity item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final discountedFee = item.discountedFee ?? 'Rs. 15,000/-';
    final originalFee = item.originalFee;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFEDE4E4), width: 1.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(14, 13, 14, 13),
                decoration: const BoxDecoration(
                  color: Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(14)),
                ),
                child: Text(
                  item.title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontFamily: 'Afacad',
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 18.sp,
                    height: 1.2,
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(14), // 👈 important
                  ),
                ),
                padding: const EdgeInsets.fromLTRB(14, 13, 14, 13),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.labsSummary ?? '',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: const Color(0xFF4B5B72),
                        fontSize: 13.sp,
                        height: 1.15,
                      ),
                    ),
                    const SizedBox(height: 10),
                    if (item.requirement != null && item.requirement!.isNotEmpty) ...[
                      Row(
                        children: [
                          Text(
                            'Requirement',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: const Color(0xFF2F3E54),
                              fontSize: 13.sp,
                            ),
                          ),
                          const SizedBox(width: 6),
                          _InfoPill(value: item.requirement!, highlight: true),
                        ],
                      ),
                      const SizedBox(height: 10),
                    ],
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: Wrap(
                            spacing: 6,
                            runSpacing: 6,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              Text(
                                'Sample Type',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: const Color(0xFF2F3E54),
                                  fontSize: 13.sp,
                                ),
                              ),
                              _InfoPill(value: item.sampleType),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: _PricePill(
                                originalFee: originalFee,
                                discountedFee: discountedFee,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoPill extends StatelessWidget {
  const _InfoPill({required this.value, this.highlight = false});

  final String value;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: highlight ? const Color(0xFFB7EAC3) : Colors.white,
        borderRadius: BorderRadius.circular(59),
        border: highlight
            ? null
            : Border.all(color: const Color(0xFFE7E7E7), width: 1.0),
      ),
      child: Text(
        value,
        style: theme.textTheme.bodySmall?.copyWith(
          color: highlight ? const Color(0xFF198733) : const Color(0xFF9A9A9A),
          fontSize: 13.sp,
          height: 1.1,
        ),
      ),
    );
  }
}

class _PricePill extends StatelessWidget {
  const _PricePill({required this.originalFee, required this.discountedFee});

  final String? originalFee;
  final String discountedFee;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasOriginal = originalFee != null && originalFee!.trim().isNotEmpty;

    if (!hasOriginal) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFF11B2A4),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Text(
          discountedFee,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: Colors.white,
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: const Color(0xFFE0E3E8), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 8, 14, 8),
            child: Text(
              originalFee!,
              style: theme.textTheme.bodySmall?.copyWith(
                color: const Color(0xFFA5A5A5),
                decoration: TextDecoration.lineThrough,
                decorationThickness: 1.5,
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Transform.translate(
            offset: const Offset(0, 0),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFF11B2A4),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Text(
                discountedFee,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.white,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SelectCitySheet extends StatefulWidget {
  const _SelectCitySheet({required this.cities});

  final List<String> cities;

  @override
  State<_SelectCitySheet> createState() => _SelectCitySheetState();
}

class _SelectCitySheetState extends State<_SelectCitySheet> {
  final TextEditingController _query = TextEditingController();

  @override
  void dispose() {
    _query.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bottom = MediaQuery.paddingOf(context).bottom;
    final filtered = widget.cities
        .where(
          (c) => c.toLowerCase().contains(_query.text.trim().toLowerCase()),
        )
        .toList();

    return Material(
      color: Colors.white,
      borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 18, 24, 0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              LabTestFigmaImage(
                url: LabTestFigmaAssets.citySheetHandle,
                width: 37,
                height: 4,
              ),
              const SizedBox(height: 18),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Select a City',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: const Color(0xFF061E40),
                    fontWeight: FontWeight.w700,
                    fontSize: 16.437.sp,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Container(
                height: 45,
                padding: const EdgeInsets.symmetric(horizontal: 11),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xFF9BA6A7),
                    width: 1.0,
                  ),
                ),
                child: Row(
                  children: [
                    LabTestFigmaImage(
                      url: LabTestFigmaAssets.citySheetSearchFieldIcon,
                      width: 19,
                      height: 19,
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: TextField(
                        controller: _query,
                        onChanged: (_) => setState(() {}),
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: const Color(0xFF061E40),
                          fontSize: 14.sp,
                        ),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          isDense: true,
                          hintText: 'Search for City',
                          hintStyle: theme.textTheme.bodyMedium?.copyWith(
                            color: const Color(0xFF9E9E9E),
                            fontWeight: FontWeight.w500,
                            fontSize: 14.sp,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: MediaQuery.sizeOf(context).height * 0.42,
                child: ListView.separated(
                  itemCount: filtered.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 12),
                  itemBuilder: (context, i) {
                    final city = filtered[i];
                    return Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () => Navigator.pop(context, city),
                        borderRadius: BorderRadius.circular(4),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 16,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(
                              color: const Color(0xFF9BA6A7),
                              width: 1.0,
                            ),
                          ),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            city,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: const Color(0xFF061E40),
                              fontWeight: FontWeight.w500,
                              fontSize: 14.sp,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 11 + bottom),
              Center(
                child: Container(
                  width: 135,
                  height: 5,
                  margin: const EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFB9C0C9),
                    borderRadius: BorderRadius.circular(100),
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
