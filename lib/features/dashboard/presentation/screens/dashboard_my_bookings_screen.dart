import 'package:flutter/material.dart';

class DashboardMyBookingsScreen extends StatelessWidget {
  const DashboardMyBookingsScreen({super.key});

  static const List<String> _tabs = [
    'Doctor Consultation',
    'Surgery',
    'Lab Test',
    'Pharmacy',
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return DefaultTabController(
      length: _tabs.length,
      child: Scaffold(
        backgroundColor: const Color(0xFFD5FFFB),
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 6, 16, 12),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.of(context).maybePop(),
                      icon: const Icon(
                        Icons.arrow_back_rounded,
                        color: Color(0xFF061E40),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'My Bookings',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.titleLarge?.copyWith(
                          color: const Color(0xFF061E40),
                          fontWeight: FontWeight.w700,
                          fontSize: 20,
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
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(42)),
                  ),
                  child: Column(
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Color(0xFF9BA6A7),
                              width: 0.3,
                            ),
                          ),
                        ),
                        child: TabBar(
                          isScrollable: true,
                          tabAlignment: TabAlignment.start,
                          labelPadding: const EdgeInsets.symmetric(horizontal: 14),
                          indicatorSize: TabBarIndicatorSize.label,
                          indicatorWeight: 2,
                          indicatorColor: const Color(0xFF061E40),
                          dividerColor: Colors.transparent,
                          labelColor: const Color(0xFF061E40),
                          unselectedLabelColor: const Color(0xFF667B99),
                          labelStyle: theme.textTheme.bodyMedium?.copyWith(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                          unselectedLabelStyle:
                              theme.textTheme.bodyMedium?.copyWith(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                          tabs: [for (final tab in _tabs) Tab(text: tab)],
                        ),
                      ),
                      const Expanded(
                        child: TabBarView(
                          physics: BouncingScrollPhysics(),
                          children: [
                            SizedBox.shrink(),
                            SizedBox.shrink(),
                            SizedBox.shrink(),
                            SizedBox.shrink(),
                          ],
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
    );
  }
}
