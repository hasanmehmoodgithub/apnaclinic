import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/app_localizations.dart';
import '../../../core/router/app_routes.dart';
import '../domain/entities/payment_initiation_result.dart';
import '../domain/entities/payment_webview_result.dart';
import 'payment_webview_args.dart';

/// Opens the card payment WebView and returns the gateway result.
Future<PaymentWebViewResult?> openCardPaymentWebView(
  BuildContext context, {
  required String paymentUrl,
  String? title,
}) {
  final url = paymentUrl.trim();
  if (url.isEmpty) {
    return Future.value(
      PaymentWebViewResult.failed(message: 'Missing payment URL'),
    );
  }

  return context.pushNamed<PaymentWebViewResult>(
    AppRoutes.cardPayment,
    extra: PaymentWebViewArgs(paymentUrl: url, title: title),
  );
}

/// Opens WebView when [initiation] has a payment URL.
/// Without a URL, returns success (booking already complete).
Future<PaymentWebViewResult> settleCardPaymentIfNeeded(
  BuildContext context,
  PaymentInitiationResult initiation, {
  String? title,
}) async {
  if (!initiation.requiresCardPayment) {
    return PaymentWebViewResult.success();
  }

  final result = await openCardPaymentWebView(
    context,
    paymentUrl: initiation.paymentUrl!,
    title: title,
  );
  return result ?? PaymentWebViewResult.cancelled();
}

void showCardPaymentOutcomeSnackBar(
  BuildContext context,
  PaymentWebViewResult result,
) {
  if (result.isSuccess) return;

  final l10n = AppLocalizations.of(context)!;
  final message = switch (result.status) {
    PaymentWebViewStatus.failed =>
      (result.message?.trim().isNotEmpty == true)
          ? result.message!.trim()
          : l10n.paymentWebViewFailed,
    PaymentWebViewStatus.cancelled =>
      (result.message?.trim().isNotEmpty == true)
          ? result.message!.trim()
          : l10n.paymentWebViewCancelled,
    PaymentWebViewStatus.success => null,
  };
  if (message == null) return;

  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(message)));
}
