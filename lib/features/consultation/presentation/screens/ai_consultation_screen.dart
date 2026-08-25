import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../../core/analytics/analytics_event_keys.dart';
import '../../../../core/analytics/analytics_service.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../constants/consultation_ui_config.dart';
import '../widgets/ai_screening_exit_dialog.dart';
import '../widgets/ai_screening_shimmer_widget.dart';
import '../widgets/consultation_screen_header_widget.dart';

class AiScreeningScreen extends StatefulWidget {
  const AiScreeningScreen({super.key, this.url});

  final String? url;

  @override
  State<AiScreeningScreen> createState() => _AiScreeningScreenState();
}

class _AiScreeningScreenState extends State<AiScreeningScreen> {
  late final WebViewController _controller;
  late final AnalyticsService _analytics;
  late final DateTime _startedAt;
  var _isLoading = true;
  var _hasError = false;
  var _isExitDialogVisible = false;
  var _hasLoggedEnd = false;

  String get _url {
    final extra = widget.url?.trim() ?? '';
    if (extra.isNotEmpty) return extra;
    return ConsultationUiConfig.apnaDoctorAiUrl;
  }

  @override
  void initState() {
    super.initState();
    _analytics = sl<AnalyticsService>();
    _startedAt = DateTime.now();
    unawaited(_analytics.logEvent(AnalyticsEventKeys.aiChatStarted));
    _controller = WebViewController(
      onPermissionRequest: (request) => request.grant(),
    )
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
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
          },
          onWebResourceError: (_) {
            if (!mounted) return;
            setState(() {
              _isLoading = false;
              _hasError = true;
            });
          },
        ),
      )
      ..loadRequest(Uri.parse(_url));
  }

  void _logChatEnded() {
    if (_hasLoggedEnd) return;
    _hasLoggedEnd = true;
    final seconds = DateTime.now().difference(_startedAt).inSeconds;
    unawaited(
      _analytics.logEvent(
        AnalyticsEventKeys.aiChatEnded,
        {AnalyticsParamKeys.callDuration: '${seconds}s'},
      ),
    );
  }

  Future<void> _onBackRequested() async {
    if (_isExitDialogVisible) return;
    _isExitDialogVisible = true;
    final shouldExit = await showAiScreeningExitDialog(context);
    _isExitDialogVisible = false;
    if (!shouldExit || !mounted) return;
    _logChatEnded();
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        _onBackRequested();
      },
      child: Scaffold(
        backgroundColor: AppColors.clrWhite,
        body: SafeArea(
          child: Column(
            children: [
              ConsultationScreenHeaderWidget(
                title: l10n.consultationAiScreeningTitle,
                onBackTap: _onBackRequested,
              ),
              Expanded(
                child: Stack(
                  children: [
                    WebViewWidget(controller: _controller),
                    if (_isLoading)
                      const Positioned.fill(
                        child: AiScreeningShimmerWidget(),
                      ),
                    if (_hasError)
                      Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 24.w),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                l10n.instantDoctorOpenAppError,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: AppColors.clr6C7C92,
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(height: 16.h),
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    _isLoading = true;
                                    _hasError = false;
                                  });
                                  _controller.loadRequest(Uri.parse(_url));
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
            ],
          ),
        ),
      ),
    );
  }
}
