import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/dependency_injection.dart';
import '../../../../core/preference/app_pref.dart';
import '../../../../core/router/app_routes.dart';

class DashboardMenuScreen extends StatelessWidget {
  const DashboardMenuScreen({super.key});

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
              padding: const EdgeInsets.fromLTRB(6, 6, 16, 12),
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
                        fontSize: 32 / 1.6,
                      ),
                    ),
                  ),
                  const SizedBox(width: 44),
                ],
              ),
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Color(0xFFF4F6F8),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(42)),
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: ListView(
                        padding: const EdgeInsets.fromLTRB(22, 22, 22, 18),
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
                          const SizedBox(height: 14),
                          for (final item in _mainItems) ...[
                            _MenuTile(item: item, theme: theme, onTap: () {}),
                            const SizedBox(height: 14),
                          ],
                          _AboutCard(theme: theme, items: _aboutItems),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(29, 0, 29, 11),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF40AFA2),
                            foregroundColor: Colors.white,
                            elevation: 0,
                            minimumSize: const Size.fromHeight(62),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(13),
                            ),
                          ),
                          child: Text(
                            'Logout',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              fontSize: 18,
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
      borderRadius: BorderRadius.circular(16),
      child: SizedBox(
        height: 96,
        child: Stack(
          children: [
            const Positioned.fill(
              child: ColoredBox(color: Color(0xFFECEDEF)),
            ),
            Positioned(
              right: -94,
              top: -29,
              child: IgnorePointer(
                child: Container(
                  width: 294,
                  height: 281,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFFE8E7F1),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(28, 25, 16, 24),
              child: Row(
                children: [
                  Container(
                    width: 46.08,
                    height: 46.08,
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
                  const SizedBox(width: 7),
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
                            fontSize: 20,
                            height: 1,
                          ),
                        ),
                        const SizedBox(height: 7),
                        Text(
                          phone,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: const Color(0xFF4A4A4A),
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            height: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  OutlinedButton(
                    onPressed: onActionTap,
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFF9BA6A7), width: 0.8),
                      foregroundColor: const Color(0xFF0E2D55),
                      minimumSize: const Size(92, 30),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(22),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.5,
                        vertical: 9,
                      ),
                      backgroundColor: Colors.transparent,
                    ),
                    child: Text(
                      isLoggedIn ? 'Edit Profile' : 'Login / Signup',
                      style: theme.textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                        color: const Color(0xFF0E2D55),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
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
      borderRadius: BorderRadius.circular(14),
      child: SizedBox(
        height: 96,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final curveWidth = constraints.maxWidth * 0.7606; // Figma ratio
            final curveHeight = 281.37;
            final curveLeft = constraints.maxWidth * 0.6493; // Figma ratio

            return Stack(
              children: [
                const Positioned.fill(
                  child: ColoredBox(color: Colors.white),
                ),
                Positioned(
                  left: curveLeft,
                  top: -28.78,
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
                  padding: const EdgeInsets.fromLTRB(28, 25, 28, 25),
                  child: Row(
                    children: [
                      Container(
                        width: 46.07,
                        height: 46.14,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.black.withValues(alpha: 0.21),
                            width: 0.33,
                          ),
                        ),
                        child: Icon(
                          item.icon,
                          size: 24,
                          color: const Color(0xFF303D4F),
                        ),
                      ),
                      const SizedBox(width: 7),
                      Expanded(
                        child: Text(
                          item.title,
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: const Color(0xFF111827),
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: onTap,
                        borderRadius: BorderRadius.circular(16),
                        child: Container(
                          width: 25.66,
                          height: 25.33,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: const Color(0xFF6E7A88),
                              width: 0.8,
                            ),
                          ),
                          child: const Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 12,
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
        borderRadius: BorderRadius.circular(3),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(5, 52, 83, 0.12),
            blurRadius: 64.2,
            offset: Offset(0, 14),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 18.6, 24, 18.6),
            child: Text(
              'About',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: const Color(0xFF111827),
                fontSize: 16,
              ),
            ),
          ),
          for (int i = 0; i < items.length; i++) ...[
            const Divider(height: 1, color: Color(0xFF9BA6A7), thickness: 0.3),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 14, 24, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    items[i].title,
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: const Color(0xFF111827),
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                  if (items[i].subtitle != null) ...[
                    const SizedBox(height: 7),
                    Text(
                      items[i].subtitle!,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: const Color(0xFF454545),
                        fontSize: 12,
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
