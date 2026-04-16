import 'package:apnaclinic/core/extensions/screen_util_extensions.dart';
import 'package:flutter/material.dart';

class MenuAboutItemData {
  const MenuAboutItemData(this.title, {this.subtitle});

  final String title;
  final String? subtitle;
}

class MenuAboutCard extends StatelessWidget {
  const MenuAboutCard({
    super.key,
    required this.items,
  });

  final List<MenuAboutItemData> items;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(3.r),
        boxShadow: [
          BoxShadow(
            color: const Color.fromRGBO(5, 52, 83, 0.12),
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
