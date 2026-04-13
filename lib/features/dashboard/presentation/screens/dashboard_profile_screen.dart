import 'package:flutter/material.dart';

class DashboardProfileScreen extends StatelessWidget {
  const DashboardProfileScreen({super.key});

  static const List<_ProfileRowItem> _items = [
    _ProfileRowItem('Personal Information', Icons.person_outline_rounded),
    _ProfileRowItem('Medical History', Icons.folder_open_rounded),
    _ProfileRowItem('Addresses', Icons.location_on_outlined),
    _ProfileRowItem('Payment Methods', Icons.account_balance_wallet_outlined),
    _ProfileRowItem('Security', Icons.shield_outlined),
    _ProfileRowItem('Language', Icons.language_rounded),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFC7EFEB),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 6, 16, 12),
              child: Row(
                children: [
                  const SizedBox(width: 48),
                  Expanded(
                    child: Text(
                      'Profile',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: const Color(0xFF061E40),
                        fontWeight: FontWeight.w700,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  const SizedBox(width: 48),
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
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(22, 22, 22, 24),
                  children: [
                    _ProfileHeaderCard(theme: theme),
                    const SizedBox(height: 16),
                    DecoratedBox(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Column(
                        children: [
                          for (int i = 0; i < _items.length; i++) ...[
                            _ProfileRow(item: _items[i]),
                            if (i != _items.length - 1)
                              const Divider(
                                height: 1,
                                indent: 54,
                                endIndent: 12,
                                color: Color(0xFFE4E7EB),
                              ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),
                    OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size.fromHeight(52),
                        side: const BorderSide(color: Color(0xFFD5DCE4)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Logout',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: const Color(0xFFDC2626),
                          fontWeight: FontWeight.w700,
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

class _ProfileHeaderCard extends StatelessWidget {
  const _ProfileHeaderCard({required this.theme});

  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
            color: const Color(0xFFECEDEF),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 28,
                  backgroundColor: Color(0xFFD1DDFE),
                  child: Icon(
                    Icons.person_rounded,
                    color: Color(0xFF0B77C5),
                    size: 30,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Haseeb Qasim',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: const Color(0xFF1E2B44),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'haseeb.qasim@email.com',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: const Color(0xFF5F6D7A),
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.edit_rounded, color: Color(0xFF0E2D55)),
                ),
              ],
            ),
          ),
          Positioned(
            right: -85,
            top: -34,
            child: Container(
              width: 250,
              height: 220,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFFE8E7F1),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileRow extends StatelessWidget {
  const _ProfileRow({required this.item});

  final _ProfileRowItem item;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        child: Row(
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: const Color(0xFFEEF7F5),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(item.icon, size: 20, color: const Color(0xFF0E2D55)),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                item.title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: const Color(0xFF111827),
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              color: Color(0xFF8793A1),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileRowItem {
  const _ProfileRowItem(this.title, this.icon);

  final String title;
  final IconData icon;
}
