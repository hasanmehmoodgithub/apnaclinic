import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../payment/domain/entities/payment_webview_result.dart';
import '../pro_user_webview_args.dart';

/// Pro subscribe page. The site posts the result on `AndroidInterface`:
/// `{ "status": "success"|"fail"|"pending", "success": true/false, "message": "...", "statusCode": 200 }`.
class ProUserWebViewScreen extends StatefulWidget {
  const ProUserWebViewScreen({super.key, required this.args});

  final ProUserWebViewArgs args;

  static const bridgeChannelName = 'AndroidInterface';
  static const logChannelName = 'Javascript';

  @override
  State<ProUserWebViewScreen> createState() => _ProUserWebViewScreenState();
}

class _ProUserWebViewScreenState extends State<ProUserWebViewScreen> {
  late final WebViewController _controller;
  var _isLoading = true;
  var _hasError = false;
  var _didComplete = false;
  PaymentWebViewResult? _callbackResult;

  @override
  void initState() {
    super.initState();
    final url = widget.args.url.trim();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(AppColors.clrWhite)
      ..addJavaScriptChannel(
        ProUserWebViewScreen.bridgeChannelName,
        onMessageReceived: (message) => _onCallback(message.message),
      )
      ..addJavaScriptChannel(
        ProUserWebViewScreen.logChannelName,
        onMessageReceived: (message) {
          final text = message.message;
          log(text, name: 'Javascript');
          if (text.startsWith('back:')) _leave();
        },
      )
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (_) {
            if (!mounted) return;
            setState(() {
              _isLoading = true;
              _hasError = false;
            });
          },
          onPageFinished: (_) {
            if (!mounted) return;
            setState(() => _isLoading = false);
            _installCallbackLogger();
          },
          onWebResourceError: (error) {
            if (!mounted || _didComplete || error.isForMainFrame == false) {
              return;
            }
            setState(() {
              _isLoading = false;
              _hasError = true;
            });
          },
        ),
      )
      ..loadRequest(Uri.parse(url));
  }

  Future<void> _installCallbackLogger() async {
    try {
      await _controller.runJavaScript(_callbackLoggerJs);
    } catch (error) {
      log('callback logger failed: $error', name: 'Javascript');
    }
  }

  void _onCallback(String raw) {
    final result = PaymentWebViewResult.tryParseBridgeMessage(raw);
    log(
      'callback: $raw'
      '${result == null ? ' (unrecognized)' : ' → ${result.status.name}'}',
      name: 'Javascript',
    );
    if (result == null) return;
    _callbackResult = result;
  }

  static const _callbackLoggerJs = r'''
(function() {
  function send(kind, value) {
    try {
      var text = (typeof value === 'string') ? value : JSON.stringify(value);
      Javascript.postMessage(kind + ': ' + text);
    } catch (e) {}
  }
  if (!window.__jsCallbackLogger) {
    window.__jsCallbackLogger = true;
    ['log', 'info', 'warn', 'error', 'debug'].forEach(function(level) {
      var original = console[level];
      console[level] = function() {
        try {
          var parts = [];
          for (var i = 0; i < arguments.length; i++) {
            var arg = arguments[i];
            try {
              parts.push(typeof arg === 'string' ? arg : JSON.stringify(arg));
            } catch (e) {
              parts.push(String(arg));
            }
          }
          send('console.' + level, parts.join(' '));
        } catch (e) {}
        if (original) return original.apply(console, arguments);
      };
    });
    window.addEventListener('message', function(event) {
      send('message', event && event.data);
    });
    document.addEventListener('click', function(event) {
      var node = event.target;
      var el = node && node.closest
        ? node.closest('button, a, input[type="button"], input[type="submit"], [role="button"]')
        : null;
      if (!el) return;
      var text = (el.innerText || el.value || el.getAttribute('aria-label') || '').trim();
      var payload = {
        tag: el.tagName,
        id: el.id || '',
        type: el.type || '',
        text: text.slice(0, 200)
      };
      send('button', payload);
      if (/back|return|close|cancel|واپس|بند/i.test(text + ' ' + (el.id || ''))) {
        send('back', payload);
      }
    }, true);
  }
  ['handleSuccess', 'handleFailure', 'onPaymentCallback', 'paymentCallback', 'onCallback']
    .forEach(function(name) {
      var fn = window[name];
      if (typeof fn !== 'function' || fn.__logged) return;
      var wrapped = function() {
        try {
          send(name, arguments.length === 1 ? arguments[0] : Array.prototype.slice.call(arguments));
        } catch (e) {}
        return fn.apply(this, arguments);
      };
      wrapped.__logged = true;
      window[name] = wrapped;
    });
})();
''';

  void _leave() {
    if (_didComplete || !mounted) return;
    final result = _callbackResult ?? PaymentWebViewResult.cancelled();
    log('back: ${result.status.name}', name: 'Javascript');
    _finish(result);
  }

  void _finish(PaymentWebViewResult result) {
    if (_didComplete || !mounted) return;
    _didComplete = true;
    context.pop(result);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final title = widget.args.title?.trim();
    final url = widget.args.url.trim();

    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: AppColors.clrWhite,
        appBar: AppBar(
          backgroundColor: AppColors.clrWhite,
          elevation: 0,
          automaticallyImplyLeading: false,
          leading: IconButton(
            onPressed: _leave,
            icon: Icon(Icons.close_rounded, color: AppColors.clr060, size: 24.r),
          ),
          title: Text(
            (title != null && title.isNotEmpty) ? title : l10n.paymentWebViewTitle,
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
                          _controller.loadRequest(Uri.parse(url));
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
