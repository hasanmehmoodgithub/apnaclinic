import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/utils/pdf_file_actions.dart';

/// Floating Share / Download actions for the PDF viewer (bottom-right).
class LabTestPdfViewerActionsWidget extends StatelessWidget {
  const LabTestPdfViewerActionsWidget({super.key, required this.filePath});

  final String filePath;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h + bottomInset),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _PdfViewerFab(
            icon: Icons.ios_share_rounded,
            label: l10n.pdfViewerShare,
            foreground: AppColors.clr060,
            background: AppColors.clrWhite,
            onTap: () => PdfFileActions.share(context, filePath: filePath),
          ),
          SizedBox(height: 12.h),
          _PdfViewerFab(
            icon: Icons.download_rounded,
            label: l10n.pdfViewerDownload,
            foreground: AppColors.clrWhite,
            background: AppColors.primaryColor,
            onTap: () => PdfFileActions.download(context, filePath: filePath),
          ),
        ],
      ),
    );
  }
}

class _PdfViewerFab extends StatelessWidget {
  const _PdfViewerFab({
    required this.icon,
    required this.label,
    required this.foreground,
    required this.background,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final Color foreground;
  final Color background;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(28.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.clr060.withValues(alpha: 0.16),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(28.r),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, color: foreground, size: 20.sp),
                SizedBox(width: 8.w),
                Text(
                  label,
                  style: textTheme.labelLarge?.copyWith(
                    color: foreground,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
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
