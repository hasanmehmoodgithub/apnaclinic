import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/dependency_injection.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/preference/app_pref.dart';
import '../../../../core/router/app_routes.dart';
import '../../../account/data/account_local_store.dart';
import '../../../account/domain/models/account_method.dart';
import '../widgets/guest_profile_content.dart';
import '../widgets/logged_in_profile_content.dart';
import '../widgets/profile_avatar_section.dart';
import '../widgets/profile_header_bar.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({
    super.key,
    this.showBackButton = true,
    this.onBack,
  });

  final bool showBackButton;
  final VoidCallback? onBack;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late final AppPref _appPref;
  late final AccountLocalStore _accountStore;

  @override
  void initState() {
    super.initState();
    _appPref = sl<AppPref>();
    _accountStore = AccountLocalStore(_appPref);
  }

  @override
  Widget build(BuildContext context) {
    final isLoggedIn = _appPref.getLoginStatus();
    final firstName = (_appPref.getString('profile_first_name') ?? '').trim();
    final lastName = (_appPref.getString('profile_last_name') ?? '').trim();
    final fullName = '$firstName $lastName'.trim();
    final phone = (_appPref.getString('profile_phone') ?? '').trim();
    final accounts = _accountStore.getAccounts();
    final gender = (_appPref.getString('profile_gender') ?? '').trim();
    final email = (_appPref.getString('profile_email') ?? '').trim();
    final dobIso = (_appPref.getString('profile_dob') ?? '').trim();
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
            ProfileHeaderBar(
              showBackButton: widget.showBackButton,
              onBack: widget.onBack ?? () => Navigator.of(context).maybePop(),
            ),
            SizedBox(height: 10.h),
            const ProfileAvatarSection(),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Color(0xFFFFFFFF),
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(42.r)),
                ),
                child: isLoggedIn
                    ? LoggedInProfileContent(
                        fullName: fullName,
                        phone: phone,
                        gender: gender.isEmpty ? '--' : gender,
                        dob: dobLabel.isEmpty ? '--' : dobLabel,
                        email: email.isEmpty ? '--' : email,
                        accounts: accounts,
                        onAccountTap: () =>
                            context.push(AppRoutes.path(AppRoutes.accountDetails)),
                        onAddAccountTap: () async {
                          await context.push(AppRoutes.path(AppRoutes.addAccount));
                          if (mounted) setState(() {});
                        },
                        onDeleteAccountTap: _onDeleteAccountTap,
                      )
                    : GuestProfileContent(
                        onLoginTap: () =>
                            context.push(AppRoutes.path(AppRoutes.authLogin)),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _onDeleteAccountTap(int index, AccountMethod account) async {
    final shouldDelete = await _showRemoveAccountDialog(account);
    if (shouldDelete != true || !mounted) return;
    await _accountStore.deleteAccount(index);
    if (mounted) {
      setState(() {});
    }
  }

  Future<bool?> _showRemoveAccountDialog(AccountMethod account) {
    final theme = Theme.of(context);
    return showDialog<bool>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.35),
      builder: (context) {
        return Dialog(
          insetPadding: EdgeInsets.symmetric(horizontal: 16.w),
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.r),
          ),
          child: Padding(
            padding: EdgeInsets.fromLTRB(20.w, 24.h, 20.w, 22.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 58.r,
                  height: 58.r,
                  decoration: const BoxDecoration(
                    color: Color(0xFFC9252C),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.delete_outline_rounded,
                    color: Colors.white,
                    size: 30.r,
                  ),
                ),
                SizedBox(height: 18.h),
                Text(
                  'Remove Account',
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: const Color(0xFF102A56),
                    fontWeight: FontWeight.w500,
                    fontSize: 18.sp,
                  ),
                ),
                SizedBox(height: 10.h),
                Text(
                  'Are you sure you want to remove ${account.bankName} account ${account.accountNumber} ?',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: const Color(0xFF6C7EA0),
                    height: 1.3,
                  ),
                ),
                SizedBox(height: 22.h),
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 56.h,
                        child: FilledButton(
                          onPressed: () => Navigator.of(context).pop(true),
                          style: FilledButton.styleFrom(
                            backgroundColor: const Color(0xFFC9252C),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                          ),
                          child: Text(
                            'Remove',
                            style: theme.textTheme.titleSmall?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: SizedBox(
                        height: 56.h,
                        child: OutlinedButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Color(0xFFB7C0CC)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                          ),
                          child: Text(
                            'Cancel',
                            style: theme.textTheme.titleSmall?.copyWith(
                              color: const Color(0xFF4B5668),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
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
