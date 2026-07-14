import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../components/widgets/app_button.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/utils/app_url_launcher.dart';
import '../../domain/entities/app_update_prompt_entity.dart';

Future<void> showAppUpdateDialog(
  BuildContext context, {
  required AppUpdatePromptEntity prompt,
}) {
  return showDialog<void>(
    context: context,
    barrierDismissible: !prompt.forceUpdate,
    barrierColor: Colors.black.withValues(alpha: 0.45),
    builder: (dialogContext) {
      return PopScope(
        canPop: !prompt.forceUpdate,
        child: AppUpdateDialog(prompt: prompt),
      );
    },
  );
}

class AppUpdateDialog extends StatelessWidget {
  const AppUpdateDialog({super.key, required this.prompt});

  final AppUpdatePromptEntity prompt;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final title = (prompt.title?.trim().isNotEmpty ?? false)
        ? prompt.title!.trim()
        : (prompt.forceUpdate
            ? l10n.dashboardAppUpdateRequiredTitle
            : l10n.dashboardAppUpdateAvailableTitle);
    final message = (prompt.message?.trim().isNotEmpty ?? false)
        ? prompt.message!.trim()
        : (prompt.forceUpdate
            ? l10n.dashboardAppUpdateRequiredMessage
            : l10n.dashboardAppUpdateAvailableMessage);

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.clrWhite,
          borderRadius: BorderRadius.circular(18.r),
        ),
        padding: EdgeInsets.fromLTRB(20.w, 24.h, 20.w, 24.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64.r,
              height: 64.r,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.clrE8F8F5,
                border: Border.all(color: AppColors.clrD7ECE7),
              ),
              child: Icon(
                Icons.system_update_rounded,
                color: AppColors.clr40AFA2,
                size: 30.r,
              ),
            ),
            SizedBox(height: 18.h),
            Text(
              title,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleLarge?.copyWith(
                color: AppColors.clr0E2D55,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 10.h),
            Text(
              message,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppColors.clr4B5563,
                height: 1.4,
              ),
            ),
            SizedBox(height: 24.h),
            AppButton.primary(
              text: l10n.dashboardAppUpdateCta,
              onPressed: () => AppUrlLauncher.open(
                url: prompt.storeUrl,
                lunchMode: LaunchMode.externalApplication,
              ),
              backgroundColor: AppColors.clr40AFA2,
              foregroundColor: AppColors.clrWhite,
              height: 50.h,
              borderRadius: 12.r,
              fontWeight: FontWeight.w700,
              width: double.infinity,
            ),
            if (!prompt.forceUpdate) ...[
              SizedBox(height: 10.h),
              SizedBox(
                width: double.infinity,
                height: 48.h,
                child: TextButton(
                  onPressed: () => context.pop(),
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.clr0E2D55,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  child: Text(
                    l10n.dashboardAppUpdateLater,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.clr0E2D55,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
