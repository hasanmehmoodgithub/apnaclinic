import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/dependency_injection.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/preference/app_pref.dart';
import '../../../../core/router/app_routes.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  static const List<_MenuItem> _mainItems = [
    _MenuItem('My Bookings', Icons.calendar_month_outlined),
    _MenuItem('Customer Support', Icons.headset_mic_outlined),
    _MenuItem("FAQ’s", Icons.help_outline_rounded),
  ];

  static const List<_AboutItem> _aboutItems = [
    _AboutItem('App Version', subtitle: '1.0'),
    _AboutItem('Terms & Condition'),
    _AboutItem('Privacy Policy'),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appPref = sl<AppPref>();
    final isLoggedIn = appPref.getLoginStatus();
    final firstName = (appPref.getString('profile_first_name') ?? '').trim();
    final lastName = (appPref.getString('profile_last_name') ?? '').trim();
    final fullName = '$firstName $lastName'.trim();
    final phone = (appPref.getString('profile_phone') ?? '').trim();
    final displayName = fullName.isEmpty ? 'Guest User' : fullName;
    final displayPhone = phone.isEmpty ? 'Sign in to manage your account' : phone;

    return Scaffold(
      backgroundColor: const Color(0xFFC7EFEB),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(6.w, 6.h, 16.w, 12.h),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(
                      Icons.arrow_back_rounded,
                      color: Color(0xFF08294D),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'Menu',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: const Color(0xFF0E2D55),
                        fontWeight: FontWeight.w700,
                        fontSize: (32 / 1.6).sp,
                      ),
                    ),
                  ),
                  SizedBox(width: 44.w),
                ],
              ),
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Color(0xFFF4F6F8),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(42.r)),
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: ListView(
                        padding: EdgeInsets.fromLTRB(22.w, 22.h, 22.w, 18.h),
                        children: [
                          _ProfileCard(
                            theme: theme,
                            isLoggedIn: isLoggedIn,
                            name: isLoggedIn ? displayName : 'Guest User',
                            phone: isLoggedIn
                                ? displayPhone
                                : 'Sign in to continue',
                            onActionTap: () {
                              if (!isLoggedIn) {
                                context.push(AppRoutes.path(AppRoutes.authLogin));
                                return;
                              }
                              // TODO: wire Edit Profile screen when available.
                            },
                          ),
                          SizedBox(height: 14.h),
                          for (final item in _mainItems) ...[
                            _MenuTile(item: item, theme: theme, onTap: () {}),
                            SizedBox(height: 14.h),
                          ],
                          _AboutCard(theme: theme, items: _aboutItems),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(29.w, 0, 29.w, 11.h),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {
                            if (!isLoggedIn) {
                              context.push(AppRoutes.path(AppRoutes.authLogin));
                              return;
                            }
                            await appPref.setLoginStatus(false);
                            await appPref.setProfileCompleted(false);
                            await appPref.setToken('');
                            await appPref.setUserId('');
                            await appPref.remove('profile_first_name');
                            await appPref.remove('profile_last_name');
                            await appPref.remove('profile_phone');
                            await appPref.remove('profile_gender');
                            await appPref.remove('profile_email');
                            await appPref.remove('profile_address');
                            await appPref.remove('profile_dob');
                            if (!context.mounted) return;
                            context.go(AppRoutes.path(AppRoutes.home));
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF40AFA2),
                            foregroundColor: Colors.white,
                            elevation: 0,
                            minimumSize: Size.fromHeight(62.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(13.r),
                            ),
                          ),
                          child: Text(
                            isLoggedIn ? 'Logout' : 'Login',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              fontSize: 18.sp,
                            ),
                          ),
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

class _ProfileCard extends StatelessWidget {
  const _ProfileCard({
    required this.theme,
    required this.isLoggedIn,
    required this.name,
    required this.phone,
    required this.onActionTap,
  });

