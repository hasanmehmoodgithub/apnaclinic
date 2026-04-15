import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../extensions/screen_util_extensions.dart';
import 'security_service.dart';

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
  bool _isChecking = true;
  bool _isCompromised = false;
  String? _securityMessage;
  int _countdown = 5;
  Timer? _countdownTimer;

  @override
  void initState() {
    super.initState();
    _performSecurityCheck();
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

      // Start countdown timer if device is compromised
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
    // Terminate the app
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
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(body: Center(child: CircularProgressIndicator())),
      );
    }

    if (_isCompromised) {
      return widget.blockedWidget ?? _defaultBlockedWidget();
    }

    return widget.child;
  }

  Widget _defaultBlockedWidget() {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.red.shade50,
        body: Center(
          child: Padding(
            padding: EdgeInsets.all(24.r),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.security,
                  size: 80.r,
                  color: Colors.red,
                ),
                SizedBox(height: 32.h),
                Text(
                  'Access Denied',
                  style: TextStyle(
                    fontSize: 28.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
                SizedBox(height: 24.h),
                Text(
                  _securityMessage ??
                      'Your device does not meet security requirements.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 40.h),
                // Countdown timer
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 24.w,
                    vertical: 16.h,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.red.shade100,
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: Colors.red, width: 2.r),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Application will close in:',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        '$_countdown',
                        style: TextStyle(
                          fontSize: 48.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.red.shade700,
                        ),
                      ),
                      Text(
                        'seconds',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
