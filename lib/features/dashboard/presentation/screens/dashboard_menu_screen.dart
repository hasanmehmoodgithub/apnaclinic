import 'package:flutter/material.dart';

class DashboardMenuScreen extends StatelessWidget {
  const DashboardMenuScreen({super.key});

  static const List<_MenuItem> _items = [
    _MenuItem('My Appointments', Icons.calendar_month_rounded),
    _MenuItem('Medical Records', Icons.folder_copy_rounded),
    _MenuItem('Family Profiles', Icons.groups_rounded),
    _MenuItem('Insurance', Icons.health_and_safety_rounded),
    _MenuItem('Payments', Icons.account_balance_wallet_rounded),
    _MenuItem('Settings', Icons.settings_rounded),
    _MenuItem('Help Center', Icons.support_agent_rounded),
    _MenuItem('Logout', Icons.logout_rounded, isDanger: true),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAF9),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 6, 20, 8),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.arrow_back_rounded),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Menu',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF111827),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 6),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                itemCount: _items.length,
                separatorBuilder: (_, _) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final item = _items[index];
                  final color = item.isDanger
                      ? const Color(0xFFDC2626)
                      : const Color(0xFF111827);
                  return Material(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(14),
                      onTap: () {},
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 14,
                        ),
                        child: Row(
                          children: [
                            Icon(item.icon, color: color, size: 22),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                item.title,
                                style: theme.textTheme.titleMedium?.copyWith(
                                  color: color,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            Icon(
                              Icons.chevron_right_rounded,
                              color: color.withValues(alpha: 0.65),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MenuItem {
  const _MenuItem(this.title, this.icon, {this.isDanger = false});

  final String title;
  final IconData icon;
  final bool isDanger;
}
