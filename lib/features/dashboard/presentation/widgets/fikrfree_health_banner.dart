import 'dart:io' show Platform;

import 'package:apnaclinic/core/constants/app_colors.dart';
import 'package:apnaclinic/core/l10n/app_localizations.dart';
import 'package:apnaclinic/generated/assets.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/network/app_urls.dart';
import '../../../../core/utils/app_url_launcher.dart';

/// Section title + mint card promoting FikrFree (insurance / health).
class FikrfreeHealthBanner extends StatelessWidget {
  const FikrfreeHealthBanner({super.key, this.onTap});

  /// Optional override. Defaults to opening the FikrFree store listing.
  final VoidCallback? onTap;

  static Future<void> openFikrFreeStore() {
    final url = !kIsWeb && Platform.isIOS
        ? AppUrls.fikrFreeAppStoreIos
        : AppUrls.fikrFreePlayStoreAndroid;
    return AppUrlLauncher.open(
      url: url,
      lunchMode: LaunchMode.externalApplication,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.dashboardSecureHealthTitle,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
            fontSize: 18.sp,
            color: AppColors.clr111827,
          ),
        ),
        SizedBox(height: 12.h),
        Material(
          color: AppColors.clrEAF6F1,
          borderRadius: BorderRadius.circular(14.r),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onTap ?? openFikrFreeStore,
            child: Padding(
              padding: EdgeInsets.fromLTRB(14.w, 24.h, 12.w, 24.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'FikrFree',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            fontSize: 16.sp,
                            color: AppColors.clr09,
                          ),
                        ),
                        SizedBox(height: 6.h),
                        Text(
                          l10n.dashboardFikrfreeTagline,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: AppColors.clr43,
                            fontWeight: FontWeight.w400,
                            fontSize: 13.sp,
                            height: 1.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Image.asset(
                    Assets.imgFikarFree,
                    height: 56.h,
                    fit: BoxFit.contain,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
