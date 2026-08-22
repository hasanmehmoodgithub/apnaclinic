import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../domain/entities/payment_webview_result.dart';
import '../payment_webview_args.dart';

/// In-app card payment WebView.
///
/// Rox callback posts via `window.AndroidInterface.postMessage(...)` from
/// `handleSuccess()` / "Return to ROX App". Channel name must stay
/// `AndroidInterface` to match the gateway HTML.
class PaymentWebViewScreen extends StatefulWidget {
  const PaymentWebViewScreen({
    super.key,
    required this.args,
  });

  final PaymentWebViewArgs args;

  static const String bridgeChannelName = 'AndroidInterface';

  static const String successCallbackPath =
      '/api/subscription/v1/jazzcash/callback';

  @override
  State<PaymentWebViewScreen> createState() => _PaymentWebViewScreenState();
}

class _PaymentWebViewScreenState extends State<PaymentWebViewScreen> {
  late final WebViewController _controller;
  var _isLoading = true;
  var _hasError = false;
  var _didComplete = false;

  @override
  void initState() {
    super.initState();
    final paymentUrl = widget.args.paymentUrl.trim();
    log('PaymentWebView loading: $paymentUrl');

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(AppColors.clrWhite)
      ..addJavaScriptChannel(
        PaymentWebViewScreen.bridgeChannelName,
        onMessageReceived: (message) {
          log('PaymentWebView bridge: ${message.message}');
          _handleBridgeMessage(message.message);
        },
      )
      ..setNavigationDelegate(
        NavigationDelegate(
          // Staging payment hosts often use corp/self-signed certs. Dio already
          // trust-alls via AppHttpOverrides; WebView does not unless we proceed.
          onSslAuthError: (error) {
            log('PaymentWebView SSL: ${error.platform.description} — proceeding');
            error.proceed();
          },
          onPageStarted: (url) {
            log('PaymentWebView started: $url');
            if (!mounted) return;
            setState(() {
              _isLoading = true;
              _hasError = false;
            });
          },
          onPageFinished: (url) async {
            log('PaymentWebView finished: $url');
            if (!mounted) return;
            setState(() => _isLoading = false);
            if (_isSuccessCallbackUrl(url)) {
              await _tryAutoCompleteSuccessFromCallbackPage();
            }
          },
          onWebResourceError: (error) {
            log(
              'PaymentWebView error: code=${error.errorCode} '
              'type=${error.errorType} mainFrame=${error.isForMainFrame} '
              'desc=${error.description}',
            );
            if (!mounted || _didComplete) return;
            // Ignore asset/iframe noise; only fail the main document.
            if (error.isForMainFrame == false) return;
            setState(() {
              _isLoading = false;
              _hasError = true;
            });
          },
          onNavigationRequest: (request) {
            if (kDebugMode) {
              log('PaymentWebView nav: ${request.url}');
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(paymentUrl));
  }

  bool _isSuccessCallbackUrl(String url) {
    return url.contains(PaymentWebViewScreen.successCallbackPath);
  }

  Future<void> _tryAutoCompleteSuccessFromCallbackPage() async {
    if (_didComplete) return;

    try {
      await _controller.runJavaScript('''
(function() {
  try {
    if (typeof handleSuccess === 'function') {
      handleSuccess();
      return;
    }
    if (window.AndroidInterface && typeof window.AndroidInterface.postMessage === 'function') {
      window.AndroidInterface.postMessage(JSON.stringify({
        status: "success",
        success: true,
        message: "Payment successful",
        statusCode: 200
      }));
    }
  } catch (e) {}
})();
''');
    } catch (_) {}

    // Fallback if bridge never fires.
    await Future<void>.delayed(const Duration(milliseconds: 800));
    if (!mounted || _didComplete) return;
    _complete(PaymentWebViewResult.success(message: 'Payment successful'));
  }

  void _handleBridgeMessage(String raw) {
    final parsed = _parseBridgePayload(raw);
    if (parsed == null) return;
    _complete(parsed);
  }

  PaymentWebViewResult? _parseBridgePayload(String raw) {
    final text = raw.trim();
    if (text.isEmpty) return null;

    final lower = text.toLowerCase();
    if (lower == 'success' || lower == 'true') {
      return PaymentWebViewResult.success();
    }
    if (lower == 'fail' ||
        lower == 'failed' ||
        lower == 'failure' ||
        lower == 'error') {
      return PaymentWebViewResult.failed();
    }
    if (lower == 'cancel' || lower == 'cancelled' || lower == 'canceled') {
      return PaymentWebViewResult.cancelled();
    }

    try {
      final decoded = jsonDecode(text);
      if (decoded is! Map) return null;
      final map = Map<String, dynamic>.from(decoded);
      final status = (map['status'] ?? '').toString().trim().toLowerCase();
      final successFlag = map['success'] == true;
      final message = map['message']?.toString();

      if (successFlag || status == 'success') {
        return PaymentWebViewResult.success(message: message);
      }
      if (status == 'cancelled' ||
          status == 'canceled' ||
          status == 'cancel') {
        return PaymentWebViewResult.cancelled(message: message);
      }
      if (status == 'failed' ||
          status == 'fail' ||
          status == 'failure' ||
          status == 'error' ||
          map['success'] == false) {
        return PaymentWebViewResult.failed(message: message);
      }
    } catch (_) {
      return null;
    }
    return null;
  }

  void _complete(PaymentWebViewResult result) {
    if (_didComplete) return;
    _didComplete = true;
    if (!mounted) return;
    context.pop(result);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final title = widget.args.title?.trim().isNotEmpty == true
        ? widget.args.title!.trim()
        : l10n.paymentWebViewTitle;

    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: AppColors.clrWhite,
        appBar: AppBar(
          backgroundColor: AppColors.clrWhite,
          elevation: 0,
          automaticallyImplyLeading: false,
          leading: widget.args.allowClose
              ? IconButton(
                  onPressed: () {
                    if (_didComplete) return;
                    _complete(PaymentWebViewResult.cancelled());
                  },
                  icon: Icon(
                    Icons.close_rounded,
                    color: AppColors.clr060,
                    size: 24.r,
                  ),
                )
              : null,
          title: Text(
            title,
            style: TextStyle(
              color: AppColors.clr060,
              fontWeight: FontWeight.w700,
              fontSize: 18.sp,
            ),
          ),
        ),
        body: Stack(
          children: [
            WebViewWidget(controller: _controller),
            if (_isLoading)
              const Center(
                child: CircularProgressIndicator(color: AppColors.clr0FAA9A),
              ),
            if (_hasError)
              Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        l10n.paymentWebViewLoadError,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.clr6C7C92,
                          fontSize: 15.sp,
                        ),
                      ),
                      SizedBox(height: 16.h),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _isLoading = true;
                            _hasError = false;
                          });
                          _controller.loadRequest(
                            Uri.parse(widget.args.paymentUrl.trim()),
                          );
                        },
                        child: Text(l10n.commonRetry),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
