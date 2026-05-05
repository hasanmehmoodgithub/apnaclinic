import 'package:flutter/material.dart';

import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';

class SurgeryBookingRequirementsCardWidget extends StatelessWidget {
  const SurgeryBookingRequirementsCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;
    final items = <String>[
      l10n.bookingsSurgeryRequirement1,
      l10n.bookingsSurgeryRequirement2,
      l10n.bookingsSurgeryRequirement3,
    ];
    return Container(
      padding: EdgeInsets.fromLTRB(12.w, 12.h, 16.w, 16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0F053453),
            blurRadius: 16,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.bookingsRequirementsTitle,
            style: textTheme.titleMedium?.copyWith(
              color: const Color(0xFF061E40),
              fontSize: 14.sp,
            ),
          ),
          SizedBox(height: 12.h),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(items.length, (i) {
              return Padding(
                padding: EdgeInsets.only(top: i == 0 ? 4.h : 10.h),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 24.w,
                      child: Text(
                        '${i + 1}.',
                        style: textTheme.bodyMedium?.copyWith(
                          color: const Color(0xFF061E40),
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        items[i],
                        style: textTheme.bodyMedium?.copyWith(
                          color: const Color(0xFF061E40),
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400,
                          height: 1.2,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
