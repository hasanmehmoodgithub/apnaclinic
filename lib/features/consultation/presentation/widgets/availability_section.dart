import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../components/shimmer/app_shimmer.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../domain/entities/consultation_selected_slot_entity.dart';
import '../../domain/entities/consultation_doctor_slots_entity.dart';
import '../constants/consultation_ui_config.dart';
import 'availability_section_shimmer_widget.dart';

class AvailabilitySection extends StatefulWidget {
  const AvailabilitySection({
    super.key,
    required this.textTheme,
    required this.days,
    required this.isLoading,
    this.errorMessage,
    this.onSlotChanged,
  });

  final TextTheme textTheme;
  final List<ConsultationAvailabilityDayEntity> days;
  final bool isLoading;
  final String? errorMessage;
  final ValueChanged<ConsultationSelectedSlotEntity?>? onSlotChanged;

  @override
  State<AvailabilitySection> createState() => _AvailabilitySectionState();
}

class _AvailabilitySectionState extends State<AvailabilitySection> {
  int? _selectedDateIndex;
  int? _selectedTimeSlotIndex;

  @override
  void initState() {
    super.initState();
    _selectFirstAvailableDate(widget.days, notifySlotChanged: false);
  }

  @override
  void didUpdateWidget(covariant AvailabilitySection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.days != widget.days) {
      _selectFirstAvailableDate(widget.days);
    }
  }

  void _selectFirstAvailableDate(
    List<ConsultationAvailabilityDayEntity> days, {
    bool notifySlotChanged = true,
  }) {
    final firstAvailableIndex =
        days.indexWhere((day) => day.slots.isNotEmpty);
    setState(() {
      _selectedDateIndex =
          firstAvailableIndex >= 0 ? firstAvailableIndex : null;
      _selectedTimeSlotIndex = null;
    });

    if (!notifySlotChanged) return;

    final callback = widget.onSlotChanged;
    if (callback == null) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      callback(null);
    });
  }

  bool get _hasAnyAvailableSlots =>
      widget.days.any((day) => day.slots.isNotEmpty);

  String? get _selectedMonthLabel {
    if (_selectedDateIndex == null) return null;
    final selectedDay = widget.days[_selectedDateIndex!];
    final parsed = DateTime.tryParse(selectedDay.date);
    if (parsed == null) return null;
    return DateFormat('MMMM yyyy').format(parsed);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final selectedDay = _selectedDateIndex == null
        ? null
        : widget.days[_selectedDateIndex!];

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
            if (widget.isLoading)
              AppShimmerCard(
                width: 88.w,
                height: 28.h,
                borderRadius: 20.r,
              )
            else if (_selectedMonthLabel != null)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 11.w, vertical: 6.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(color: const Color(0xFFE1E5EA), width: 1),
                ),
                child: Text(
                  _selectedMonthLabel!,
                  style: widget.textTheme.bodySmall?.copyWith(
                    color: const Color(0xFF5F6C7C),
                    fontSize: 11.sp,
                  ),
                ),
              ),
          ],
        ),
        SizedBox(height: 10.h),
        if (widget.isLoading)
          const AvailabilitySectionShimmerWidget()
        else if (widget.errorMessage != null)
          _AvailabilityMessage(
            textTheme: widget.textTheme,
            message: widget.errorMessage!,
          )
        else if (widget.days.isEmpty)
          _AvailabilityMessage(
            textTheme: widget.textTheme,
            message: l10n.consultationNoAvailability,
          )
        else ...[
          SizedBox(
            height: 74.h,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: widget.days.length,
              separatorBuilder: (_, _) => SizedBox(width: 8.w),
              itemBuilder: (context, index) {
                final item = widget.days[index];
                final hasSlots = item.slots.isNotEmpty;
                final selected = _selectedDateIndex == index;
                return _DateChip(
                  textTheme: widget.textTheme,
                  weekDay: item.weekDay,
                  dayOfMonth: item.dayOfMonth,
                  isSelected: selected,
                  isEnabled: hasSlots,
                  onTap: hasSlots
                      ? () => setState(() {
                            _selectedDateIndex = index;
                            _selectedTimeSlotIndex = null;
                            widget.onSlotChanged?.call(null);
                          })
                      : null,
                );
              },
            ),
          ),
          if (!_hasAnyAvailableSlots)
            Padding(
              padding: EdgeInsets.only(top: 10.h),
              child: _AvailabilityMessage(
                textTheme: widget.textTheme,
                message: l10n.consultationNoAvailability,
              ),
            )
          else if (selectedDay != null) ...[
            SizedBox(height: 10.h),
            if (selectedDay.slots.isEmpty)
              _AvailabilityMessage(
                textTheme: widget.textTheme,
                message: l10n.consultationNoAvailability,
              )
            else
              SizedBox(
                height: 30.h,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: selectedDay.slots.length,
                  separatorBuilder: (_, _) => SizedBox(width: 8.w),
                  itemBuilder: (context, index) {
                    final slot = selectedDay.slots[index];
                    return _TimeSlotChip(
                      textTheme: widget.textTheme,
                      text: slot.label,
                      isSelected: _selectedTimeSlotIndex == index,
                      onTap: () => setState(() {
                        _selectedTimeSlotIndex = index;
                        widget.onSlotChanged?.call(
                          ConsultationSelectedSlotEntity(
                            date: selectedDay.date,
                            startTime: slot.startTime,
                            endTime: slot.endTime,
                            label: slot.label,
                          ),
                        );
                      }),
                    );
                  },
                ),
              ),
          ],
        ],
      ],
    );
  }
}

