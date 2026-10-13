import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/enums/state_status.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/utils/auth_guard.dart';
import '../../../../core/widgets/app_button_widget.dart';
import '../../../lab_test/presentation/cubit/lab_test_cart_cubit.dart';
import '../../../consultation/presentation/models/doctor_consultation_jazzcash_sheet_result.dart';
import '../../../consultation/presentation/widgets/doctor_consultation_jazzcash_accounts_sheet_widget.dart';
import '../../../payment/domain/entities/payment_webview_result.dart';
import '../../../payment/presentation/widgets/payment_outcome_dialog_widget.dart';
import 'pro_subscribe_success_dialog.dart';
import '../pro_user_webview_navigation.dart';
import '../../domain/entities/pro_catalog_entity.dart';
import '../cubit/pro_cubit.dart';
import '../cubit/pro_state.dart';
import 'pro_active_member_content.dart';
import 'pro_benefits_table_widget.dart';
import 'pro_cancel_subscription_dialog.dart';
import 'pro_plan_cards_widget.dart';
import 'pro_sheet_header_widget.dart';
import 'pro_sheet_shimmer_widget.dart';

class ProBottomSheet extends StatelessWidget {
  const ProBottomSheet({
    super.key,
    this.onSubscribe,
  });

  /// Called with selected [planId] when subscribe succeeds.
  /// [suppressSuccessDialog] skips the dialog shown after this sheet closes.
  final void Function(String planId, {bool suppressSuccessDialog})? onSubscribe;

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
      return const ProSheetShimmerWidget();
    }
    if (status == StateStatus.error || state.catalog == null) {
      return _ProSheetError(
        message: state.errorMessage,
        onRetry: () => context.read<ProCubit>().loadCatalog(),
      );
    }

    final catalog = state.catalog!;
    if (catalog.membership.isActivePro) {
      final isCancelling =
          state.subscribeStateStatus == StateStatus.loading;
      return Stack(
        children: [
          AbsorbPointer(
            absorbing: isCancelling,
            child: ProActiveMemberContent(
              catalog: catalog,
              onCancelSubscription: () => _onCancelSubscription(context),
            ),
          ),
          if (isCancelling)
            const Center(child: CircularProgressIndicator()),
        ],
      );
    }

    return _ProSubscribeContent(
      catalog: catalog,
      selectedPlanId: state.selectedPlanId,
      onPlanSelected: context.read<ProCubit>().selectPlan,
      onSubscribe: () => _submitSubscribe(context),
    );
  }

  Future<void> _submitSubscribe(BuildContext context) async {
    if (!context.requireLogin()) return;
    final cubit = context.read<ProCubit>();
    final planId = cubit.state.selectedPlanId;
    if (planId == null || planId.isEmpty) return;

    final msisdn = await _pickJazzCashNumber(context);
    if (!context.mounted || msisdn == null || msisdn.isEmpty) return;

    final subscription = await cubit.subscribe(msisdn: msisdn);
    if (!context.mounted) return;
    if (subscription == null) {
      _showSubscribeMessage(context, cubit.state.subscribeErrorMessage);
      return;
    }

    if (subscription.opensJazzCash) {
      final l10n = AppLocalizations.of(context)!;
      final payment = await openProUserWebView(
        context,
        url: subscription.link!,
        title: l10n.accountMethodJazzCash,
      );
      if (!context.mounted) return;
      final result = payment ?? PaymentWebViewResult.cancelled();
      final destination = await _showWebViewOutcomeDialog(context, result);
      if (!context.mounted || !result.isSuccess) return;
      await LabTestCartCubit.clearAfterProMembershipChange();
      if (!context.mounted) return;
      final router = GoRouter.of(context);
      onSubscribe?.call(planId, suppressSuccessDialog: true);
      if (destination != null) router.push(destination);
      return;
    }

    await LabTestCartCubit.clearAfterProMembershipChange();
    onSubscribe?.call(planId);
  }

  Future<String?> _showWebViewOutcomeDialog(
    BuildContext context,
    PaymentWebViewResult result,
  ) async {
    if (!context.mounted) return null;
    final l10n = AppLocalizations.of(context)!;
    if (result.isSuccess) {
      final gatewayMessage = result.message?.trim();
      return showProSubscribeSuccessDialog(
        context,
        message: (gatewayMessage != null && gatewayMessage.isNotEmpty)
            ? gatewayMessage
            : null,
      );
    }

    final gatewayMessage = result.message?.trim();
    final title = switch (result.status) {
      PaymentWebViewStatus.pending => l10n.proPaymentPending,
      PaymentWebViewStatus.cancelled => l10n.paymentWebViewCancelledTitle,
      _ => l10n.paymentWebViewFailedTitle,
    };
    final message = (gatewayMessage != null && gatewayMessage.isNotEmpty)
        ? gatewayMessage
        : switch (result.status) {
            PaymentWebViewStatus.pending => l10n.proPaymentPending,
            PaymentWebViewStatus.cancelled =>
              l10n.paymentWebViewCancelledMessage,
            _ => l10n.paymentWebViewFailed,
          };
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return PaymentOutcomeDialogWidget(
          title: title,
          message: message,
          ctaText: l10n.commonOk,
          isCancelled: result.status != PaymentWebViewStatus.failed,
          onCta: () => dialogContext.pop(),
        );
      },
    );
    return null;
  }

  Future<String?> _pickJazzCashNumber(BuildContext context) async {
    final result =
        await showModalBottomSheet<DoctorConsultationJazzCashSheetResult>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const DoctorConsultationJazzCashAccountsSheetWidget(),
    );
    return result?.msisdn.trim();
  }

  void _showSubscribeMessage(BuildContext context, String? message) {
    final text = message?.trim();
    if (!context.mounted || text == null || text.isEmpty) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  Future<void> _onCancelSubscription(BuildContext context) async {
    final confirmed = await showProCancelSubscriptionDialog(context);
    if (!confirmed || !context.mounted) return;
    final cubit = context.read<ProCubit>();
    final cancellation = await cubit.unsubscribe();
    if (!context.mounted) return;
    if (cancellation == null) {
      if (cubit.state.subscribeStateStatus == StateStatus.loading) return;
      _showSubscribeMessage(context, cubit.state.subscribeErrorMessage);
      return;
    }

    await LabTestCartCubit.clearAfterProMembershipChange();
    if (!context.mounted) return;
    final l10n = AppLocalizations.of(context)!;
    final apiMessage = cancellation.message.trim();
    final text = apiMessage.isNotEmpty
        ? apiMessage
        : l10n.proCancelSubscriptionSuccess;
    final messenger = ScaffoldMessenger.maybeOf(context);
    context.pop();
    messenger?.showSnackBar(SnackBar(content: Text(text)));
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
          child: BlocSelector<ProCubit, ProState, bool>(
            selector: (state) =>
                state.subscribeStateStatus == StateStatus.loading,
            builder: (context, isSubmitting) {
              return AppButtonWidget(
                title: catalog.ctaLabel,
                bgClr: AppColors.clr1FAFA3,
                onTap: isSubmitting ? null : onSubscribe,
              );
            },
          ),
        ),
      ],
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
