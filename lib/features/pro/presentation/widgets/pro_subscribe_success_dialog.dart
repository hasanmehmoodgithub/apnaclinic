import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../generated/assets.dart';
import 'pro_brand_mark.dart';

/// Success dialog shown after ApnaClinic Pro subscription.
class ProSubscribeSuccessDialog extends StatelessWidget {
  const ProSubscribeSuccessDialog({
    super.key,
    this.title,
    this.message,
  });

  /// Optional override; defaults to l10n.
  final String? title;
  final String? message;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 24.w),
      backgroundColor: AppColors.clrWhite,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24.r),
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(20.w, 28.h, 20.w, 22.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const ProBrandMark(height: 88),
            SizedBox(height: 22.h),
            Text(
              title?.trim().isNotEmpty == true
                  ? title!.trim()
                  : l10n.proSubscribeSuccessTitle,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleLarge?.copyWith(
                color: AppColors.clr102A56,
                fontWeight: FontWeight.w700,
                fontSize: 20.sp,
                height: 1.3,
              ),
            ),
            SizedBox(height: 10.h),
            Text(
              message?.trim().isNotEmpty == true
                  ? message!.trim()
                  : l10n.proSubscribeSuccessMessage,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppColors.clr6C7C92,
                fontSize: 14.sp,
                height: 1.45,
              ),
            ),
            SizedBox(height: 22.h),
            _SuccessActionButton(
              label: l10n.proSubscribeSuccessConsultation,
              iconAsset: Assets.iconsDoctor,
              onTap: () => context.pop(
                AppRoutes.path(AppRoutes.consultation),
              ),
            ),
            SizedBox(height: 12.h),
            _SuccessActionButton(
              label: l10n.proSubscribeSuccessPharmacy,
              iconAsset: Assets.iconsPharmacy,
              onTap: () => context.pop(
                AppRoutes.path(AppRoutes.pharmacyMain),
              ),
            ),
            SizedBox(height: 12.h),
            _SuccessActionButton(
              label: l10n.proSubscribeSuccessLab,
              iconAsset: Assets.iconsLab,
              onTap: () => context.pop(
                AppRoutes.path(AppRoutes.labTest),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SuccessActionButton extends StatelessWidget {
  const _SuccessActionButton({
    required this.label,
    required this.iconAsset,
    required this.onTap,
  });

  final String label;
  final String iconAsset;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52.h,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.clr1FAFA3,
          foregroundColor: AppColors.clrWhite,
          elevation: 0,
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14.r),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              iconAsset,
              width: 22.r,
              height: 22.r,
              colorFilter: const ColorFilter.mode(
                AppColors.clrWhite,
                BlendMode.srcIn,
              ),
            ),
            SizedBox(width: 10.w),
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: AppColors.clrWhite,
                  fontWeight: FontWeight.w700,
                  fontSize: 16.sp,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Shows the Pro subscribe success dialog.
///
/// Returns the route to open when the user picks a service, or null if the
/// dialog is dismissed without a choice.
Future<String?> showProSubscribeSuccessDialog(
  BuildContext context, {
  String? title,
  String? message,
}) {
  return showDialog<String>(
    context: context,
    barrierDismissible: false,
    builder: (dialogContext) {
      return PopScope(
        canPop: false,
        child: ProSubscribeSuccessDialog(
          title: title,
          message: message,
        ),
      );
    },
  );
}
