import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../constants/consultation_ui_config.dart';

class ConsultationBookingConfirmationDialogWidget extends StatelessWidget {
  const ConsultationBookingConfirmationDialogWidget({
    super.key,
    required this.doctorName,
  });

  final String doctorName;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
      ),
      title: Text(
        l10n.consultationBookingConfirmedTitle,
        style: textTheme.titleLarge?.copyWith(
          color: ConsultationUiConfig.primaryText,
          fontWeight: FontWeight.w700,
          fontSize: 22.sp,
        ),
      ),
      content: Text(
        l10n.consultationBookingConfirmedMessage(doctorName),
        style: textTheme.bodyMedium?.copyWith(
          color: ConsultationUiConfig.tertiaryText,
          fontSize: 14.sp,
        ),
      ),
      actions: [
        TextButton(
          onPressed: context.pop,
          child: Text(l10n.commonOk),
        ),
      ],
    );
  }
}