  final ThemeData theme;
  final bool isLoggedIn;
  final String name;
  final String phone;
  final VoidCallback onActionTap;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16.r),
      child: SizedBox(
        height: 96.h,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final curveWidth = constraints.maxWidth * 0.7606;
            final curveHeight = 281.37.h;
            final curveLeft = constraints.maxWidth * 0.6493;

            return Stack(
              children: [
                const Positioned.fill(
                  child: ColoredBox(color: Colors.white),
                ),
                Positioned(
                  left: curveLeft,
                  top: -28.78.h,
                  child: IgnorePointer(
                    child: Container(
                      width: curveWidth,
                      height: curveHeight,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFFEBDFFF).withValues(alpha: 0.6),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(28.w, 25.h, 16.w, 24.h),
                  child: Row(
                    children: [
                      Container(
                        width: 46.08.r,
                        height: 46.08.r,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFFD1DDFE),
                        ),
                        child: Icon(
                          Icons.person_rounded,
                          color: isLoggedIn
                              ? const Color(0xFF0B77C5)
                              : const Color(0xFF6B7280),
                        ),
                      ),
                      SizedBox(width: 7.w),
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.titleMedium?.copyWith(
                                color: const Color(0xFF0E2D55),
                                fontWeight: FontWeight.w500,
                                fontSize: 20.sp,
                                height: 1,
                              ),
                            ),
                            SizedBox(height: 7.h),
                            Text(
                              phone,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: const Color(0xFF4A4A4A),
                                fontWeight: FontWeight.w400,
                                fontSize: 14.sp,
                                height: 1,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 8.w),
                      OutlinedButton(
                        onPressed: onActionTap,
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(
                            color: Color(0xFF9BA6A7),
                            width: 0.8,
                          ),
                          foregroundColor: const Color(0xFF0E2D55),
                          minimumSize: Size(72.w, 24.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: 10.5.w,
                            vertical: 9.h,
                          ),
                          backgroundColor: Colors.transparent,
                        ),
                        child: Text(
                          isLoggedIn ? 'Edit Profile' : 'Login / Signup',
                          style: theme.textTheme.labelLarge?.copyWith(
                            fontWeight: FontWeight.w500,
                            fontSize: 9.sp,
                            color: const Color(0xFF0E2D55),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _MenuTile extends StatelessWidget {
  const _MenuTile({
    required this.item,
    required this.theme,
    required this.onTap,
  });

  final _MenuItem item;
  final ThemeData theme;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(14.r),
      child: SizedBox(
        height: 96.h,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final curveWidth = constraints.maxWidth * 0.7606; // Figma ratio
            final curveHeight = 281.37.h;
            final curveLeft = constraints.maxWidth * 0.6493; // Figma ratio

            return Stack(
              children: [
                const Positioned.fill(
                  child: ColoredBox(color: Colors.white),
                ),
                Positioned(
                  left: curveLeft,
                  top: -28.78.h,
                  child: IgnorePointer(
                    child: Container(
                      width: curveWidth,
                      height: curveHeight,
                      decoration:  BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFFDDE2EE).withValues(alpha: 0.6),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(28.w, 25.h, 28.w, 25.h),
                  child: Row(
                    children: [
                      Container(
                        width: 46.07.r,
                        height: 46.14.r,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.black.withValues(alpha: 0.21),
                            width: 0.33.r,
                          ),
                        ),
                        child: Icon(
                          item.icon,
                          size: 24.r,
                          color: const Color(0xFF303D4F),
                        ),
                      ),
                      SizedBox(width: 7.w),
                      Expanded(
                        child: Text(
                          item.title,
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: const Color(0xFF111827),
                            fontWeight: FontWeight.w700,
                            fontSize: 16.sp,
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: onTap,
                        borderRadius: BorderRadius.circular(16.r),
                        child: Container(
                          width: 25.66.r,
                          height: 25.33.r,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: const Color(0xFF6E7A88),
                              width: 0.8.r,
                            ),
                          ),
                          child: Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 12.r,
                            color: Color(0xFF6E7A88),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _AboutCard extends StatelessWidget {
  const _AboutCard({required this.theme, required this.items});

  final ThemeData theme;
  final List<_AboutItem> items;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(3.r),
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(5, 52, 83, 0.12),
            blurRadius: 64.2.r,
            offset: Offset(0, 14.h),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(24.w, 18.6.h, 24.w, 18.6.h),
            child: Text(
              'About',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: const Color(0xFF111827),
                fontSize: 16.sp,
              ),
            ),
          ),
          for (int i = 0; i < items.length; i++) ...[
            const Divider(height: 1, color: Color(0xFF9BA6A7), thickness: 0.3),
            Padding(
              padding: EdgeInsets.fromLTRB(24.w, 14.h, 24.w, 14.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    items[i].title,
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: const Color(0xFF111827),
                      fontWeight: FontWeight.w500,
                      fontSize: 14.sp,
                    ),
                  ),
                  if (items[i].subtitle != null) ...[
                    SizedBox(height: 7.h),
                    Text(
                      items[i].subtitle!,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: const Color(0xFF454545),
                        fontSize: 12.sp,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _MenuItem {
  const _MenuItem(this.title, this.icon);

  final String title;
  final IconData icon;
}

class _AboutItem {
  const _AboutItem(this.title, {this.subtitle});

  final String title;
  final String? subtitle;
}
