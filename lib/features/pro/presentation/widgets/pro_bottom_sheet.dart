import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/enums/state_status.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/widgets/app_button_widget.dart';
import '../../domain/entities/pro_catalog_entity.dart';
import '../cubit/pro_cubit.dart';
import '../cubit/pro_state.dart';
import 'pro_active_member_content.dart';
import 'pro_benefits_table_widget.dart';
import 'pro_cancel_subscription_dialog.dart';
import 'pro_plan_cards_widget.dart';
import 'pro_sheet_header_widget.dart';

class ProBottomSheet extends StatelessWidget {
  const ProBottomSheet({
    super.key,
    this.onSubscribe,
  });

  /// Called with selected [planId] when CTA is tapped (non-Pro only).
  final ValueChanged<String>? onSubscribe;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProCubit, ProState>(
      builder: (context, state) {
        final media = MediaQuery.of(context);
        // [useSafeArea: true] already clears the top inset; fill remaining height.
        final maxHeight = media.size.height;
        return SafeArea(
          top: false,
          bottom: false,
          child: ConstrainedBox(
            constraints: BoxConstraints(maxHeight: maxHeight),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.clrWhite,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
              ),
              clipBehavior: Clip.antiAlias,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 10.h),
                  Container(
                    width: 46.w,
                    height: 5.h,
                    decoration: BoxDecoration(
                      color: AppColors.clrDDE1E5,
                      borderRadius: BorderRadius.circular(99.r),
                    ),
                  ),
                  Flexible(child: _body(context, state)),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _body(BuildContext context, ProState state) {
    final status = state.loadingStateStatus;
    if (status == StateStatus.loading || status == StateStatus.idle) {
      return const _ProSheetLoading();
    }
    if (status == StateStatus.error || state.catalog == null) {
      return _ProSheetError(
        message: state.errorMessage,
        onRetry: () => context.read<ProCubit>().loadCatalog(),
      );
    }

    final catalog = state.catalog!;
    if (catalog.membership.isActivePro) {
      return ProActiveMemberContent(
        catalog: catalog,
        onCancelSubscription: () => _onCancelSubscription(context),
      );
    }

    return _ProSubscribeContent(
      catalog: catalog,
      selectedPlanId: state.selectedPlanId,
      onPlanSelected: context.read<ProCubit>().selectPlan,
      onSubscribe: () {
        final planId = state.selectedPlanId;
        if (planId == null || planId.isEmpty) return;
        onSubscribe?.call(planId);
      },
    );
  }

  Future<void> _onCancelSubscription(BuildContext context) async {
    final confirmed = await showProCancelSubscriptionDialog(context);
    if (!confirmed || !context.mounted) return;
    // Unsubscribe API will be wired next; close sheet after confirm for now.
    context.pop();
  }
}

class _ProSubscribeContent extends StatelessWidget {
  const _ProSubscribeContent({
    required this.catalog,
    required this.selectedPlanId,
    required this.onPlanSelected,
    required this.onSubscribe,
  });

  final ProCatalogEntity catalog;
  final String? selectedPlanId;
  final ValueChanged<String> onPlanSelected;
  final VoidCallback onSubscribe;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                ProSheetHeaderWidget(
                  logoUrl: catalog.logoUrl,
                  bannerUrl: catalog.bannerUrl,
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 12.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(height: 16.h),
                      Text(
                        catalog.title,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          color: AppColors.clr111827,
                          fontWeight: FontWeight.w800,
                          fontSize: 22.sp,
                        ),
                      ),
                      SizedBox(height: 6.h),
                      Text(
                        catalog.tagline,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          color: AppColors.clr6B7280,
                          fontWeight: FontWeight.w400,
                          fontSize: 13.sp,
                          height: 1.35,
                        ),
                      ),
                      SizedBox(height: 16.h),
                      Divider(height: 1.h, color: AppColors.clrE3E8EE),
                      ProBenefitsTableWidget(
                        benefitsTitle: catalog.benefitsTitle,
                        basicColumnLabel: catalog.basicColumnLabel,
                        proColumnLabel: catalog.proColumnLabel,
                        benefits: catalog.benefits,
                      ),
                      SizedBox(height: 16.h),
                      ProPlanCardsWidget(
                        sectionTitle: catalog.planSectionTitle,
                        plans: catalog.plans,
                        selectedPlanId: selectedPlanId,
                        onPlanSelected: onPlanSelected,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(
            20.w,
            8.h,
            20.w,
            16.h + MediaQuery.paddingOf(context).bottom,
          ),
          child: AppButtonWidget(
            title: catalog.ctaLabel,
            bgClr: AppColors.clr1FAFA3,
            onTap: onSubscribe,
          ),
        ),
      ],
    );
  }
}

class _ProSheetLoading extends StatelessWidget {
  const _ProSheetLoading();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 80.h),
      child: const Center(
        child: CircularProgressIndicator(color: AppColors.clr1FAFA3),
      ),
    );
  }
}

class _ProSheetError extends StatelessWidget {
  const _ProSheetError({
    required this.message,
    required this.onRetry,
  });

  final String? message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: EdgeInsets.fromLTRB(24.w, 48.h, 24.w, 48.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            message?.trim().isNotEmpty == true
                ? message!.trim()
                : l10n.proCatalogLoadError,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.clr6B7280,
              fontSize: 14.sp,
            ),
          ),
          SizedBox(height: 16.h),
          TextButton(
            onPressed: onRetry,
            child: Text(
              l10n.proRetry,
              style: const TextStyle(
                color: AppColors.clr1FAFA3,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
