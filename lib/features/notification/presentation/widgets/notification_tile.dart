import 'package:apnaclinic/generated/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/extensions/screen_util_extensions.dart';
import '../../domain/entities/notification_entity.dart';

class NotificationTile extends StatelessWidget {
  const NotificationTile({
    super.key,
    required this.item,
    required this.isLast,
    required this.onTap,
  });

  final NotificationEntity item;
  final bool isLast;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      child: Container(
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
            SizedBox(
              width: 15.w,
              child: item.isRead
                  ? null
                  : Padding(
                      padding: EdgeInsets.only(top: 10.h),
                      child: Icon(
                        Icons.circle,
                        color: const Color(0xFF0FAA9A),
                        size: 7.r,
                      ),
                    ),
            ),
            SizedBox(width: 8.w),
            Container(
              width: 46.r,
              height: 46.r,
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFD8ECFE),
                border: Border.all(color: const Color(0xFFB4D3EE)),
              ),
              child: SvgPicture.asset(
                _resolveTypeIcon(item.type),
                color: const Color(0xFF0B77C5),
                height: 22.r,
                width: 22.r,
              ),
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
                    item.timeLabel,
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
      ),
    );
  }

  String _resolveTypeIcon(String type) {
    switch (type.toLowerCase()) {
      case 'consultation':
        return Assets.iconsCalendar;
      case 'lab':
        return Assets.iconsLab;
      case 'surgery':
        return Assets.iconsSurgery;
      case 'medicine':
        return Assets.iconsMedicine;
      default:
        return Assets.iconsMedicine;
    }
  }
}
