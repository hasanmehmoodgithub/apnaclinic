import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../constants/app_colors.dart';
import '../constants/app_system_ui.dart';
import '../extensions/screen_util_extensions.dart';
import '../l10n/app_localizations.dart';
import 'security_service.dart';
import 'widgets/security_blocked_view.dart';
import 'widgets/security_checking_view.dart';

/// Widget that blocks app access if device is compromised
class SecurityGate extends StatefulWidget {
  final Widget child;
  final Widget? blockedWidget;
  final int countdownSeconds;

  const SecurityGate({
    super.key,
    required this.child,
    this.blockedWidget,
    this.countdownSeconds = 5,
  });

  @override
  State<SecurityGate> createState() => _SecurityGateState();
}

class _SecurityGateState extends State<SecurityGate> {
  bool _isChecking = SecurityService.securityChecksEnabled;
  bool _isCompromised = false;
  String? _securityMessage;
  int _countdown = 5;
  Timer? _countdownTimer;

  @override
  void initState() {
    super.initState();
    if (SecurityService.securityChecksEnabled) {
      _performSecurityCheck();
    }
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    super.dispose();
  }

  Future<void> _performSecurityCheck() async {
    final isCompromised = await SecurityService.isDeviceCompromised();
    final message = await SecurityService.getSecurityMessage();

    if (mounted) {
      setState(() {
        _isCompromised = isCompromised;
        _securityMessage = message;
        _isChecking = false;
      });

      if (isCompromised) {
        _startCountdown();
      }
    }
  }

  void _startCountdown() {
    _countdown = widget.countdownSeconds;
    _countdownTimer?.cancel();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _countdown--;
        });

        if (_countdown <= 0) {
          timer.cancel();
          _terminateApp();
        }
      } else {
        timer.cancel();
      }
    });
  }

  void _terminateApp() {
    if (Platform.isAndroid) {
      SystemNavigator.pop();
    } else if (Platform.isIOS) {
      exit(0);
    } else {
      exit(0);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isChecking) {
      return _standaloneApp(const SecurityCheckingView());
    }

    if (_isCompromised) {
      return widget.blockedWidget ??
          _standaloneApp(
            SecurityBlockedView(
              message: _securityMessage,
              countdown: _countdown,
              totalSeconds: widget.countdownSeconds,
            ),
          );
    }

    return widget.child;
  }

  Widget _standaloneApp(Widget home) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Satoshi',
        scaffoldBackgroundColor: AppColors.clrF5FBFA,
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.clr0FAA9A),
        appBarTheme: const AppBarTheme(
          systemOverlayStyle: AppSystemUi.overlayStyle,
        ),
      ),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      builder: (context, child) {
        ScreenUtilX.init(
          context,
          designWidth: 410,
          designHeight: 720,
          useScaleByDefault: false,
        );
        return child ?? const SizedBox.shrink();
      },
      home: home,
    );
  }
}
