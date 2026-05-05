import 'package:flutter/material.dart';

import '../../../../core/extensions/screen_util_extensions.dart';
import '../lab_test_route_args.dart';
import 'lab_test_figma_image.dart';

/// Partner (Oladoc / etc.) tabs above vendor grid.
class LabTestBookingPartnerTabsWidget extends StatelessWidget {
  const LabTestBookingPartnerTabsWidget({
    super.key,
    required this.partners,
    required this.selectedIndex,
    required this.onChanged,
  });

  final List<LabTestBookingPartnerOption> partners;
  final int selectedIndex;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Color(0xFFE6E6E6), width: 1.0),
          top: BorderSide(color: Color(0xFFE6E6E6), width: 1.0),
        ),
      ),
      child: partners.isEmpty
          ? const SizedBox.shrink()
          : Row(
              children: List.generate(partners.length, (index) {
                final partner = partners[index];
                final selected = selectedIndex == index;
                return Expanded(
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => onChanged(index),
                      child: Container(
                        height: 36.h,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: selected
                                  ? const Color(0xFF0FAA9A)
                                  : const Color(0xFFE6E6E6),
                              width: 1.0,
                            ),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 26,
                              height: 26,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6.r),
                                color: Colors.white,
                                border: Border.all(
                                  color: const Color(0x352F2F2F),
                                  width: 1.0,
                                ),
                              ),
                              alignment: Alignment.center,
                              child: Padding(
                                padding: const EdgeInsets.all(3),
                                child: LabTestFigmaImage(
                                  url: partner.logoUrl,
                                  width: 20,
                                  height: 20,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                            SizedBox(width: 8.w),
                            Text(
                              partner.name,
                              style: theme.textTheme.titleMedium?.copyWith(
                                color: selected
                                    ? const Color(0xFF0FAA9A)
                                    : const Color(0xFF4D4D4D),
                                fontWeight: selected
                                    ? FontWeight.w700
                                    : FontWeight.w500,
                                fontSize: 16.sp,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
    );
  }
}
