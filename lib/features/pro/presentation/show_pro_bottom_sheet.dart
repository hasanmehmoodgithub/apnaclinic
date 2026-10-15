import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/di/dependency_injection.dart';
import '../../../core/session/auth_session_refresh.dart';
import '../../../core/extensions/screen_util_extensions.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../consultation/presentation/models/doctor_consultation_jazzcash_sheet_result.dart';
import '../../consultation/presentation/widgets/doctor_consultation_jazzcash_accounts_sheet_widget.dart';
import '../../lab_test/presentation/cubit/lab_test_cart_cubit.dart';
import '../../payment/domain/entities/payment_webview_result.dart';
import '../../payment/presentation/widgets/payment_outcome_dialog_widget.dart';
import '../domain/entities/pro_plan_entity.dart';
import 'cubit/pro_cubit.dart';
import 'pro_user_webview_navigation.dart';
import 'widgets/pro_bottom_sheet.dart';
import 'widgets/pro_subscribe_success_dialog.dart';
import 'widgets/pro_unsubscribe_success_dialog.dart';

/// Result returned when the user taps the Pro CTA.
class ProSheetResult {
  const ProSheetResult({
    required this.planId,
    required this.plan,
    this.suppressSuccessDialog = false,
    this.continueCheckout = false,
    this.subscriptionCancelled = false,
  });

  final String planId;
  final ProPlanEntity? plan;

  /// True when the WebView flow already showed the success dialog.
  final bool suppressSuccessDialog;

  /// True when the sheet closed so the JazzCash numbers sheet can open.
  final bool continueCheckout;

  /// True when unsubscribe succeeded and the cancel dialog should show.
  final bool subscriptionCancelled;
}

/// Opens the ApnaClinic Pro catalog bottom sheet (content from API).
///
/// When [showSuccessDialog] is true (default), the subscribe-success dialog
/// is shown after the sheet closes with a selected plan.
Future<ProSheetResult?> showApnaClinicProSheet(
  BuildContext context, {
  bool showSuccessDialog = true,
  bool showServiceActions = false,
}) async {
  final cubit = sl<ProCubit>()..loadCatalog();
  try {
    final result = await showModalBottomSheet<ProSheetResult>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      builder: (sheetContext) {
        return BlocProvider.value(
          value: cubit,
          child: Builder(
            builder: (providerContext) {
              return ProBottomSheet(
                onSubscribe: (planId, {bool suppressSuccessDialog = false}) {
                  final catalog = providerContext
                      .read<ProCubit>()
                      .state
                      .catalog;
                  ProPlanEntity? plan;
                  if (catalog != null) {
                    for (final item in catalog.plans) {
                      if (item.planId == planId) {
                        plan = item;
                        break;
                      }
                    }
                  }
                  sheetContext.pop(
                    ProSheetResult(
                      planId: planId,
                      plan: plan,
                      suppressSuccessDialog: suppressSuccessDialog,
                      continueCheckout: true,
                    ),
                  );
                },
                onUnsubscribed: () {
                  sheetContext.pop(
                    const ProSheetResult(
                      planId: '',
                      plan: null,
                      subscriptionCancelled: true,
                    ),
                  );
                },
              );
            },
          ),
        );
      },
    );

    if (result != null &&
        result.subscriptionCancelled &&
        context.mounted) {
      await showProUnsubscribeSuccessDialog(context);
    } else if (result != null &&
        result.continueCheckout &&
        context.mounted) {
      await _continueProCheckout(
        context,
        cubit,
        showServiceActions: showServiceActions,
      );
    } else if (showSuccessDialog &&
        result != null &&
        !result.suppressSuccessDialog &&
        context.mounted) {
      final destination = await showProSubscribeSuccessDialog(
        context,
        showServiceActions: showServiceActions,
      );
      if (destination != null && context.mounted) {
        context.push(destination);
      }
    }

    return result;
  } finally {
    await cubit.close();
  }
}

Future<void> _continueProCheckout(
  BuildContext context,
  ProCubit cubit, {
  required bool showServiceActions,
}) async {
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
    final destination = await _showWebViewOutcomeDialog(
      context,
      result,
      showServiceActions: showServiceActions,
    );
    if (!context.mounted || !result.isSuccess) return;
    await LabTestCartCubit.clearAfterProMembershipChange();
    if (!context.mounted) return;
    sl<AuthSessionRefresh>().notifyProMembershipChanged(isActive: true);
    if (destination != null) context.push(destination);
    return;
  }

  await LabTestCartCubit.clearAfterProMembershipChange();
  if (!context.mounted) return;
  sl<AuthSessionRefresh>().notifyProMembershipChanged(isActive: true);
  if (!context.mounted) return;
  final destination = await showProSubscribeSuccessDialog(
    context,
    showServiceActions: showServiceActions,
  );
  if (destination != null && context.mounted) {
    context.push(destination);
  }
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

Future<String?> _showWebViewOutcomeDialog(
  BuildContext context,
  PaymentWebViewResult result, {
  required bool showServiceActions,
}) async {
  if (!context.mounted) return null;
  final l10n = AppLocalizations.of(context)!;
  if (result.isSuccess) {
    return showProSubscribeSuccessDialog(
      context,
      showServiceActions: showServiceActions,
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
          PaymentWebViewStatus.cancelled => l10n.paymentWebViewCancelledMessage,
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

void _showSubscribeMessage(BuildContext context, String? message) {
  final text = message?.trim();
  if (!context.mounted || text == null || text.isEmpty) return;
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
}
