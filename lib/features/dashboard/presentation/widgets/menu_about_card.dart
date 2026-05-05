import 'package:apnaclinic/core/extensions/screen_util_extensions.dart';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/l10n/app_localizations.dart';

class MenuAboutItemData {
  const MenuAboutItemData(this.title, {this.subtitle, this.onTap});

  final String title;
  final String? subtitle;
  final VoidCallback? onTap;
}

class MenuAboutCard extends StatelessWidget {
  const MenuAboutCard({
    super.key,
    required this.items,
    this.onAboutTap,
  });

  final List<MenuAboutItemData> items;
  final VoidCallback? onAboutTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(3.r),
        boxShadow: [
          BoxShadow(
            color: const Color.fromRGBO(5, 52, 83, 0.12),
            blurRadius: 64.2.r,
            offset: Offset(0, 14.h),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: onAboutTap,
            child: Padding(
              padding: EdgeInsets.fromLTRB(24.w, 18.6.h, 24.w, 18.6.h),
              child: Text(
                l10n.dashboardMenuAbout,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.clr111827,
                  fontSize: 16.sp,
                ),
              ),
            ),
          ),
          for (int i = 0; i < items.length; i++) ...[
            const Divider(
              height: 1,
              color: AppColors.clr9BA6A7,
              thickness: 0.3,
            ),
            InkWell(
              onTap: items[i].onTap,
              child: Padding(
                padding: EdgeInsets.fromLTRB(24.w, 14.h, 24.w, 14.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      items[i].title,
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: AppColors.clr111827,
                        fontWeight: FontWeight.w500,
                        fontSize: 14.sp,
                      ),
                    ),
                    if (items[i].subtitle != null) ...[
                      SizedBox(height: 7.h),
                      Text(
                        items[i].subtitle!,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: AppColors.clr454545,
                          fontSize: 12.sp,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
