import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../instant_doctor_consultation_args.dart';
import '../widgets/instant_doctor_consultation_app_bar_widget.dart';

class InstantDoctorConsultationWebViewScreen extends StatefulWidget {
  const InstantDoctorConsultationWebViewScreen({
    super.key,
    required this.args,
  });

  final InstantDoctorConsultationArgs args;

  @override
  State<InstantDoctorConsultationWebViewScreen> createState() =>
      _InstantDoctorConsultationWebViewScreenState();
}

class _InstantDoctorConsultationWebViewScreenState
    extends State<InstantDoctorConsultationWebViewScreen> {
  late final WebViewController _controller;
  var _isLoading = true;
  var _hasError = false;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
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
      ..loadRequest(Uri.parse(widget.args.url));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.clrWhite,
      appBar: InstantDoctorConsultationAppBarWidget(
        title: widget.args.title,
      ),
      body: SafeArea(
        top: false,
        child: Stack(
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
                            _controller.loadRequest(Uri.parse(widget.args.url));
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
