import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/extensions/screen_util_extensions.dart';
import 'surgery_option.dart';

class SurgeryTypeDialogWidget extends StatelessWidget {
  const SurgeryTypeDialogWidget({
    super.key,
    required this.options,
    required this.selected,
  });

  final List<SurgeryOption> options;
  final SurgeryOption selected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 20.w),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.r)),
      clipBehavior: Clip.antiAlias,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 18.h),
            child: Text(
              'Select surgery type',
              style: theme.textTheme.titleMedium?.copyWith(
                color: const Color(0xFF061E40),
                fontWeight: FontWeight.w700,
                fontSize: 17.sp,
              ),
            ),
          ),
          ...List.generate(options.length, (i) {
            final option = options[i];
            final isSelected = option.name == selected.name;
            final isLast = i == options.length - 1;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(height: 1, color: const Color(0xFFEDEDED)),
                InkWell(
                  onTap: () => context.pop(option),
                  child: Container(
                    color: isSelected ? const Color(0xFFF1F1F1) : Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            option.name,
                            style: theme.textTheme.titleSmall?.copyWith(
                              color: const Color(0xFF061E40),
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              option.price,
                              style: theme.textTheme.titleSmall?.copyWith(
                                color: const Color(0xFF061E40),
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: 2.h),
                            Text(
                              option.oldPrice,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: const Color(0xFFB4B4B4),
                                fontSize: 12.sp,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                if (isLast) const SizedBox.shrink(),
              ],
            );
          }),
          SizedBox(height: 4.h),
        ],
      ),
    );
  }
}
