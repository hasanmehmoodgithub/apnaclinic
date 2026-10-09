import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_routes.dart';
import '../../payment/domain/entities/payment_webview_result.dart';
import 'pro_user_webview_args.dart';

/// Opens the Pro subscribe JazzCash page. Card checkout keeps using
/// [AppRoutes.cardPayment].
Future<PaymentWebViewResult?> openProUserWebView(
  BuildContext context, {
  required String url,
  String? title,
}) {
  final link = url.trim();
  if (link.isEmpty) {
    return Future.value(
      PaymentWebViewResult.failed(message: 'Missing payment URL'),
    );
  }

  return context.pushNamed<PaymentWebViewResult>(
    AppRoutes.proUserWebView,
    extra: ProUserWebViewArgs(url: link, title: title),
  );
}
