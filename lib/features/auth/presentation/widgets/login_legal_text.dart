import 'package:flutter/material.dart';

import '../../../../core/l10n/app_localizations.dart';

class LoginLegalText extends StatelessWidget {
  const LoginLegalText({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Text.rich(
      TextSpan(
        children: [
          TextSpan(text: '${l10n.authLegalPrefix} '),
          TextSpan(
            text: l10n.authTermsLabel,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
          TextSpan(text: ' ${l10n.authLegalConnector} '),
          TextSpan(
            text: l10n.authPrivacyLabel,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
        ],
      ),
      textAlign: TextAlign.center,
      style: theme.textTheme.bodySmall?.copyWith(
        color: const Color(0xFF667085),
        height: 1.65,
      ),
    );
  }
}
