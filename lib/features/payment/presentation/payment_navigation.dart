import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/app_localizations.dart';
import '../../../core/router/app_routes.dart';
import '../domain/entities/payment_initiation_result.dart';
import '../domain/entities/payment_webview_result.dart';
import 'payment_webview_args.dart';
import 'widgets/payment_outcome_dialog_widget.dart';

/// Opens the card payment WebView and returns the gateway result.
Future<PaymentWebViewResult?>    openCardPaymentWebView(
  BuildContext context, {
  required String paymentUrl,
  String? title,
  bool allowClose = false,
}) {
  final url = paymentUrl.trim();
  if (url.isEmpty) {
    return Future.value(
      PaymentWebViewResult.failed(message: 'Missing payment URL'),
    );
  }

  return context.pushNamed<PaymentWebViewResult>(
    AppRoutes.cardPayment,
    extra: PaymentWebViewArgs(
      paymentUrl: url,
      title: title,
      allowClose: allowClose,
    ),
  );
}

/// Opens WebView when [initiation] has a payment URL.
/// Without a URL, returns success (booking already complete).
Future<PaymentWebViewResult> settleCardPaymentIfNeeded(
  BuildContext context,
  PaymentInitiationResult initiation, {
  String? title,
  bool allowClose = false,
}) async {
  if (!initiation.requiresCardPayment) {
    return PaymentWebViewResult.success();
  }

  final result = await openCardPaymentWebView(
    context,
    paymentUrl: initiation.paymentUrl!,
    title: title,
    allowClose: allowClose,
  );
  return result ?? PaymentWebViewResult.cancelled();
}

Future<void> showCardPaymentOutcomeDialog(
  BuildContext context,
  PaymentWebViewResult result,
) {
  if (result.isSuccess) return Future.value();

  final l10n = AppLocalizations.of(context)!;
  final isCancelled = result.status == PaymentWebViewStatus.cancelled;
  final title = isCancelled
      ? l10n.paymentWebViewCancelledTitle
      : l10n.paymentWebViewFailedTitle;
  final gatewayMessage = result.message?.trim();
  final message = (gatewayMessage != null && gatewayMessage.isNotEmpty)
      ? gatewayMessage
      : (isCancelled
          ? l10n.paymentWebViewCancelledMessage
          : l10n.paymentWebViewFailed);

  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    useRootNavigator: true,
    builder: (_) {
      return PaymentOutcomeDialogWidget(
        title: title,
        message: message,
        ctaText: l10n.commonClose,
        isCancelled: isCancelled,
      );
    },
  );
}
