import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../core/extensions/build_context_extensions.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/utils/webview_file_selector_utils.dart';
import '../../../../core/utils/webview_media_permission_utils.dart';
import '../../domain/use_cases/log_instant_doctor_session_params.dart';
import '../../domain/use_cases/log_instant_doctor_session_use_case.dart';
import '../instant_doctor_consultation_args.dart';
import '../widgets/instant_doctor_consultation_app_bar_widget.dart';
import '../widgets/instant_doctor_consultation_exit_dialog.dart';

class InstantDoctorConsultationWebViewScreen extends StatefulWidget {
  const InstantDoctorConsultationWebViewScreen({
    super.key,
    required this.args,
  });

  static const String instantDocLogChannelName = 'instant_doctor_call_log';

  final InstantDoctorConsultationArgs args;

  @override
  State<InstantDoctorConsultationWebViewScreen> createState() =>
      _InstantDoctorConsultationWebViewScreenState();
}

class _InstantDoctorConsultationWebViewScreenState
    extends State<InstantDoctorConsultationWebViewScreen> {
  late final WebViewController _controller;
  late final String _startTime;
  var _isLoading = true;
  var _hasError = false;
  var _isExitDialogVisible = false;
  var _didSubmitSessionLog = false;
  String _instantDocLog = '';

  @override
  void initState() {
    super.initState();
    _startTime = DateTime.now().toIso8601String();
    _controller = _createController();
    _prepareAndLoad();
  }

  WebViewController _createController() {
    final PlatformWebViewControllerCreationParams params;
    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      params = WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,
        mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
        javaScriptCanOpenWindowsAutomatically: true,
      );
    } else {
      params = AndroidWebViewControllerCreationParams();
    }

    final controller = WebViewController.fromPlatformCreationParams(
      params,
      onPermissionRequest: grantWebViewMediaPermission,
    )
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..addJavaScriptChannel(
        InstantDoctorConsultationWebViewScreen.instantDocLogChannelName,
        onMessageReceived: _onInstantDocLogMessage,
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
          },
          onWebResourceError: (_) {
            if (!mounted) return;
            setState(() {
              _isLoading = false;
              _hasError = true;
            });
          },
        ),
      );

    final platformController = controller.platform;
    if (platformController is AndroidWebViewController) {
      platformController.setMediaPlaybackRequiresUserGesture(false);
      platformController.setMixedContentMode(MixedContentMode.alwaysAllow);
      platformController.setAllowFileAccess(true);
      platformController.setAllowContentAccess(true);
      platformController.setOnShowFileSelector(handleAndroidWebViewFileSelection);
    }

    return controller;
  }

  Future<void> _prepareAndLoad() async {
    final allowed = await ensureCameraAndMicrophonePermissions();
    if (!mounted) return;
    if (!allowed) {
      context.showErrorSnackBar(
        AppLocalizations.of(context)!.instantDoctorMediaPermissionDenied,
      );
    }

    await configureWebViewMediaSession();
    if (!mounted) return;
    await _useChromeLikeUserAgent();
    if (!mounted) return;
    await _controller.loadRequest(Uri.parse(widget.args.url));
  }

  /// Video-consult sites often treat the Android WebView UA (`wv`) as a
  /// browser that cannot use camera/mic.
  Future<void> _useChromeLikeUserAgent() async {
    final ua = await _controller.getUserAgent();
    if (ua == null || ua.isEmpty) return;
    final chromeLike = ua
        .replaceAll('; wv', '')
        .replaceAll('Version/4.0 ', '');
    if (chromeLike == ua) return;
    await _controller.setUserAgent(chromeLike);
  }

  Widget _buildWebView() {
    if (WebViewPlatform.instance is AndroidWebViewPlatform) {
      return WebViewWidget.fromPlatformCreationParams(
        params:
            AndroidWebViewWidgetCreationParams.fromPlatformWebViewWidgetCreationParams(
          PlatformWebViewWidgetCreationParams(
            controller: _controller.platform,
          ),
          displayWithHybridComposition: true,
        ),
      );
    }
    return WebViewWidget(controller: _controller);
  }

  void _onInstantDocLogMessage(JavaScriptMessage message) {
    _instantDocLog = message.message;
  }

  String get _instantDocLogPayload {
    if (_instantDocLog.trim().isEmpty) return '';
    return _instantDocLog;
  }

  void _submitSessionLog() {
    if (_didSubmitSessionLog) return;
    _didSubmitSessionLog = true;
    final endTime = DateTime.now().toIso8601String();
    try {
      unawaited(
        sl<LogInstantDoctorSessionUseCase>()(
          LogInstantDoctorSessionParams(
            startTime: _startTime,
            endTime: endTime,
            instantDocLog: _instantDocLogPayload,
            providerName: widget.args.providerName,
          ),
        ).then(
          (result) {
            result.fold(
              (error) => log('logInstantDoctorSession failed: $error'),
              (_) {},
            );
          },
          onError: (Object error, StackTrace stackTrace) {
            log(
              'logInstantDoctorSession failed: $error',
              stackTrace: stackTrace,
            );
          },
        ),
      );
    } catch (error, stackTrace) {
      log('logInstantDoctorSession failed: $error', stackTrace: stackTrace);
    }
  }

  Future<void> _onBackRequested() async {
    if (_isExitDialogVisible) return;
    _isExitDialogVisible = true;
    final shouldExit = await showInstantDoctorConsultationExitDialog(context);
    _isExitDialogVisible = false;
    if (!shouldExit || !mounted) return;
    //TODO submitSessionLog
   //_submitSessionLog();
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
        appBar: InstantDoctorConsultationAppBarWidget(
          title: widget.args.title,
          onBackTap: _onBackRequested,
        ),
        body: SafeArea(
          top: false,
          child: Stack(
            children: [
              _buildWebView(),
              if (_isLoading)
                const Center(
                  child: CircularProgressIndicator(color: AppColors.clr0FAA9A),
                ),
              // if (_hasError)
              //   Center(
              //     child: Padding(
              //       padding: EdgeInsets.symmetric(horizontal: 24.w),
              //       child: Column(
              //         mainAxisSize: MainAxisSize.min,
              //         children: [
              //           Text(
              //             l10n.instantDoctorOpenAppError,
              //             textAlign: TextAlign.center,
              //             style: TextStyle(
              //               color: AppColors.clr6C7C92,
              //               fontSize: 15.sp,
              //               fontWeight: FontWeight.w500,
              //             ),
              //           ),
              //           SizedBox(height: 16.h),
              //           TextButton(
              //             onPressed: () {
              //               setState(() {
              //                 _isLoading = true;
              //                 _hasError = false;
              //               });
              //               _controller.loadRequest(Uri.parse(widget.args.url));
              //             },
              //             child: Text(l10n.commonRetry),
              //           ),
              //         ],
              //       ),
              //     ),
              //   ),
            ],
          ),
        ),
      ),
    );
  }
}
