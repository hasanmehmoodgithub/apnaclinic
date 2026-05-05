import 'package:flutter/material.dart';

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
  });

  final List<LabTestBookingVendorOption> vendors;
  final int selectedIndex;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        const spacing = 9.0;
        const minTile = 121.33;
        final n = vendors.length;
        final rowW = constraints.maxWidth;
        final tileW = (rowW - spacing * 2) / 3;
        final w = tileW.clamp(minTile * 0.85, minTile);

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
                  borderRadius: BorderRadius.circular(17.215.r),
                  child: Column(
                    children: [
                      Container(
                        width: w,
                        height: w,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(17.215.r),
                          border: Border.all(
                            color: selected
                                ? const Color(0xFF0FAA9A)
                                : const Color(0xFF9BA6A7),
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
                          fontSize: 14.sp,
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
