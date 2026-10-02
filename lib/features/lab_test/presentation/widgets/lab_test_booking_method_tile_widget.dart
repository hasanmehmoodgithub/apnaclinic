import 'package:flutter/material.dart';

import '../../../../core/extensions/screen_util_extensions.dart';
import 'lab_test_figma_image.dart';

/// Walk-in vs home sample selector tile.
class LabTestBookingMethodTileWidget extends StatelessWidget {
  const LabTestBookingMethodTileWidget({
    super.key,
    required this.title,
    required this.iconUrl,
    required this.selected,
    required this.onTap,
    this.enabled = true,
  });

  final String title;
  final String iconUrl;
  final bool selected;
  final VoidCallback onTap;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final borderColor =
        enabled ? const Color(0xFF9BA6A7) : const Color(0xFFD5DADC);
    final titleColor =
        enabled ? const Color(0xFF110844) : const Color(0xFF9BA6A7);
    final radioBorderColor =
        enabled ? const Color(0xFF061E40) : const Color(0xFFB8C0C4);
    final radioFillColor =
        enabled ? const Color(0xFF061E40) : const Color(0xFFB8C0C4);

    return Opacity(
      opacity: enabled ? 1 : 0.55,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: enabled ? onTap : null,
          borderRadius: BorderRadius.circular(5.32.r),
          child: Container(
            constraints: BoxConstraints(minHeight: 62.h),
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.32.r),
              border: Border.all(color: borderColor, width: 1.0),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      LabTestFigmaImage(url: iconUrl, width: 16, height: 16),
                      SizedBox(height: 2.h),
                      Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: titleColor,
                          fontSize: 13.sp,
                          height: 1,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 13,
                  height: 13,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: radioBorderColor, width: 1.0),
                  ),
                  alignment: Alignment.center,
                  child: selected
                      ? Container(
                          width: 7.082,
                          height: 6.665,
                          decoration: BoxDecoration(
                            color: radioFillColor,
                            borderRadius: BorderRadius.circular(10.801),
                          ),
                        )
                      : null,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
