import 'package:apnaclinic/core/extensions/screen_util_extensions.dart';
import 'package:apnaclinic/core/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';

class MenuHeader extends StatelessWidget {
  const MenuHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.fromLTRB(6.w, 6.h, 16.w, 12.h),
      child: Row(
        children: [
          IconButton(
            onPressed: () => context.pop(),
            icon: const Icon(
              Icons.arrow_back_rounded,
              color: AppColors.clr08294D,
            ),
          ),
          Expanded(
            child: Text(
              l10n.dashboardMenuTitle,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleLarge?.copyWith(
                color: AppColors.clr0E2D55,
                fontWeight: FontWeight.w700,
                fontSize: (32 / 1.6).sp,
              ),
            ),
          ),
          SizedBox(width: 44.w),
        ],
      ),
    );
  }
}
