import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/dependency_injection.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/preference/app_pref.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/widgets/app_scaffold_gradient.dart';
import '../../../../generated/assets.dart';
import '../lab_test_route_args.dart';
import '../widgets/lab_test_figma_image.dart';
import '../widgets/lab_test_price_pill.dart';

/// Lab selection + booking method (Figma node `2303:67674`).
class LabTestBookingScreen extends StatefulWidget {
  const LabTestBookingScreen({super.key, required this.args});

  final LabTestBookingArgs args;

  @override
  State<LabTestBookingScreen> createState() => _LabTestBookingScreenState();
}

class _LabTestBookingScreenState extends State<LabTestBookingScreen> {
  static const String _cartPrefKey = 'lab_test_cart_items';
  final AppPref _appPref = sl<AppPref>();
  bool _labVisit = true;
  int _partnerTab = 0;
  int _selectedVendorIndex = 0;

  List<LabTestCartItem> _readCartItems() {
    final raw = _appPref.getString(_cartPrefKey)?.trim();
    if (raw == null || raw.isEmpty) return <LabTestCartItem>[];
    try {
      final decoded = jsonDecode(raw);
      if (decoded is! List) return <LabTestCartItem>[];
      return decoded
          .whereType<Map<String, dynamic>>()
          .map(LabTestCartItem.fromJson)
          .toList(growable: false);
    } catch (_) {
      return <LabTestCartItem>[];
    }
  }

  Future<void> _writeCartItems(List<LabTestCartItem> items) async {
    final payload = items.map((e) => e.toJson()).toList(growable: false);
    await _appPref.setString(_cartPrefKey, jsonEncode(payload));
  }

  bool _containsCurrentSelection({
    required List<LabTestCartItem> items,
    required LabTestBookingVendorOption selectedVendor,
    required LabTestBookingPartnerOption selectedPartner,
  }) {
    return items.any(
      (e) =>
          e.testTitle == widget.args.testTitle &&
          e.labId == selectedVendor.id &&
          e.partnerId == selectedPartner.id,
    );
  }

  LabTestCartItem _toCartItem({
    required LabTestBookingVendorOption selectedVendor,
    required LabTestBookingPartnerOption selectedPartner,
  }) {
    return LabTestCartItem(
      testTitle: widget.args.testTitle,
      city: widget.args.city,
      labId: selectedVendor.id,
      labDisplayName: selectedVendor.name,
      labLogoUrl: selectedVendor.logoUrl,
      partnerId: selectedPartner.id,
      partnerLogoUrl: selectedPartner.logoUrl,
      sampleType: widget.args.sampleType,
      requirementLabel: widget.args.requirementLabel,
      requirementLines: widget.args.requirementLines,
      discountedFee: widget.args.discountedFee,
      originalFee: widget.args.originalFee,
      discountPercent: widget.args.discountPercent,
      discountAmount: widget.args.discountAmount,
      discountCode: widget.args.discountCode,
      totalAmount: widget.args.totalAmount,
      bookingMethodIsHomeSample: !_labVisit,
    );
  }

  Future<void> _guardSelectionChange({
    required List<LabTestCartItem> cartItems,
    required VoidCallback applyChange,
  }) async {
    if (cartItems.isEmpty) {
      setState(applyChange);
      return;
    }

    final action = await showDialog<_CartChangeDialogAction>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => const _CartChangeWarningDialog(),
    );
    if (!mounted || action == null) return;

    if (action == _CartChangeDialogAction.viewCart) {
      context.push(AppRoutes.path(AppRoutes.labTestCart));
      return;
    }

    await _writeCartItems(const <LabTestCartItem>[]);
    if (!mounted) return;
    setState(applyChange);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final partners = widget.args.partners;
    final vendors = widget.args.vendors;
    final selectedPartnerIndex =
        partners.isEmpty ? 0 : _partnerTab.clamp(0, partners.length - 1);
    final selectedVendorIndex =
        vendors.isEmpty ? 0 : _selectedVendorIndex.clamp(0, vendors.length - 1);
    final selectedVendor = vendors.isEmpty
        ? null
        : vendors[selectedVendorIndex];
    final cartItems = _readCartItems();
    final cartCount = cartItems.length;
    final selectedPartner = partners.isEmpty ? null : partners[selectedPartnerIndex];
    final isCurrentSelectionInCart =
        selectedVendor != null && selectedPartner != null
        ? _containsCurrentSelection(
            items: cartItems,
            selectedVendor: selectedVendor,
            selectedPartner: selectedPartner,
          )
        : false;

