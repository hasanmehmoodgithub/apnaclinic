import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/preference/app_pref.dart';
import '../../../../core/utils/app_url_launcher.dart';

class LoginLegalText extends StatefulWidget {
  const LoginLegalText({super.key});

  @override
  State<LoginLegalText> createState() => _LoginLegalTextState();
}

class _LoginLegalTextState extends State<LoginLegalText> {
  late final TapGestureRecognizer _termsRecognizer;
  late final TapGestureRecognizer _privacyRecognizer;

  @override
  void initState() {
    super.initState();
    _termsRecognizer = TapGestureRecognizer()
      ..onTap = () => AppUrlLauncher.open(
        url: sl<AppPref>().getSupportSettings()?.termsAndConditionsUrl ?? '',
        lunchMode: LaunchMode.inAppBrowserView,
      );
    _privacyRecognizer = TapGestureRecognizer()
      ..onTap = () => AppUrlLauncher.open(
        url: sl<AppPref>().getSupportSettings()?.privacyPolicyUrl ?? '',
        lunchMode: LaunchMode.inAppBrowserView,
      );
  }

  @override
  void dispose() {
    _termsRecognizer.dispose();
    _privacyRecognizer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Text.rich(
      TextSpan(
        children: [
          TextSpan(text: '${l10n.authLegalPrefix} '),
          TextSpan(
            text: l10n.authTermsLabel,
            style: AppTextStyles.loginLegalLink,
            recognizer: _termsRecognizer,
          ),
          TextSpan(text: ' ${l10n.authLegalConnector} '),
          TextSpan(
            text: l10n.authPrivacyLabel,
            style: AppTextStyles.loginLegalLink,
            recognizer: _privacyRecognizer,
          ),
        ],
      ),
      textAlign: TextAlign.center,
      style: AppTextStyles.loginLegal,
    );
  }
}
