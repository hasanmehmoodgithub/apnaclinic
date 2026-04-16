import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/dependency_injection.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/preference/app_pref.dart';
import '../../../../core/router/app_routes.dart';
import '../../../account/data/account_local_store.dart';
import '../widgets/guest_profile_content.dart';
import '../widgets/logged_in_profile_content.dart';
import '../widgets/profile_avatar_section.dart';
import '../widgets/profile_header_bar.dart';

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
            ProfileHeaderBar(
              showBackButton: showBackButton,
              onBack: onBack ?? () => Navigator.of(context).maybePop(),
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
                          if (context.mounted) {
                            (context as Element).markNeedsBuild();
                          }
                        },
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
