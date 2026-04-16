import 'package:flutter/material.dart';

import '../../../../core/extensions/screen_util_extensions.dart';

class InfoTilesRow extends StatelessWidget {
  const InfoTilesRow({
    super.key,
    required this.gender,
    required this.dob,
    required this.email,
  });

  final String gender;
  final String dob;
  final String email;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
      children: [
        Expanded(child: InfoTile(title: 'Gender', value: gender)),
        SizedBox(width: 6.w),
        Expanded(child: InfoTile(title: 'Date of Birth', value: dob)),
        SizedBox(width: 6.w),
        Expanded(child: InfoTile(title: 'Email', value: email)),
      ],
      ),
    );
  }
}

class InfoTile extends StatelessWidget {
  const InfoTile({super.key, required this.title, required this.value});

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4.r),
        border: Border.all(color: const Color(0xFFC9CFD7), width: 0.8.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodySmall?.copyWith(
              color: const Color(0xFF7A91AE),
              fontSize: (12 / 1.05).sp,
            ),
          ),
          SizedBox(height: 3.h),
          Text(
            value,
            maxLines: 2,
            overflow: TextOverflow.visible,
            style: theme.textTheme.titleMedium?.copyWith(
              color: const Color(0xFF2B2C58),
              fontWeight: FontWeight.w500,
              fontSize: (26 / 1.6).sp,
              height: 1.15,
            ),
          ),
        ],
      ),
    );
  }
}
