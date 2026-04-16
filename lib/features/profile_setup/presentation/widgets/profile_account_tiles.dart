import 'package:flutter/material.dart';

import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../account/domain/models/account_method.dart';

class AccountTile extends StatelessWidget {
  const AccountTile({
    super.key,
    required this.account,
    required this.onTap,
    this.onDelete,
  });

  final AccountMethod account;
  final VoidCallback onTap;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(4.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(4.r),
          border: Border.all(
            color: const Color(0xFFC9CFD7),
            width: 0.8.r,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Mobile Bank/${account.bankName}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: const Color(0xFF7A91AE),
                      fontSize: (12 / 1.05).sp,
                    ),
                  ),
                  SizedBox(height: 3.h),
                  Text(
                    account.accountNumber,
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
            ),
            if (account.isDefault)
              Container(
                margin: EdgeInsets.only(left: 8.w, top: 2.h),
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: const Color(0xFFD4D9E1)),
                ),
                child: Text(
                  'Default',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: const Color(0xFF7B8794),
                  ),
                ),
              ),
            if (!account.isDefault && onDelete != null)
              InkWell(
                onTap: onDelete,
                borderRadius: BorderRadius.circular(14.r),
                child: Container(
                  margin: EdgeInsets.only(left: 8.w, top: 2.h),
                  width: 28.r,
                  height: 28.r,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: const Color(0xFFD4D9E1)),
                    color: Colors.white,
                  ),
                  child: Icon(
                    Icons.delete_outline_rounded,
                    color: const Color(0xFFC62828),
                    size: 16.r,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class AddAccountTile extends StatelessWidget {
  const AddAccountTile({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6.r),
      child: Container(
        height: 56.h,
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        decoration: BoxDecoration(
          color: const Color(0xFFF3F3F3),
          borderRadius: BorderRadius.circular(6.r),
          border: Border.all(
            color: const Color(0xFFD4D9E1),
            width: 0.6.r,
          ),
        ),
        child: Row(
          children: [
            Text(
              'Add Account',
              style: theme.textTheme.titleSmall?.copyWith(
                color: const Color(0xFF2C2F5A),
                fontWeight: FontWeight.w500,
              ),
            ),
            const Spacer(),
            Container(
              width: 40.r,
              height: 40.r,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color(0xFFC6CCD5),
                ),
              ),
              child: const Icon(
                Icons.add,
                color: Color(0xFF2C2F5A),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
