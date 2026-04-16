import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/dependency_injection.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/preference/app_pref.dart';
import '../../../../core/router/app_routes.dart';
import '../../../account/data/account_local_store.dart';
import '../../../account/domain/models/account_method.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({
    super.key,
    this.showBackButton = true,
    this.onBack,
  });

  final bool showBackButton;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLoggedIn = sl<AppPref>().getLoginStatus();
    final appPref = sl<AppPref>();
    final firstName = (appPref.getString('profile_first_name') ?? '').trim();
    final lastName = (appPref.getString('profile_last_name') ?? '').trim();
    final fullName = '$firstName $lastName'.trim();
    final phone = (appPref.getString('profile_phone') ?? '').trim();
    final accounts = AccountLocalStore(appPref).getAccounts();
    final gender = (appPref.getString('profile_gender') ?? '').trim();
    final email = (appPref.getString('profile_email') ?? '').trim();
    final dobIso = (appPref.getString('profile_dob') ?? '').trim();
    final dob = DateTime.tryParse(dobIso);
    final dobLabel = dob == null
        ? ''
        : '${dob.day.toString().padLeft(2, '0')} '
              '${_monthShort(dob.month)} ${dob.year}';

    return Scaffold(
      backgroundColor: const Color(0xFFC7EFEB),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(8.w, 6.h, 16.w, 6.h),
              child: Row(
                children: [
                  showBackButton
                      ? IconButton(
                          onPressed:
                              onBack ?? () => Navigator.of(context).maybePop(),
                          icon: const Icon(
                            Icons.arrow_back_rounded,
                            color: Color(0xFF061E40),
                          ),
                        )
                      : SizedBox(width: 48.w),
                  Expanded(
                    child: Text(
                      'Profile',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: const Color(0xFF061E40),
                        fontWeight: FontWeight.w700,
                        fontSize: 20.sp,
                      ),
                    ),
                  ),
                  SizedBox(width: 48.w),
                ],
              ),
            ),
            Align(
              alignment: const Alignment(0, -0.96),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 126.r,
                    height: 126.r,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 3.r),
                    ),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.person_rounded,
                        size: 68.r,
                        color: Colors.grey
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 4.h),
                    width: 122.w,
                    height: 10.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(99.r),
                      boxShadow: [
                        BoxShadow(
                          color: Color.fromRGBO(79, 109, 138, 0.35),
                          blurRadius: 10.r,
                          spreadRadius: 1.r,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Color(0xFFF4F6F8),
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(42.r)),
                ),
                child: isLoggedIn
                    ? ListView(
                        padding: EdgeInsets.fromLTRB(18.w, 26.h, 18.w, 24.h),
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
                                      style: theme.textTheme.headlineSmall
                                          ?.copyWith(
                                        color: const Color(0xFF1A2A4A),
                                        fontWeight: FontWeight.w500,
                                        fontSize: (38 / 1.6).sp,
                                        height: 1,
                                      ),
                                    ),
                                    SizedBox(height: 2.h),
                                    Text(
                                      phone.isEmpty ? '--' : phone,
                                      style:
                                          theme.textTheme.bodyMedium?.copyWith(
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
                                          color: Color(0xFF7B8794),
                                        ),
                                      ),
                                      SizedBox(width: 6.w),
                                      Text(
                                        'Edit',
                                        style: theme.textTheme.bodyMedium
                                            ?.copyWith(
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
                          _InfoTilesRow(
                            gender: gender.isEmpty ? '--' : gender,
                            dob: dobLabel.isEmpty ? '--' : dobLabel,
                            email: email.isEmpty ? '--' : email,
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
                              child: _AccountTile(
                                account: account,
                                onTap: () => context.push(
                                  AppRoutes.path(AppRoutes.accountDetails),
                                ),
                              ),
                            ),
                          ),
                          _AddAccountTile(
                            onTap: () async {
                              await context.push(AppRoutes.path(AppRoutes.addAccount));
                              if (context.mounted) {
                                (context as Element).markNeedsBuild();
                              }
                            },
                          ),
                        ],
                      )
                    : Column(
                      children: [
                        Padding(
                            padding: EdgeInsets.fromLTRB(16.w, 18.h, 16.w, 0),
                            child: Container(
                              height: 100.h,
                              padding: EdgeInsets.symmetric(
                                horizontal: 8.w,
                                vertical: 10.h,
                              ),

                              child: Row(
                                children: [
                                  Container(
                                    width: 44.r,
                                    height: 44.r,
                                    decoration: const BoxDecoration(
                                      color: Color(0xFFDDE5EF),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.person_rounded,
                                      color: Color(0xFF6B7280),
                                    ),
                                  ),
                                  SizedBox(width: 10.w),
                                  Expanded(
                                    child: Text(
                                      'Guest User',
                                      style: theme.textTheme.headlineSmall?.copyWith(
                                        color: const Color(0xFF1A2A4A),
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16.sp,
                                      ),
                                    ),
                                  ),
                                  OutlinedButton(
                                    onPressed: () => context.push(
                                      AppRoutes.path(AppRoutes.authLogin),
                                    ),
                                    style: OutlinedButton.styleFrom(
                                      minimumSize: Size(0, 40.h),
                                      side: const BorderSide(
                                        color: Color(0xFF8C949C),
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(22.r),
                                      ),
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 18.w,
                                      ),
                                    ),
                                    child: Text(
                                      'Sign Up / Login',
                                      style: theme.textTheme.titleMedium?.copyWith(
                                        color: const Color(0xFF3A4557),
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14.sp,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoTilesRow extends StatelessWidget {
  const _InfoTilesRow({
    required this.gender,
    required this.dob,
    required this.email,
  });

  final String gender;
  final String dob;
  final String email;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _InfoTile(title: 'Gender', value: gender),
        ),
        SizedBox(width: 6.w),
        Expanded(
          child: _InfoTile(title: 'Date of Birth', value: dob),
        ),
        SizedBox(width: 6.w),
        Expanded(
          child: _InfoTile(title: 'Email', value: email),
        ),
      ],
    );
  }
}

String _monthShort(int month) {
  const names = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];
  return names[(month - 1).clamp(0, 11)];
}

class _InfoTile extends StatelessWidget {
  const _InfoTile({required this.title, required this.value});

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      constraints: BoxConstraints(minHeight: 52.h),
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4.r),
        border: Border.all(color: const Color(0xFFC9CFD7), width: 0.8.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodySmall?.copyWith(
              color: const Color(0xFF7A91AE),
              fontSize: (12 / 1.05).sp,
            ),
          ),
          SizedBox(height: 3.h),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.titleMedium?.copyWith(
              color: const Color(0xFF2B2C58),
              fontWeight: FontWeight.w500,
              fontSize: (26 / 1.6).sp,
              height: 1,
            ),
          ),
        ],
      ),
    );
  }
}

