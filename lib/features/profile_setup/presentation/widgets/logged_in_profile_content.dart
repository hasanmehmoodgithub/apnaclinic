import 'package:flutter/material.dart';

import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../account/domain/entities/account_item_entity.dart';
import '../models/profile_view_data.dart';
import 'profile_account_details_section_widget.dart';
import 'profile_info_tiles.dart';
import 'profile_user_header_widget.dart';

class LoggedInProfileContent extends StatelessWidget {
  const LoggedInProfileContent({
    super.key,
    required this.viewData,
    required this.accounts,
    required this.isAccountsLoading,
    required this.accountsError,
    required this.onDeleteAccount,
    required this.onEditTap,
    required this.onAddAccountTap,
  });

  final ProfileViewData viewData;
  final List<AccountItemEntity> accounts;
  final bool isAccountsLoading;
  final String? accountsError;
  final void Function(int index, AccountItemEntity item) onDeleteAccount;
  final VoidCallback onEditTap;
  final VoidCallback onAddAccountTap;

  static const EdgeInsets _padding = EdgeInsets.all(18);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: _padding,
      child: ListView(
        children: [
          SizedBox(height: 28.h),
          ProfileUserHeaderWidget(
            fullName: viewData.fullName,
            phone: viewData.phone,
            onEditTap: onEditTap,
          ),
          SizedBox(height: 12.h),
          InfoTilesRow(
            gender: viewData.gender,
            dob: viewData.dob,
            email: viewData.email,
          ),
          SizedBox(height: 14.h),
          ProfileAccountDetailsSectionWidget(
            fullName: viewData.fullName,
            accounts: accounts,
            isLoading: isAccountsLoading,
            errorMessage: accountsError,
            onDeleteAccount: onDeleteAccount,
            onAddAccountTap: onAddAccountTap,
          ),
        ],
      ),
    );
  }
}
