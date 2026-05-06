import 'package:flutter/material.dart';

import '../../../../core/extensions/screen_util_extensions.dart';
import '../constants/consultation_ui_config.dart';

class AvailabilitySection extends StatefulWidget {
  final TextTheme textTheme;
  final ValueChanged<String?>? onTimeSlotChanged;

  const AvailabilitySection({
    super.key,
    required this.textTheme,
    this.onTimeSlotChanged,
  });

  @override
  State<AvailabilitySection> createState() => _AvailabilitySectionState();
}

class _AvailabilitySectionState extends State<AvailabilitySection> {
  int? _selectedDateIndex;
  int? _selectedTimeSlotIndex;

  static const List<_AvailabilityDay> _days = [
    _AvailabilityDay(
      weekDay: 'Thu',
      dayOfMonth: '23',
      timeSlots: ['6:00 PM - 6:30 PM', '6:30 PM - 7:00 PM', '7:00 PM - 7:30 PM'],
    ),
    _AvailabilityDay(
      weekDay: 'Fri',
      dayOfMonth: '24',
      timeSlots: ['5:30 PM - 6:00 PM', '6:00 PM - 6:30 PM', '6:30 PM - 7:00 PM'],
    ),
    _AvailabilityDay(
      weekDay: 'Sat',
      dayOfMonth: '25',
      timeSlots: ['4:30 PM - 5:00 PM', '5:00 PM - 5:30 PM', '5:30 PM - 6:00 PM'],
    ),
    _AvailabilityDay(
      weekDay: 'Sun',
      dayOfMonth: '26',
      timeSlots: ['6:00 PM - 6:30 PM', '6:30 PM - 7:00 PM'],
    ),
    _AvailabilityDay(
      weekDay: 'Mon',
      dayOfMonth: '27',
      timeSlots: ['7:00 PM - 7:30 PM', '7:30 PM - 8:00 PM'],
    ),
    _AvailabilityDay(
      weekDay: 'Tue',
      dayOfMonth: '28',
      timeSlots: ['6:00 PM - 6:30 PM', '6:30 PM - 7:00 PM', '7:00 PM - 7:30 PM'],
    ),
    _AvailabilityDay(
      weekDay: 'Wed',
      dayOfMonth: '29',
      timeSlots: ['5:30 PM - 6:00 PM', '6:00 PM - 6:30 PM'],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final selectedDay = _selectedDateIndex == null ? null : _days[_selectedDateIndex!];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Availability',
              style: widget.textTheme.titleMedium?.copyWith(
                color: const Color(0xFF1E2D3F),
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Spacer(),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 11.w, vertical: 6.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(color: const Color(0xFFE1E5EA), width: 1),
              ),
              child: Text(
                'April 2026',
                style: widget.textTheme.bodySmall?.copyWith(
                  color: const Color(0xFF5F6C7C),
                  fontSize: 11.sp,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 10.h),
        SizedBox(
          height: 74.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: _days.length,
            separatorBuilder: (_, _) => SizedBox(width: 8.w),
            itemBuilder: (context, index) {
              final item = _days[index];
              final selected = _selectedDateIndex == index;
              return InkWell(
                borderRadius: BorderRadius.circular(10.r),
                onTap: () => setState(() {
                  _selectedDateIndex = index;
                  _selectedTimeSlotIndex = null;
                  widget.onTimeSlotChanged?.call(null);
                }),
                child: Container(
                  width: 56.w,
                  decoration: BoxDecoration(
                    color: selected
                        ? ConsultationUiConfig.ctaColor
                        : const Color(0xFFF1F3F6),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        item.weekDay,
                        style: widget.textTheme.bodySmall?.copyWith(
                          color: selected
                              ? Colors.white.withValues(alpha: 0.9)
                              : const Color(0xFF778395),
                          fontSize: 12.sp,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        item.dayOfMonth,
                        style: widget.textTheme.titleMedium?.copyWith(
                          color: selected ? Colors.white : const Color(0xFF545F70),
                          fontSize: 22.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        if (selectedDay != null) ...[
          SizedBox(height: 10.h),
          SizedBox(
            height: 30.h,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: selectedDay.timeSlots.length,
              separatorBuilder: (_, _) => SizedBox(width: 8.w),
              itemBuilder: (context, index) => _TimeSlotChip(
                textTheme: widget.textTheme,
                text: selectedDay.timeSlots[index],
                isSelected: _selectedTimeSlotIndex == index,
                onTap: () => setState(() {
                  _selectedTimeSlotIndex = index;
                  widget.onTimeSlotChanged?.call(selectedDay.timeSlots[index]);
                }),
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _AvailabilityDay {
  const _AvailabilityDay({
    required this.weekDay,
    required this.dayOfMonth,
    required this.timeSlots,
  });

  final String weekDay;
  final String dayOfMonth;
  final List<String> timeSlots;
}

class _TimeSlotChip extends StatelessWidget {
  const _TimeSlotChip({
    required this.textTheme,
    required this.text,
    required this.isSelected,
    required this.onTap,
  });

  final TextTheme textTheme;
  final String text;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16.r),
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: isSelected ? ConsultationUiConfig.ctaColor : const Color(0xFFE1E5EA),
            width: 1,
          ),
          color: isSelected
              ? ConsultationUiConfig.ctaColor.withValues(alpha: 0.12)
              : Colors.white,
        ),
        child: Text(
          text,
          style: textTheme.bodySmall?.copyWith(
            color: isSelected ? ConsultationUiConfig.ctaColor : const Color(0xFF5F6C7C),
            fontSize: 12.sp,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
