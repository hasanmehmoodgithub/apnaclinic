import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/network/app_urls.dart';
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
      ..onTap = () => AppUrlLauncher.open(url:AppUrls.termsAndConditions,lunchMode: LaunchMode.inAppWebView);
    _privacyRecognizer = TapGestureRecognizer()
      ..onTap = () => AppUrlLauncher.open(url:AppUrls.privacyPolicy,lunchMode: LaunchMode.inAppWebView);
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
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(
        bottom: 24.0,
        left: 20.0,
        right: 20.0,
        top: 2.0,
      ),
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(text: '${l10n.authLegalPrefix} '),
            TextSpan(
              text: l10n.authTermsLabel,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                color: AppColors.clr09,
              ),
              recognizer: _termsRecognizer,
            ),
            TextSpan(text: ' ${l10n.authLegalConnector} '),
            TextSpan(
              text: l10n.authPrivacyLabel,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                color: AppColors.clr09,
              ),
              recognizer: _privacyRecognizer,
            ),
          ],
        ),
        textAlign: TextAlign.center,
        style: theme.textTheme.bodySmall?.copyWith(
          fontSize: (theme.textTheme.bodySmall?.fontSize ?? 12) - 2,
          color: AppColors.clr667085,
          height: 1.65,
        ),
      ),
    );
  }
}
