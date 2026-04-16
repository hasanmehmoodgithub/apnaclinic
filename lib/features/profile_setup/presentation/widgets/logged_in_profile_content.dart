import 'package:flutter/material.dart';

import '../../../../core/extensions/screen_util_extensions.dart';
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
    required this.onAccountTap,
    required this.onAddAccountTap,
  });

  final String fullName;
  final String phone;
  final String gender;
  final String dob;
  final String email;
  final List<AccountMethod> accounts;
  final VoidCallback onAccountTap;
  final VoidCallback onAddAccountTap;

  @override
  Widget build(BuildContext context) {
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
                      fullName.isEmpty ? 'User' : fullName,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        color: const Color(0xFF1A2A4A),
                        fontWeight: FontWeight.w500,
                        fontSize: (38 / 1.6).sp,
                        height: 1,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      phone.isEmpty ? '--' : phone,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: const Color(0xFF7A8594),
                        fontSize: 16.sp,
                        height: 1,
                      ),
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: () {},
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
                          color: const Color(0xFFE4E7EB),
                          border: Border.all(
                            color: const Color(0xFFC2C9D2),
                          ),
                        ),
                        child: Icon(
                          Icons.edit_rounded,
                          size: 10.r,
                          color: const Color(0xFF7B8794),
                        ),
                      ),
                      SizedBox(width: 6.w),
                      Text(
                        'Edit',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: const Color(0xFF3D4C63),
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
            'Account Details',
            style: theme.textTheme.titleMedium?.copyWith(
              color: const Color(0xFF2D2D2D),
              fontWeight: FontWeight.w500,
              fontSize: (16 / 1.05).sp,
            ),
          ),
          SizedBox(height: 8.h),
          ...accounts.map(
            (account) => Padding(
              padding: EdgeInsets.only(bottom: 8.h),
              child: AccountTile(
                account: account,
                onTap: onAccountTap,
              ),
            ),
          ),
          AddAccountTile(onTap: onAddAccountTap),
        ],
      ),
    );
  }
}
