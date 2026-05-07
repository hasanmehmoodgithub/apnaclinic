import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../domain/entities/account_item_entity.dart';

class AccountDetailsItemCardWidget extends StatelessWidget {
  const AccountDetailsItemCardWidget({
    super.key,
    required this.item,
  });

  final AccountItemEntity item;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    return Container(
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: AppColors.clrWhite,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: AppColors.clrE4E7EB),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${l10n.accountIdLabel}: ${item.id}',
            style: theme.textTheme.titleMedium?.copyWith(
              color: AppColors.clr060,
              fontWeight: FontWeight.w600,
              fontSize: 15.sp,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            '${l10n.accountNumberShortLabel}: ${item.number}',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: AppColors.clr5D758F,
              fontSize: 14.sp,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            '${l10n.accountDefaultLabel}: ${item.isDefault ? l10n.commonYes : l10n.commonNo}',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: item.isDefault ? AppColors.clr0FAA9A : AppColors.clr8A9AAE,
              fontWeight: FontWeight.w500,
              fontSize: 13.sp,
            ),
          ),
        ],
      ),
    );
  }
}
