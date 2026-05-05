// Booking UI composes widgets; cart + selection rules live in LabTestBookingCubit.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/widgets/app_scaffold_gradient.dart';
import '../cubit/lab_test_booking_cubit.dart';
import '../cubit/lab_test_booking_state.dart';
import '../widgets/lab_test_booking_bottom_bar_widget.dart';
import '../widgets/lab_test_booking_city_box_widget.dart';
import '../widgets/lab_test_booking_method_tile_widget.dart';
import '../widgets/lab_test_booking_partner_tabs_widget.dart';
import '../widgets/lab_test_booking_test_summary_card_widget.dart';
import '../widgets/lab_test_booking_vendor_grid_widget.dart';
import '../widgets/lab_test_browse_header_widget.dart';
import '../widgets/lab_test_cart_change_warning_dialog_widget.dart';
import '../../../../generated/assets.dart';

class LabTestBookingScreen extends StatefulWidget {
  const LabTestBookingScreen({super.key});

  @override
  State<LabTestBookingScreen> createState() => _LabTestBookingScreenState();
}

class _LabTestBookingScreenState extends State<LabTestBookingScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<LabTestBookingCubit>().hydrate();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return AppScaffoldGradient(
      child: Column(
        children: [
          BlocSelector<LabTestBookingCubit, LabTestBookingState, int>(
            selector: (s) => s.cartItems.length,
            builder: (context, cartCount) {
              return LabTestBrowseHeaderWidget(
                padding: EdgeInsets.fromLTRB(8.w, 4.h, 16.w, 18.h),
                title: l10n.labTestScreenTitle,
                cartCount: cartCount,
                cartBadgeOverflowLabel: l10n.labTestCartBadgeOverflow,
                onCartTap: cartCount > 0
                    ? () async {
                        await context.pushNamed(AppRoutes.labTestCart);
                        if (context.mounted) {
                          await context.read<LabTestBookingCubit>().hydrate();
                        }
                      }
                    : null,
              );
            },
          ),
          Expanded(
            child: Center(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(42.r),
                  ),
                ),
                child: BlocBuilder<LabTestBookingCubit, LabTestBookingState>(
                  builder: (context, state) {
                    final partners = state.args.partners;
                    final vendors = state.args.vendors;
                    final partnerIndex = partners.isEmpty
                        ? 0
                        : state.partnerTab.clamp(0, partners.length - 1);
                    final vendorIndex = vendors.isEmpty
                        ? 0
                        : state.selectedVendorIndex.clamp(
                            0,
                            vendors.length - 1,
                          );

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            padding: EdgeInsets.fromLTRB(24.w, 29.h, 24.w, 24.h),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                LabTestBookingCityBoxWidget(
                                  city: state.args.city,
                                  cityLabel: l10n.labTestCityFieldLabel,
                                ),
                                SizedBox(height: 16.h),
                                Text(
                                  l10n.labTestBookingChooseMethodTitle,
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    color: const Color(0xFF061E40),
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16.sp,
                                  ),
                                ),
                                SizedBox(height: 12.h),
                                Row(
                                  children: [
                                    Expanded(
                                      child: LabTestBookingMethodTileWidget(
                                        title: l10n.labTestBookingMethodWalkIn,
                                        iconUrl: Assets.labTestWalkin,
                                        selected: state.labVisit,
                                        onTap: state.labVisit
                                            ? () {}
                                            : () => _guardAndApply(
                                                  context,
                                                  (c) async =>
                                                      c.setLabVisit(true),
                                                ),
                                      ),
                                    ),
                                    SizedBox(width: 12.w),
                                    Expanded(
                                      child: LabTestBookingMethodTileWidget(
                                        title:
                                            l10n.labTestBookingMethodHomeSample,
                                        iconUrl: Assets.labTestHomeSample,
                                        selected: !state.labVisit,
                                        onTap: !state.labVisit
                                            ? () {}
                                            : () => _guardAndApply(
                                                  context,
                                                  (c) async =>
                                                      c.setLabVisit(false),
                                                ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 16.h),
                                LabTestBookingTestSummaryCardWidget(
                                  title: state.args.testTitle,
                                  labName: state.selectedVendor?.name ?? '',
                                  requirement: state.args.requirementLabel,
                                  sampleType: state.args.sampleType,
                                  discountedFee: state.args.discountedFee,
                                  originalFee: state.args.originalFee,
                                  requirementLabel: l10n.labTestRequirementLabel,
                                  sampleTypeLabel: l10n.labTestSampleTypeLabel,
                                ),
                                SizedBox(height: 16.h),
                                LabTestBookingPartnerTabsWidget(
                                  partners: partners,
                                  selectedIndex: partnerIndex,
                                  onChanged: (i) {
                                    if (i == state.partnerTab) return;
                                    _guardAndApply(
                                      context,
                                      (c) async => c.setPartnerTab(i),
                                    );
                                  },
                                ),
                                SizedBox(height: 12.h),
                                LabTestBookingVendorGridWidget(
                                  vendors: vendors,
                                  selectedIndex: vendorIndex,
                                  onSelect: (i) {
                                    if (i == state.selectedVendorIndex) {
                                      return;
                                    }
                                    _guardAndApply(
                                      context,
                                      (c) async => c.setVendorIndex(i),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                        LabTestBookingBottomBarWidget(
                          buttonLabel: state.isCurrentSelectionInCart
                              ? l10n.labTestBookingViewYourCart
                              : l10n.labTestBookingAddToCart,
                          onPressed: () => _onBottomCta(context, state),
                          showLeadingCartCount:
                              state.isCurrentSelectionInCart,
                          cartCount: state.cartItems.length,
                          cartCountOverflowLabel:
                              l10n.labTestCartBadgeOverflow99,
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _guardAndApply(
    BuildContext context,
    Future<void> Function(LabTestBookingCubit cubit) apply,
  ) async {
    final cubit = context.read<LabTestBookingCubit>();
    if (cubit.state.cartItems.isEmpty) {
      await apply(cubit);
      return;
    }
    final l10n = AppLocalizations.of(context)!;
    final action = await showDialog<LabTestCartChangeDialogAction>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => LabTestCartChangeWarningDialogWidget(
        title: l10n.labTestCartChangeWarningTitle,
        body: l10n.labTestCartChangeWarningBody,
        viewCartLabel: l10n.labTestCartChangeViewCart,
        continueLabel: l10n.labTestCartChangeContinue,
      ),
    );
    if (!context.mounted || action == null) return;
    if (action == LabTestCartChangeDialogAction.viewCart) {
      await context.pushNamed(AppRoutes.labTestCart);
      if (context.mounted) await cubit.hydrate();
      return;
    }
    await cubit.clearCart();
    if (!context.mounted) return;
    await apply(cubit);
  }

  Future<void> _onBottomCta(
    BuildContext context,
    LabTestBookingState state,
  ) async {
    final l10n = AppLocalizations.of(context)!;
    final cubit = context.read<LabTestBookingCubit>();
    if (state.selectedVendor == null || state.selectedPartner == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.labTestBookingDataUnavailable)),
      );
      return;
    }
    if (state.isCurrentSelectionInCart) {
      await context.pushNamed(AppRoutes.labTestCart);
      if (context.mounted) await cubit.hydrate();
      return;
    }
    await cubit.addCurrentSelectionToCart();
  }
}
