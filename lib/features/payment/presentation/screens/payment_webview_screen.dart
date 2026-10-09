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
/// `handleSuccess()` / `handleFailure()` / "Return to ROX App". Channel name
/// must stay `AndroidInterface` to match the gateway HTML.
class PaymentWebViewScreen extends StatefulWidget {
  const PaymentWebViewScreen({
    super.key,
    required this.args,
  });

  final PaymentWebViewArgs args;

  static const String bridgeChannelName = 'AndroidInterface';

  /// Same path is used for success **and** fail/cancel callback HTML.
  static const String gatewayCallbackPath =
      '/api/subscription/v1/jazzcash/callback';

  @override
  State<PaymentWebViewScreen> createState() => _PaymentWebViewScreenState();
}

class _PaymentWebViewScreenState extends State<PaymentWebViewScreen> {
  late final WebViewController _controller;
  var _isLoading = true;
  var _hasError = false;
  var _didComplete = false;
  String? _lastGatewayMessage;

  @override
  void initState() {
    super.initState();
    final paymentUrl = widget.args.paymentUrl.trim();
    log('PaymentWebView loading: $paymentUrl');

    _jsDevLog(
      'channel registered: ${PaymentWebViewScreen.bridgeChannelName}',
    );

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(AppColors.clrWhite)
      ..addJavaScriptChannel(
        PaymentWebViewScreen.bridgeChannelName,
        onMessageReceived: (message) {
          _jsDevLog('message received: ${message.message}');
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
            if (_isGatewayCallbackUrl(url)) {
              await _tryCompleteFromCallbackPage();
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

  bool _isGatewayCallbackUrl(String url) {
    return url.contains(PaymentWebViewScreen.gatewayCallbackPath);
  }

  void _jsDevLog(String message) {
    if (!kDebugMode) return;
    log(message, name: 'PaymentWebView.JS');
  }

  /// Rox uses the same callback URL for paid, failed, cancelled, and dropped.
  /// Never assume success just because this page loaded.
  Future<void> _tryCompleteFromCallbackPage() async {
    if (_didComplete) return;

    final detected = await _detectCallbackOutcome();
    _jsDevLog(
      'callback page outcome=${detected.status?.name ?? 'unknown'} '
      'message=${detected.message}',
    );

    await _invokeGatewayCallbackHandler(detected.status);

    final detectedMessage = detected.message?.trim();
    if (detectedMessage != null && detectedMessage.isNotEmpty) {
      _lastGatewayMessage ??= detectedMessage;
    }

    if (!mounted || _didComplete) return;

    // Fallback only when the page itself is clearly success or fail/cancel.
    // Unknown pages wait for the user to tap Return to ROX App.
    if (detected.status == null) return;

    await Future<void>.delayed(const Duration(milliseconds: 800));
    if (!mounted || _didComplete) return;
    _jsDevLog(
      'bridge did not fire — fallback ${detected.status!.name}',
    );
    _complete(
      PaymentWebViewResult(
        status: detected.status!,
        message: detected.message,
      ),
    );
  }

  Future<_CallbackPageOutcome> _detectCallbackOutcome() async {
    try {
      final raw = await _controller.runJavaScriptReturningResult('''
(function() {
  function pageText() {
    var title = document.title || '';
    var body = '';
    try {
      body = document.body
        ? (document.body.innerText || document.body.textContent || '')
        : '';
    } catch (e) {}
    var chip = '';
    try {
      var el = document.querySelector('.status-chip');
      if (el) chip = el.textContent || '';
    } catch (e) {}
    return (title + ' ' + chip + ' ' + body).toLowerCase();
  }
  function firstText(selectors) {
    for (var i = 0; i < selectors.length; i++) {
      try {
        var el = document.querySelector(selectors[i]);
        if (el && el.textContent && el.textContent.trim()) {
          return el.textContent.trim();
        }
      } catch (e) {}
    }
    return '';
  }
  var text = pageText();
  var title = (document.title || '').toLowerCase();
  var hasFailureBtn = !!document.getElementById('failureBtn');
  var hasSuccessBtn = !!document.getElementById('successBtn');
  var hasHandleFailure = typeof handleFailure === 'function';
  var hasHandleSuccess = typeof handleSuccess === 'function';
  var message = firstText(['.lead', 'h1', '.muted', 'p']);

  var isCancel = /cancel|cancelled|canceled|aborted|transaction is dropped/.test(title + ' ' + text);
  var isFail = hasFailureBtn
    || /payment failed|payment could not|could not be completed|could not confirm|unsuccessful|declined/.test(text)
    || title.indexOf('fail') !== -1
    || (hasHandleFailure && !hasHandleSuccess);
  var isSuccess = hasSuccessBtn
    || /payment successful|payment success|transaction successful|paid successfully/.test(text)
    || title.indexOf('success') !== -1
    || (hasHandleSuccess && !hasHandleFailure);

  var outcome = 'unknown';
  if (isSuccess && !isFail && !isCancel) outcome = 'success';
  else if (isCancel && !isSuccess) outcome = 'cancel';
  else if (isFail && !isSuccess) outcome = 'fail';
  else if (isFail || hasFailureBtn || hasHandleFailure) outcome = 'fail';
  else if (isSuccess) outcome = 'success';

  return JSON.stringify({ outcome: outcome, message: message });
})();
''');
      final map = _decodeJsObject(raw);
      if (map == null) return const _CallbackPageOutcome.unknown();
      final outcome = (map['outcome'] ?? '').toString().trim().toLowerCase();
      final message = (map['message'] ?? '').toString().trim();
      return _CallbackPageOutcome(
        status: switch (outcome) {
          'success' => PaymentWebViewStatus.success,
          'fail' || 'failed' || 'failure' => PaymentWebViewStatus.failed,
          'cancel' || 'cancelled' || 'canceled' => PaymentWebViewStatus.cancelled,
          _ => null,
        },
        message: message.isEmpty ? null : message,
      );
    } catch (e) {
      _jsDevLog('callback detection failed: $e');
      return const _CallbackPageOutcome.unknown();
    }
  }

  Map<String, dynamic>? _decodeJsObject(Object raw) {
    Object? current = raw;
    for (var i = 0; i < 2; i++) {
      if (current is String) {
        final trimmed = current.trim();
        if (trimmed.isEmpty || trimmed == 'null' || trimmed == 'undefined') {
          return null;
        }
        try {
          current = jsonDecode(trimmed);
        } catch (_) {
          return null;
        }
        continue;
      }
      break;
    }
    if (current is Map) {
      return Map<String, dynamic>.from(current);
    }
    return null;
  }

  Future<void> _invokeGatewayCallbackHandler(
    PaymentWebViewStatus? status,
  ) async {
    final outcome = switch (status) {
      PaymentWebViewStatus.success => 'success',
      PaymentWebViewStatus.failed => 'fail',
      PaymentWebViewStatus.cancelled => 'cancel',
      PaymentWebViewStatus.pending => 'pending',
      null => 'unknown',
    };
    try {
      await _controller.runJavaScript('''
(function() {
  try {
    var outcome = "$outcome";
    if (outcome === "success" && typeof handleSuccess === "function") {
      handleSuccess();
      return;
    }
    if ((outcome === "fail" || outcome === "cancel") && typeof handleFailure === "function") {
      handleFailure();
      return;
    }
    if (typeof handleFailure === "function" && typeof handleSuccess !== "function") {
      handleFailure();
      return;
    }
    if (typeof handleSuccess === "function" && typeof handleFailure !== "function") {
      handleSuccess();
    }
  } catch (e) {}
})();
''');
    } catch (e) {
      _jsDevLog('injected JS failed: $e');
    }
  }

  void _handleBridgeMessage(String raw) {
    final parsed = PaymentWebViewResult.tryParseBridgeMessage(raw);
    if (parsed == null) {
      _jsDevLog('payload ignored (unrecognized): $raw');
      return;
    }
    final gatewayMessage = parsed.message?.trim();
    if (gatewayMessage != null && gatewayMessage.isNotEmpty) {
      _lastGatewayMessage = gatewayMessage;
    }
    _jsDevLog(
      'payload parsed: status=${parsed.status.name} message=${parsed.message}',
    );
    _complete(parsed);
  }

  Future<void> _closeFromAppBar() async {
    if (_didComplete) return;

    try {
      await _controller.runJavaScript('''
(function() {
  try {
    if (typeof handleFailure === "function") {
      handleFailure();
    }
  } catch (e) {}
})();
''');
    } catch (e) {
      _jsDevLog('close invoke failed: $e');
    }

    if (!mounted || _didComplete) return;

    await Future<void>.delayed(const Duration(milliseconds: 400));
    if (!mounted || _didComplete) return;

    final detected = await _detectCallbackOutcome();
    if (!mounted || _didComplete) return;
    final detectedMessage = detected.message?.trim();
    if (detectedMessage != null && detectedMessage.isNotEmpty) {
      _lastGatewayMessage ??= detectedMessage;
    }

    _complete(
      PaymentWebViewResult.cancelled(message: _lastGatewayMessage),
    );
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
                  onPressed: _closeFromAppBar,
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

class _CallbackPageOutcome {
  const _CallbackPageOutcome({this.status, this.message});

  const _CallbackPageOutcome.unknown() : status = null, message = null;

  final PaymentWebViewStatus? status;
  final String? message;
}