class _DateChip extends StatelessWidget {
  const _DateChip({
    required this.textTheme,
    required this.weekDay,
    required this.dayOfMonth,
    required this.isSelected,
    required this.isEnabled,
    this.onTap,
  });

  final TextTheme textTheme;
  final String weekDay;
  final String dayOfMonth;
  final bool isSelected;
  final bool isEnabled;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final backgroundColor = !isEnabled
        ? const Color(0xFFF7F8FA)
        : isSelected
            ? ConsultationUiConfig.ctaColor
            : const Color(0xFFF1F3F6);
    final weekDayColor = !isEnabled
        ? const Color(0xFFB8C0CB)
        : isSelected
            ? Colors.white.withValues(alpha: 0.9)
            : const Color(0xFF778395);
    final dayColor = !isEnabled
        ? const Color(0xFFB8C0CB)
        : isSelected
            ? Colors.white
            : const Color(0xFF545F70);

    return InkWell(
      borderRadius: BorderRadius.circular(10.r),
      onTap: onTap,
      child: Opacity(
        opacity: isEnabled ? 1 : 0.55,
        child: Container(
          width: 56.w,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(10.r),
            border: !isEnabled
                ? Border.all(color: const Color(0xFFE8EBF0), width: 1)
                : null,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                weekDay,
                style: textTheme.bodySmall?.copyWith(
                  color: weekDayColor,
                  fontSize: 12.sp,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                dayOfMonth,
                style: textTheme.titleMedium?.copyWith(
                  color: dayColor,
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AvailabilityMessage extends StatelessWidget {
  const _AvailabilityMessage({
    required this.textTheme,
    required this.message,
  });

  final TextTheme textTheme;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Text(
      message,
      style: textTheme.bodyMedium?.copyWith(
        color: const Color(0xFF5F6C7C),
        fontSize: 13.sp,
      ),
    );
  }
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
        height: 30.h,
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: isSelected
                ? ConsultationUiConfig.ctaColor
                : const Color(0xFFE1E5EA),
            width: 1,
          ),
          color: isSelected
              ? ConsultationUiConfig.ctaColor.withValues(alpha: 0.12)
              : Colors.white,
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: textTheme.bodySmall?.copyWith(
            color: isSelected
                ? ConsultationUiConfig.ctaColor
                : const Color(0xFF5F6C7C),
            fontSize: 12.sp,
            height: 1.0,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
