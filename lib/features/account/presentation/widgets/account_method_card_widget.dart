import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../components/widgets/action_option_card.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../generated/assets.dart';
import '../../domain/models/account_method.dart';

class AccountMethodCardWidget extends StatelessWidget {
  const AccountMethodCardWidget({
    super.key,
    required this.account,
    required this.displayBankName,
    required this.onDeleteTap,
  });

  final AccountMethod account;
  final String displayBankName;
  final VoidCallback? onDeleteTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ActionOptionCard(
      title: displayBankName,
      subtitle: account.accountHolderName,
      onTap: () {},
      onTrailingTap: account.isDefault ? null : onDeleteTap,
      showTrailing: false,
      height: 96.h,
      radius: 6.r,
      curveOverlayColor: AppColors.clrE9F4FC,
      contentPadding: EdgeInsets.fromLTRB(12.w, 10.h, 10.w, 10.h),
      titleSpacing: 2,
      trailingOverlayWidth: account.isDefault ? 78.w : 40.w,
      trailingOverlayHeight: account.isDefault ? 34.h : 40.h,
      leading: Container(
        width: 60.r,
        height: 60.r,
        padding: EdgeInsets.all(2.r),
        child: SvgPicture.asset(Assets.svgJazzCash, fit: BoxFit.contain),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            displayBankName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: AppColors.clr111827,
              fontWeight: FontWeight.w700,
              fontSize: 16.sp,
              height: 1.1,
            ),
          ),
          SizedBox(height: 3.h),
          Text(
            account.accountHolderName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.titleMedium?.copyWith(
              color: AppColors.clr203A59,
              fontWeight: FontWeight.w500,
              fontSize: 18.sp,
              height: 1.1,
            ),
          ),
          SizedBox(height: 3.h),
          Text(
            account.accountNumber,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: AppColors.clr8A9AAE,
              fontWeight: FontWeight.w400,
              fontSize: 14.sp,
              height: 1.1,
            ),
          ),
        ],
      ),
    );
  }
}
