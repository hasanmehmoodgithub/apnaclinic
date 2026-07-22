import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../constants/consultation_ui_config.dart';
import '../widgets/ai_screening_exit_dialog.dart';
import '../widgets/ai_screening_shimmer_widget.dart';
import '../widgets/consultation_screen_header_widget.dart';

class AiScreeningScreen extends StatefulWidget {
  const AiScreeningScreen({super.key});

  @override
  State<AiScreeningScreen> createState() => _AiScreeningScreenState();
}

class _AiScreeningScreenState extends State<AiScreeningScreen> {
  late final WebViewController _controller;
  var _isLoading = true;
  var _hasError = false;
  var _isExitDialogVisible = false;

  static const _url = ConsultationUiConfig.apnaDoctorAiUrl;

  @override
  void initState() {
    super.initState();
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

  Future<void> _onBackRequested() async {
    if (_isExitDialogVisible) return;
    _isExitDialogVisible = true;
    final shouldExit = await showAiScreeningExitDialog(context);
    _isExitDialogVisible = false;
    if (shouldExit && mounted) context.pop();
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
