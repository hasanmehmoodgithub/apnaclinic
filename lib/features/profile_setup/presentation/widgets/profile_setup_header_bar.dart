import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/preference/app_pref.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/di/dependency_injection.dart';

class ProfileSetupHeaderBar extends StatelessWidget {
  const ProfileSetupHeaderBar({super.key, required this.topInset});

  final double topInset;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final isProfileCompleted = sl<AppPref>().isProfileCompleted();
    final title = isProfileCompleted ? l10n.profileTitle : 'Profile Setup';
    return SizedBox(
      height: topInset + 48.h,
      child: Padding(
        padding: EdgeInsets.only(top: topInset + 4.h),
        child: Row(
          children: [
            Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(20.r),
                onTap: () {
                  if (context.canPop()) {
                    context.pop();
                  } else {
                    context.go(AppRoutes.path(AppRoutes.authLogin));
                  }
                },
                child: SizedBox(
                  width: 40.r,
                  height: 40.r,
                  child: Center(
                    child: Icon(
                      Icons.arrow_back_rounded,
                      color: const Color(0xFF061E40),
                      size: 22.r,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.only(right: 40.w),
                  child: Text(
                    title,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF061E40),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
