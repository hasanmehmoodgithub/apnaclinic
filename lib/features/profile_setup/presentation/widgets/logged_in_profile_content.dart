import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../account/domain/entities/account_item_entity.dart';
import '../../../account/domain/models/account_method.dart';
import 'profile_account_tiles.dart';
import 'profile_info_tiles.dart';

class LoggedInProfileContent extends StatelessWidget {
  const LoggedInProfileContent({
    super.key,
    required this.fullName,
    required this.phone,
    required this.gender,
    required this.dob,
    required this.email,
    required this.accounts,
    required this.accountDetails,
    required this.isAccountDetailsLoading,
    required this.accountDetailsError,
    required this.onDeleteAccountDetailTap,
    required this.onAccountTap,
    required this.onEditTap,
    required this.onAddAccountTap,
    required this.onDeleteAccountTap,
  });

  final String fullName;
  final String phone;
  final String gender;
  final String dob;
  final String email;
  final List<AccountMethod> accounts;
  final List<AccountItemEntity> accountDetails;
  final bool isAccountDetailsLoading;
  final String? accountDetailsError;
  final void Function(int index, AccountItemEntity item) onDeleteAccountDetailTap;
  final VoidCallback onAccountTap;
  final VoidCallback onEditTap;
  final VoidCallback onAddAccountTap;
  final void Function(int index, AccountMethod account) onDeleteAccountTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: ListView(

        children: [
          SizedBox(height: 28.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      fullName.isEmpty ? l10n.profileGuestUserTitle : fullName,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        color: AppColors.clr1A2A4A,
                        fontWeight: FontWeight.w500,
                        fontSize: (38 / 1.6).sp,
                        height: 1,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      phone.isEmpty ? '--' : phone,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: AppColors.clr7A8594,
                        fontSize: 16.sp,
                        height: 1,
                      ),
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: onEditTap,
                borderRadius: BorderRadius.circular(18.r),
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 2.h),
                  child: Row(
                    children: [
                      Container(
                        width: 16.r,
                        height: 16.r,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.clrE4E7EB,
                          border: Border.all(
                            color: AppColors.clrC2C9D2,
                          ),
                        ),
                        child: Icon(
                          Icons.edit_rounded,
                          size: 10.r,
                          color: AppColors.clr7B8794,
                        ),
                      ),
                      SizedBox(width: 6.w),
                      Text(
                        l10n.profileEditCta,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: AppColors.clr3D4C63,
                          fontSize: (22 / 1.6).sp,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          InfoTilesRow(
            gender: gender,
            dob: dob,
            email: email,
          ),
          SizedBox(height: 14.h),
          Text(
            l10n.profileAccountDetailsTitle,
            style: theme.textTheme.titleMedium?.copyWith(
              color: AppColors.clr2D2D2D,
              fontWeight: FontWeight.w500,
              fontSize: (16 / 1.05).sp,
            ),
          ),
          SizedBox(height: 8.h),
          if (isAccountDetailsLoading)
            const ProfileAccountDetailsShimmerWidget()
          else if (accountDetailsError != null)
            Padding(
              padding: EdgeInsets.only(bottom: 8.h),
              child: Text(
                accountDetailsError!,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: AppColors.clrC62828,
                ),
              ),
            )
          else if (accountDetails.isEmpty)
            Padding(
              padding: EdgeInsets.only(bottom: 8.h),
              child: Text(
                l10n.accountNoAccountsMessage,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: AppColors.clr7A91AE,
                ),
              ),
            )
          else
            ...accountDetails.asMap().entries.map(
              (entry) => Padding(
                padding: EdgeInsets.only(bottom: 8.h),
                child: AccountTile(
                  account: AccountMethod(
                    bankName: l10n.accountMethodJazzCash,
                    accountHolderName: l10n.accountHolderFallback,
                    accountNumber: entry.value.number,
                    isDefault: entry.value.isDefault,
                  ),
                  onTap: () {},
                  onDelete: entry.value.isDefault
                      ? null
                      : () => onDeleteAccountDetailTap(entry.key, entry.value),
                ),
              ),
            ),
          AddAccountTile(onTap: onAddAccountTap),
        ],
      ),
    );
  }
}
