import 'package:flutter/material.dart';

import '../../../../components/widgets/app_button.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';

class LabTestViewDetailsDownloadReportChip extends StatelessWidget {
  const LabTestViewDetailsDownloadReportChip({
    super.key,
    this.onDownload,
  });

  final VoidCallback? onDownload;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final enabled = onDownload != null;
    return AbsorbPointer(
      absorbing: !enabled,
      child: AppButton.primary(
        text: l10n.labTestDownloadReport,
        onPressed: onDownload ?? () {},
        backgroundColor:
            enabled ? AppColors.clr0FAA9A : AppColors.clrD0D5DD,
        foregroundColor:
            enabled ? AppColors.clrWhite : AppColors.clr6B7280,
        elevation: enabled ? null : 0,
        width: double.infinity,
        height: 48.h,
        borderRadius: 12.r,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}
