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
    return AppButton.primary(
      text: l10n.labTestDownloadReport,
      onPressed: onDownload,
      backgroundColor: AppColors.clr0FAA9A,
      foregroundColor: AppColors.clrWhite,
      width: double.infinity,
      height: 48.h,
      borderRadius: 12.r,
      fontWeight: FontWeight.w700,
    );
  }
}
