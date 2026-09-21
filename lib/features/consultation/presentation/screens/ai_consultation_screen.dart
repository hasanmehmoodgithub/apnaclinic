import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

import '../../../../core/analytics/analytics_event_keys.dart';
import '../../../../core/analytics/analytics_service.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/preference/app_pref.dart';
import '../../../../core/utils/microphone_permission_utils.dart';
import '../../../../core/utils/webview_media_permission_utils.dart';
import '../../domain/use_cases/record_ai_assistant_interaction_use_case.dart';
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

class _AiScreeningScreenState extends State<AiScreeningScreen>
    with WidgetsBindingObserver {
  WebViewController? _controller;
  late final AnalyticsService _analytics;
  late final RecordAiAssistantInteractionUseCase _recordInteraction;
  late final DateTime _startedAt;
  late final String _sessionId;
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
    WidgetsBinding.instance.addObserver(this);
    _analytics = sl<AnalyticsService>();
    _recordInteraction = sl<RecordAiAssistantInteractionUseCase>();
    _startedAt = DateTime.now();
    _sessionId = RecordAiAssistantInteractionParams.buildSessionId(
      sl<AppPref>().getUserId(),
    );
    unawaited(_analytics.logEvent(AnalyticsEventKeys.aiChatStarted));
    unawaited(_prepareAndLoad());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      unawaited(configureWebViewPlaybackSession());
    }
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
      onPermissionRequest: (request) {
        grantWebViewMediaPermission(request);
        unawaited(configureWebViewPlaybackSession());
      },
    );
    controller
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
            unawaited(_onPageReady(controller));
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
    }

    return controller;
  }

  Future<void> _prepareAndLoad() async {
    await ensureMicrophonePermission();
    if (!mounted) return;
    await configureWebViewPlaybackSession();
    if (!mounted) return;
    final controller = _createController();
    await _useSafariLikeUserAgent(controller);
    if (!mounted) return;
    setState(() => _controller = controller);
    await controller.loadRequest(Uri.parse(_url));
  }

  /// Voice-AI pages often disable WebRTC unless the UA looks like Safari.
  Future<void> _useSafariLikeUserAgent(WebViewController controller) async {
    if (defaultTargetPlatform != TargetPlatform.iOS) return;
    final ua = await controller.getUserAgent();
    if (ua == null || ua.isEmpty) return;
    if (ua.contains('Safari/')) return;
    await controller.setUserAgent('$ua Version/18.0 Safari/604.1');
  }

  Future<void> _onPageReady(WebViewController controller) async {
    await configureWebViewPlaybackSession();
    if (!mounted) return;
    try {
      await controller.runJavaScript(_kUnlockWebAudioJs);
    } catch (_) {}
  }

  static const _kUnlockWebAudioJs = '''
(function() {
  function unlock() {
    try {
      var AC = window.AudioContext || window.webkitAudioContext;
      if (AC) {
        window.__apnaAudioCtx = window.__apnaAudioCtx || new AC();
        if (window.__apnaAudioCtx.state === 'suspended') {
          window.__apnaAudioCtx.resume();
        }
      }
      document.querySelectorAll('audio, video').forEach(function(el) {
        el.muted = false;
        el.volume = 1;
        el.playsInline = true;
        el.setAttribute('playsinline', '');
        el.setAttribute('webkit-playsinline', '');
      });
    } catch (e) {}
  }
  unlock();
  document.addEventListener('touchstart', unlock, {passive: true});
  document.addEventListener('click', unlock, true);
})();
''';

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
    unawaited(_recordAiAssistantInteraction(seconds));
  }

  Future<void> _recordAiAssistantInteraction(int durationSeconds) async {
    await _recordInteraction(
      RecordAiAssistantInteractionParams(
        sessionId: _sessionId,
        startedAt: _startedAt,
        durationSeconds: durationSeconds,
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
                    if (_controller != null)
                      WebViewWidget(
                        controller: _controller!,
                        gestureRecognizers: {
                          Factory<OneSequenceGestureRecognizer>(
                            EagerGestureRecognizer.new,
                          ),
                        },
                      ),
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
                                  final controller = _controller;
                                  if (controller == null) return;
                                  setState(() {
                                    _isLoading = true;
                                    _hasError = false;
                                  });
                                  controller.loadRequest(Uri.parse(_url));
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
