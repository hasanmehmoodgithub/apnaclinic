import 'package:flutter/material.dart';
import '../../../../core/extensions/screen_util_extensions.dart';

class NotifcationScreen extends StatelessWidget {
  const NotifcationScreen({super.key});

  static const List<_NotificationSection> _sections = [
    _NotificationSection(
      title: 'Today, 16 April',
      items: [
        _NotificationItem(
          title: 'Dont forget your cart',
          message:
              "Don't forget! Your cart is still waiting. Order now to avoid delays in delivery.",
          time: '4:56 pm',
          icon: Icons.shopping_bag_outlined,
        ),
        _NotificationItem(
          title: 'Order Placed!',
          message: 'Your order has been placed succesfully',
          time: '4:56 pm',
          icon: Icons.shopping_bag_outlined,
        ),
      ],
    ),
    _NotificationSection(
      title: 'Yesterday, 15 April',
      items: [
        _NotificationItem(
          title: 'Payment Due.',
          message:
              'Please complete the payment for your Corneal Transplant (Keratoplasty) surgery today to secure your booking.',
          time: '4:56 pm',
          icon: Icons.local_offer_outlined,
        ),
        _NotificationItem(
          title: 'Your Test Results Are Ready!',
          message:
              'Your Blood CP results are ready. You can view them in the Lab Tests section of the app.',
          time: '4:56 pm',
          icon: Icons.biotech_outlined,
        ),
      ],
    ),
    _NotificationSection(
      title: '16 April',
      items: [
        _NotificationItem(
          title: 'Appointment Confirmed with Dr. Arham',
          message:
              'your appointment with Dr. Arham has been booked for 24th march at 9:00 AM.',
          time: '4:56 pm',
          icon: Icons.calendar_month_outlined,
        ),
      ],
    ),
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
              padding: EdgeInsets.fromLTRB(8.w, 6.h, 14.w, 14.h),
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
                      'Notifications',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: const Color(0xFF0E2D55),
                        fontWeight: FontWeight.w700,
                        fontSize: (31 / 1.6).sp,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.more_horiz, color: Color(0xFF08294D)),
                  ),
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
                child: ListView(
                  padding: EdgeInsets.only(top: 10.h, bottom: 16.h),
                  children: [
                    for (final section in _sections) ...[
                      Padding(
                        padding: EdgeInsets.fromLTRB(23.w, 16.h, 23.w, 8.h),
                        child: Text(
                          section.title,
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: const Color(0xFF0E2D55),
                            fontWeight: FontWeight.w700,
                            fontSize: (30 / 1.6).sp,
                          ),
                        ),
                      ),
                      for (int i = 0; i < section.items.length; i++) ...[
                        _NotificationTile(
                          item: section.items[i],
                          isLast: i == section.items.length - 1,
                        ),
                      ],
                    ],
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

class _NotificationTile extends StatelessWidget {
  const _NotificationTile({required this.item, required this.isLast});

  final _NotificationItem item;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 12.h),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: isLast ? Colors.transparent : const Color(0xFFDDE1E5),
            width: 1.r,
          ),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 10.h),
            child: Icon(Icons.circle, color: Color(0xFF0FAA9A), size: 7.r),
          ),
          SizedBox(width: 8.w),
          Container(
            width: 46.r,
            height: 46.r,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFD8ECFE),
              border: Border.all(color: const Color(0xFFB4D3EE)),
            ),
            child: Icon(item.icon, color: const Color(0xFF0B77C5), size: 22.r),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: const Color(0xFF0E2D55),
                    fontWeight: FontWeight.w700,
                    fontSize: (30 / 1.6).sp,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  item.message,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: const Color(0xFF454545),
                    fontSize: (28 / 1.6).sp,
                    height: 1.25,
                  ),
                ),
                SizedBox(height: 6.h),
                Text(
                  item.time,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: const Color(0xFF111827),
                    fontSize: (24 / 1.6).sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _NotificationSection {
  const _NotificationSection({required this.title, required this.items});

  final String title;
  final List<_NotificationItem> items;
}

class _NotificationItem {
  const _NotificationItem({
    required this.title,
    required this.message,
    required this.time,
    required this.icon,
  });

  final String title;
  final String message;
  final String time;
  final IconData icon;
}
