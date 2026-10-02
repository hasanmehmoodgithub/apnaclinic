import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../lab_test_route_args.dart';
import 'lab_test_booking_vendor_logo_widget.dart';

/// Three-column wrap of selectable lab vendors.
class LabTestBookingVendorGridWidget extends StatelessWidget {
  const LabTestBookingVendorGridWidget({
    super.key,
    required this.vendors,
    required this.selectedIndex,
    required this.onSelect,
    this.nameFontSize,
  });

  static const spacing = 9.0;
  static const minTile = 121.33;
  static const tileRadius = 17.215;

  final List<LabTestBookingVendorOption> vendors;
  final int selectedIndex;
  final ValueChanged<int> onSelect;
  final double? nameFontSize;

  static double tileWidth(double rowWidth) {
    final tileW = (rowWidth - spacing * 2) / 3;
    return tileW.clamp(minTile * 0.85, minTile);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        final n = vendors.length;
        final w = tileWidth(constraints.maxWidth);

        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          alignment: WrapAlignment.start,
          children: List.generate(n, (i) {
            final v = vendors[i];
            final selected = i == selectedIndex;
            return SizedBox(
              width: w,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => onSelect(i),
                  borderRadius: BorderRadius.circular(tileRadius.r),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: w,
                        height: w,
                        decoration: BoxDecoration(
                          color: AppColors.clrWhite,
                          borderRadius: BorderRadius.circular(tileRadius.r),
                          border: Border.all(
                            color: selected
                                ? AppColors.clr0FAA9A
                                : AppColors.clrD6DCE2,
                            width: 1.0,
                          ),
                        ),
                        alignment: Alignment.center,
                        child: LabTestBookingVendorLogoWidget(
                          vendor: v,
                          size: w * 0.68,
                        ),
                      ),
                      SizedBox(height: 9.h),
                      Text(
                        v.name,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: const Color(0xFF110844),
                          fontSize: nameFontSize ?? 14.sp,
                          height: 1,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }
}
