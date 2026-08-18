import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../account/domain/entities/account_item_entity.dart';
import '../helpers/profile_account_mapper.dart';
import 'profile_account_tiles.dart';

class ProfileAccountDetailsSectionWidget extends StatelessWidget {
  const ProfileAccountDetailsSectionWidget({
    super.key,
    required this.fullName,
    required this.accounts,
    required this.isLoading,
    required this.errorMessage,
    required this.onDeleteAccount,
    required this.onAddAccountTap,
  });

  final String fullName;
  final List<AccountItemEntity> accounts;
  final bool isLoading;
  final String? errorMessage;
  final void Function(int index, AccountItemEntity item) onDeleteAccount;
  final VoidCallback onAddAccountTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.profileAccountDetailsTitle,
          style: theme.textTheme.titleMedium?.copyWith(
            color: AppColors.clr2D2D2D,
            fontWeight: FontWeight.w500,
            fontSize: (16 / 1.05).sp,
          ),
        ),
        SizedBox(height: 8.h),
        if (isLoading)
          const ProfileAccountDetailsShimmerWidget()
        else if (errorMessage != null)
          _SectionMessage(
            message: errorMessage!,
            color: AppColors.clrC62828,
          )
        else if (accounts.isEmpty)
          _SectionMessage(
            message: l10n.accountNoAccountsMessage,
            color: AppColors.clr7A91AE,
          )
        else
          ...accounts.asMap().entries.map(
            (entry) => Padding(
              padding: EdgeInsets.only(bottom: 8.h),
              child: AccountTile(
                account: mapProfileAccountItem(
                  l10n: l10n,
                  item: entry.value,
                  fullName: fullName,
                ),
                onTap: () {},
                onDelete: entry.value.isDefault || entry.value.id.trim().isEmpty
                    ? null
                    : () => onDeleteAccount(entry.key, entry.value),
              ),
            ),
          ),
        AddAccountTile(onTap: onAddAccountTap),
      ],
    );
  }
}

class _SectionMessage extends StatelessWidget {
  const _SectionMessage({
    required this.message,
    required this.color,
  });

  final String message;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Text(
        message,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: color),
      ),
    );
  }
}