class _AccountTile extends StatelessWidget {
  const _AccountTile({
    required this.account,
    required this.onTap,
  });

  final AccountMethod account;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6.r),
      child: Container(
        height: 56.h,
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        decoration: BoxDecoration(
          color: const Color(0xFFF3F3F3),
          borderRadius: BorderRadius.circular(6.r),
          border: Border.all(
            color: const Color(0xFFD4D9E1),
            width: 0.6.r,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Mobile Bank/${account.bankName}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: const Color(0xFF7B8794),
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    account.accountNumber,
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: const Color(0xFF2C2F5A),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            if (account.isDefault)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: const Color(0xFFD4D9E1)),
                ),
                child: Text(
                  'Default',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: const Color(0xFF7B8794),
                  ),
                ),
              )
            else
              Container(
                width: 28.r,
                height: 28.r,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFFC6CCD5)),
                ),
                child: Icon(
                  Icons.content_copy_rounded,
                  size: 14.r,
                  color: const Color(0xFF2C2F5A),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _AddAccountTile extends StatelessWidget {
  const _AddAccountTile({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6.r),
      child: Container(
        height: 56.h,
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        decoration: BoxDecoration(
          color: const Color(0xFFF3F3F3),
          borderRadius: BorderRadius.circular(6.r),
          border: Border.all(
            color: const Color(0xFFD4D9E1),
            width: 0.6.r,
          ),
        ),
        child: Row(
          children: [
            Text(
              'Add Account',
              style: theme.textTheme.titleSmall?.copyWith(
                color: const Color(0xFF2C2F5A),
                fontWeight: FontWeight.w500,
              ),
            ),
            const Spacer(),
            Container(
              width: 40.r,
              height: 40.r,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color(0xFFC6CCD5),
                ),
              ),
              child: const Icon(
                Icons.add,
                color: Color(0xFF2C2F5A),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
