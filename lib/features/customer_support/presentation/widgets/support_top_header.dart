import 'package:apnaclinic/core/extensions/screen_util_extensions.dart';
import 'package:apnaclinic/core/constants/app_colors.dart';
import 'package:apnaclinic/core/l10n/app_localizations.dart';
import 'package:apnaclinic/generated/assets.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';

class SupportTopHeader extends StatelessWidget {
  const SupportTopHeader({
    super.key,
    required this.showBackButton,
    required this.onBack,
  });

  final bool showBackButton;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.clrC8EEF2,
            AppColors.clrE2F5F7,
            AppColors.clrF0FAFB,
          ],
          stops: [0.0, 0.55, 1.0],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            SizedBox(
              height: 50.h,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: showBackButton
                        ? IconButton(
                            onPressed:
                                onBack ??
                                () {
                                  if (context.canPop()) context.pop();
                                },
                            icon: const Icon(Icons.arrow_back_rounded),
                            color: AppColors.clr060,
                          )
                        : SizedBox(width: 48.w),
                  ),
                  Text(
                    l10n.customerSupportTitle,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppColors.clr060,
                      fontSize: 20.sp,
                      height: 1.2,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.fromLTRB(24.w, 4.h, 24.w, 8.h),
                child: Image.asset(
                  Assets.supportSupportHero,
                  fit: BoxFit.contain,
                  alignment: Alignment.bottomCenter,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