    return AppScaffoldGradient(
      child: Column(
        children: [
          _LabTestHeader(
            title: 'Lab Test',
            cartCount: cartCount,
            onCartTap: cartCount > 0
                ? () => context.push(AppRoutes.path(AppRoutes.labTestCart))
                : null,
          ),
          Expanded(
            child: Center(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(42),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(24, 29, 24, 24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            _CityBox(city: widget.args.city),
                            const SizedBox(height: 16),
                            Text(
                              'Choose a Booking Method',
                              style: theme.textTheme.titleMedium?.copyWith(
                                color: const Color(0xFF061E40),
                                fontWeight: FontWeight.w500,
                                fontSize: 16.sp,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(
                                  child: _MethodTile(
                                    title: 'Walk In',
                                    iconUrl: Assets.labTestWalkin,
                                    selected: _labVisit,
                                    onTap: _labVisit
                                        ? () {}
                                        : () => _guardSelectionChange(
                                            cartItems: cartItems,
                                            applyChange: () => _labVisit = true,
                                          ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: _MethodTile(
                                    title: 'Home Sample',
                                    iconUrl: Assets.labTestHomeSample,
                                    selected: !_labVisit,
                                    onTap: !_labVisit
                                        ? () {}
                                        : () => _guardSelectionChange(
                                            cartItems: cartItems,
                                            applyChange: () => _labVisit = false,
                                          ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            _TestSummaryCard(
                              title: widget.args.testTitle,
                              labName: selectedVendor?.name ?? '',
                              requirement: widget.args.requirementLabel,
                              sampleType: widget.args.sampleType,
                              discountedFee: widget.args.discountedFee,
                              originalFee: widget.args.originalFee,
                            ),
                            const SizedBox(height: 16),
                            // _RequirementsCard(
                            //   lines: widget.args.requirementLines,
                            // ),
                            // const SizedBox(height: 16),
                            _PartnerTabs(
                              partners: partners,
                              selectedIndex: selectedPartnerIndex,
                              onChanged: (i) {
                                if (i == _partnerTab) return;
                                _guardSelectionChange(
                                  cartItems: cartItems,
                                  applyChange: () => _partnerTab = i,
                                );
                              },
                            ),
                            const SizedBox(height: 12),
                            _LabVendorGrid(
                              vendors: vendors,
                              selectedIndex: selectedVendorIndex,
                              onSelect: (i) {
                                if (i == _selectedVendorIndex) return;
                                _guardSelectionChange(
                                  cartItems: cartItems,
                                  applyChange: () => _selectedVendorIndex = i,
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    _BottomCheckoutBar(
                      buttonText: isCurrentSelectionInCart
                          ? 'View Your Cart'
                          : 'Add to Cart',
                      cartCount: cartCount,
                      onProceed: () async {
                        if (selectedVendor == null || selectedPartner == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Lab test data unavailable'),
                            ),
                          );
                          return;
                        }
                        if (isCurrentSelectionInCart) {
                          context.push(AppRoutes.path(AppRoutes.labTestCart));
                          return;
                        }

                        final updated = <LabTestCartItem>[
                          ...cartItems,
                          _toCartItem(
                            selectedVendor: selectedVendor,
                            selectedPartner: selectedPartner,
                          ),
                        ];
                        await _writeCartItems(updated);
                        if (!mounted) return;
                        setState(() {});
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LabTestHeader extends StatelessWidget {
  const _LabTestHeader({
    required this.title,
    required this.cartCount,
    this.onCartTap,
  });

  final String title;
  final int cartCount;
  final VoidCallback? onCartTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 4, 16, 18),
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
              title,
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
                          fontSize: 7.sp,
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

class _CityBox extends StatelessWidget {
  const _CityBox({required this.city});

  final String city;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      height: 62,
      padding: const EdgeInsets.fromLTRB(13, 14, 13, 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.32),
        border: Border.all(color: const Color(0xFF9BA6A7), width: 1.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'City',
            style: theme.textTheme.bodySmall?.copyWith(
              color: const Color(0xFF667B99),
              fontSize: 12.sp,
              height: 1,
            ),
          ),
          Text(
            city,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: const Color(0xFF061E40),
              fontWeight: FontWeight.w500,
              fontSize: 14.sp,
              height: 1,
            ),
          ),
        ],
      ),
    );
  }
}

class _MethodTile extends StatelessWidget {
  const _MethodTile({
    required this.title,
    required this.iconUrl,
    required this.selected,
    required this.onTap,
  });

  final String title;
  final String iconUrl;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(5.32),
        child: Container(
          constraints: const BoxConstraints(minHeight: 62),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.32),
            border: Border.all(color: const Color(0xFF9BA6A7), width: 1.0),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    LabTestFigmaImage(url: iconUrl, width: 16, height: 16),
                    const SizedBox(height: 2),
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: const Color(0xFF110844),
                        fontSize: 14.sp,
                        height: 1,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 13,
                height: 13,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFF061E40),
                    width: 1.0,
                  ),
                ),
                alignment: Alignment.center,
                child: selected
                    ? Container(
                        width: 7.082,
                        height: 6.665,
                        decoration: BoxDecoration(
                          color: const Color(0xFF061E40),
                          borderRadius: BorderRadius.circular(10.801),
                        ),
                      )
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TestSummaryCard extends StatelessWidget {
  const _TestSummaryCard({
    required this.title,
    required this.labName,
    required this.sampleType,
    required this.discountedFee,
    required this.originalFee,
    this.requirement,
  });

  final String title;
  final String labName;
  final String sampleType;
  final String discountedFee;
  final String originalFee;
  final String? requirement;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFEDE4E4), width: 1.0),
        color: const Color(0xFFF1F1F1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 15, 14, 15),
            child: Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontFamily: 'Afacad',
                fontWeight: FontWeight.w500,
                fontSize: 18.sp,
                height: 1.2,
                color: Colors.black,
              ),
            ),
          ),
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(14),
              ),
            ),
            padding: const EdgeInsets.fromLTRB(14, 13, 14, 13),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  labName,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontFamily: 'Afacad',
                    fontSize: 14.sp,
                    height: 1.2,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (requirement != null) ...[
                            Container(
                              decoration: const BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: Color(0xFFDFDFDF),
                                    width: 1.0,
                                  ),
                                ),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 7),
                              child: Row(
                                children: [
                                  Text(
                                    'Requirement',
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      fontFamily: 'Afacad',
                                      color: const Color(0xFF2B2B2B),
                                      fontSize: 14.sp,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Flexible(
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFB7EAC3),
                                        borderRadius: BorderRadius.circular(59),
                                      ),
                                      child: FittedBox(
                                        fit: BoxFit.scaleDown,
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          requirement!,
                                          maxLines: 1,
                                          softWrap: false,
                                          style: theme.textTheme.bodySmall
                                              ?.copyWith(
                                                fontFamily: 'Afacad',
                                                color: const Color(0xFF198733),
                                                fontSize: 14.sp,
                                              ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 7),
                            child: Wrap(
                              spacing: 4,
                              runSpacing: 6,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                Text(
                                  'Sample Type',
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    fontFamily: 'Afacad',
                                    color: const Color(0xFF2B2B2B),
                                    fontSize: 14.sp,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(59),
                                    border: Border.all(
                                      color: const Color(0xFFE7E7E7),
                                      width: 1.0,
                                    ),
                                  ),
                                  child: Text(
                                    sampleType,
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      fontFamily: 'Afacad',
                                      color: const Color(0xFF959595),
                                      fontSize: 14.sp,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    LabTestPricePill(
                      originalFee: originalFee,
                      discountedFee: discountedFee,
                      borderColor: const Color(0xFFF1F1F1),
                      outerBorderRadius: 26,
                      discountedBorderRadius: 24.444,
                      originalPadding: const EdgeInsets.all(6.984),
                      discountedPadding: const EdgeInsets.all(6.984),
                      discountedBackgroundColor: const Color(0xFF0FAA9A),
                      originalTextColor: const Color(0xFF979797),
                      originalTextStyle: theme.textTheme.bodySmall?.copyWith(
                        fontFamily: 'Afacad',
                        fontSize: 12.sp,
                        height: 1.3,
                      ),
                      discountedTextStyle: theme.textTheme.bodyMedium?.copyWith(
                        fontFamily: 'Afacad',
                        fontSize: 12.sp,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RequirementsCard extends StatelessWidget {
  const _RequirementsCard({required this.lines});

  final List<String> lines;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFEDE4E4), width: 1.0),
        color: const Color(0xFFF1F1F1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 15, 14, 15),
            child: Text(
              'Requirements',
              style: theme.textTheme.titleMedium?.copyWith(
                fontFamily: 'Afacad',
                fontWeight: FontWeight.w500,
                fontSize: 18.sp,
                height: 16 / 18,
                color: Colors.black,
              ),
            ),
          ),
          Container(
            width: double.infinity,
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(14, 7, 14, 7),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (var i = 0; i < lines.length; i++) ...[
                  Padding(
                    padding: EdgeInsets.only(
                      left: 21,
                      bottom: i == lines.length - 1 ? 0 : 10,
                    ),
                    child: Text(
                      '${i + 1}. ${lines[i]}',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontFamily: 'Afacad',
                        fontSize: 14.sp,
                        height: 1.2,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PartnerTabs extends StatelessWidget {
  const _PartnerTabs({
    required this.partners,
    required this.selectedIndex,
    required this.onChanged,
  });

  final List<LabTestBookingPartnerOption> partners;
  final int selectedIndex;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Color(0xFFE6E6E6), width: 1.0),
          top: BorderSide(color: Color(0xFFE6E6E6), width: 1.0),
        ),
      ),
      child: partners.isEmpty
          ? const SizedBox.shrink()
          : Row(
              children: List.generate(partners.length, (index) {
                final partner = partners[index];
                final selected = selectedIndex == index;
                return Expanded(
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => onChanged(index),
                      child: Container(
                        height: 36,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: selected
                                  ? const Color(0xFF0FAA9A)
                                  : const Color(0xFFE6E6E6),
                              width: 1.0,
                            ),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 26,
                              height: 26,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6),
                                color: Colors.white,
                                border: Border.all(
                                  color: const Color(0x352F2F2F),
                                  width: 1.0,
                                ),
                              ),
                              alignment: Alignment.center,
                              child: Padding(
                                padding: const EdgeInsets.all(3),
                                child: LabTestFigmaImage(
                                  url: partner.logoUrl,
                                  width: 20,
                                  height: 20,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              partner.name,
                              style: theme.textTheme.titleMedium?.copyWith(
                                color: selected
                                    ? const Color(0xFF0FAA9A)
                                    : const Color(0xFF4D4D4D),
                                fontWeight: selected
                                    ? FontWeight.w700
                                    : FontWeight.w500,
                                fontSize: 16.sp,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
    );
  }
}

class _LabVendorGrid extends StatelessWidget {
  const _LabVendorGrid({
    required this.vendors,
    required this.selectedIndex,
    required this.onSelect,
  });

  final List<LabTestBookingVendorOption> vendors;
  final int selectedIndex;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        const spacing = 9.0;
        const minTile = 121.33;
        final n = vendors.length;
        final rowW = constraints.maxWidth;
        final tileW = (rowW - spacing * 2) / 3;
        final w = tileW.clamp(minTile * 0.85, minTile);

        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          alignment: WrapAlignment.start,
          children: List.generate(n, (i) {
            final v = vendors[i];
            final selected = i == selectedIndex;
            return SizedBox(
              width: w,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => onSelect(i),
                  borderRadius: BorderRadius.circular(17.215),
                  child: Column(
                    children: [
                      Container(
                        width: w,
                        height: w,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(17.215),
                          border: Border.all(
                            color: selected
                                ? const Color(0xFF0FAA9A)
                                : const Color(0xFF9BA6A7),
                            width: 1.0,
                          ),
                        ),
                        alignment: Alignment.center,
                        child: _VendorLogo(vendor: v, size: w * 0.68),
                      ),
                      const SizedBox(height: 9),
                      Text(
                        v.name,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: const Color(0xFF110844),
                          fontSize: 14.sp,
                          height: 1,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }
}

class _VendorLogo extends StatelessWidget {
  const _VendorLogo({required this.vendor, required this.size});

  final LabTestBookingVendorOption vendor;
  final double size;

  @override
  Widget build(BuildContext context) {
    if (vendor.markUrl != null) {
      return SizedBox(
        width: size,
        height: size * 0.55,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              bottom: 0,
              child: LabTestFigmaImage(
                url: vendor.logoUrl,
                width: size * 0.95,
                height: size * 0.2,
              ),
            ),
            LabTestFigmaImage(
              url: vendor.markUrl!,
              width: size * 0.22,
              height: size * 0.29,
            ),
          ],
        ),
      );
    }
    return LabTestFigmaImage(
      url: vendor.logoUrl,
      width: size * 0.85,
      height: size * 0.80,
      fit: BoxFit.contain,
    );
  }
}

class _BottomCheckoutBar extends StatelessWidget {
  const _BottomCheckoutBar({
    required this.onProceed,
    required this.buttonText,
    required this.cartCount,
  });

  final VoidCallback onProceed;
  final String buttonText;
  final int cartCount;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 14, 24, 8),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.07),
            offset: const Offset(0, -5),
            blurRadius: 30,
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: double.infinity,
              height: 57,
              child: FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFF0FAA9A),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.909),
                  ),
                  textStyle: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16.sp,
                  ),
                ),
                onPressed: onProceed,
                child: Stack(
                  children: [
                    Center(child: Text(buttonText)),
                    if (buttonText == 'View Your Cart' && cartCount > 0)
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 12),
                          child: Container(
                            width: 28,
                            height: 28,
                            decoration: const BoxDecoration(
                              color: Color(0xFFF2F7F6),
                              shape: BoxShape.circle,
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              cartCount > 99 ? '99+' : '$cartCount',
                              style: Theme.of(context).textTheme.titleSmall
                                  ?.copyWith(
                                    color: const Color(0xFF0FAA9A),
                                    fontWeight: FontWeight.w700,
                                    fontSize: 14.sp,
                                    height: 1,
                                  ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: Container(
                width: 135,
                height: 5,
                decoration: BoxDecoration(
                  color: const Color(0xFFB9C0C9),
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

enum _CartChangeDialogAction { viewCart, continueChange }

class _CartChangeWarningDialog extends StatelessWidget {
  const _CartChangeWarningDialog();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 24),
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 18),
        decoration: BoxDecoration(
          color: const Color(0xFFF6FDFF),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 66,
              height: 66,
              decoration: const BoxDecoration(
                color: Color(0xFFF8DE63),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Text(
                '!',
                style: theme.textTheme.headlineMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  height: 1,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Warning!',
              style: theme.textTheme.headlineSmall?.copyWith(
                color: const Color(0xFF1E2A3A),
                fontWeight: FontWeight.w700,
                fontSize: 36.sp / 2,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Changing the City, Service Provider or\nLab will remove all items from your cart.\nDo you want to proceed?',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: const Color(0xFF2F3E54),
                fontSize: 14.sp,
                height: 1.35,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(
                      context,
                    ).pop(_CartChangeDialogAction.viewCart),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF2F3E54),
                      side: const BorderSide(color: Color(0xFF9FB8BF), width: 1),
                      minimumSize: const Size.fromHeight(50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      textStyle: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16.sp,
                      ),
                    ),
                    child: const Text('View Cart'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: FilledButton(
                    onPressed: () => Navigator.of(
                      context,
                    ).pop(_CartChangeDialogAction.continueChange),
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFF0FAA9A),
                      foregroundColor: Colors.white,
                      minimumSize: const Size.fromHeight(50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      textStyle: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16.sp,
                      ),
                    ),
                    child: const Text('Continue'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
