import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/utils/app_url_launcher.dart';
import '../../../../generated/assets.dart';

/// Invoice PDF tile on lab test view-details (matches surgery e-invoice card).
class LabTestViewDetailsInvoiceCard extends StatelessWidget {
  const LabTestViewDetailsInvoiceCard({
    super.key,
    required this.invoiceUrl,
    this.fileName,
  });

  final String invoiceUrl;
  final String? fileName;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;
    final label = (fileName?.trim().isNotEmpty == true)
        ? fileName!.trim()
        : l10n.labTestInvoiceFileName;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: AppColors.clrF7F7F7,
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Row(
        children: [
          Image.asset(
            Assets.consultationPdfIcon,
            width: 28.w,
            height: 32.h,
            fit: BoxFit.contain,
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              label,
              style: textTheme.bodyMedium?.copyWith(
                color: const Color(0xFF061E40),
                fontSize: 15.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          GestureDetector(
            onTap: () => AppUrlLauncher.open(
              url: invoiceUrl,
              lunchMode: LaunchMode.externalApplication,
            ),
            behavior: HitTestBehavior.opaque,
            child: Image.asset(
              Assets.consultationEInvoiceDownload,
              width: 22.w,
              height: 22.h,
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }
}
