import 'package:flutter/material.dart';

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
    required this.monthLabel,
    required this.isLoading,
    this.errorMessage,
    this.onRetry,
    this.onSlotChanged,
  });

  final TextTheme textTheme;
  final List<ConsultationAvailabilityDayEntity> days;
  final String monthLabel;
  final bool isLoading;
  final String? errorMessage;
  final VoidCallback? onRetry;
  final ValueChanged<ConsultationSelectedSlotEntity?>? onSlotChanged;

  @override
  State<AvailabilitySection> createState() => _AvailabilitySectionState();
}

class _AvailabilitySectionState extends State<AvailabilitySection> {
  int? _selectedDateIndex;
  int? _selectedTimeSlotIndex;

  @override
  void didUpdateWidget(covariant AvailabilitySection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.days != widget.days) {
      _selectedDateIndex = null;
      _selectedTimeSlotIndex = null;
      final callback = widget.onSlotChanged;
      if (callback != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;
          callback(null);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final selectedDay =
        _selectedDateIndex == null ? null : widget.days[_selectedDateIndex!];

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
            else if (widget.monthLabel.isNotEmpty)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 11.w, vertical: 6.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(color: const Color(0xFFE1E5EA), width: 1),
                ),
                child: Text(
                  widget.monthLabel,
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
            actionLabel: l10n.consultationAvailabilityRetry,
            onAction: widget.onRetry,
          )
        else if (widget.days.isEmpty)
          _AvailabilityMessage(
            textTheme: widget.textTheme,
            message: l10n.consultationNoAvailability,
            actionLabel:
                widget.onRetry == null ? null : l10n.consultationAvailabilityRetry,
            onAction: widget.onRetry,
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
                final selected = _selectedDateIndex == index;
                return InkWell(
                  borderRadius: BorderRadius.circular(10.r),
                  onTap: () => setState(() {
                    _selectedDateIndex = index;
                    _selectedTimeSlotIndex = null;
                    widget.onSlotChanged?.call(null);
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
                            color: selected
                                ? Colors.white
                                : const Color(0xFF545F70),
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
            if (selectedDay.slots.isEmpty)
              _AvailabilityMessage(
                textTheme: widget.textTheme,
                message: l10n.consultationNoAvailability,
                actionLabel: widget.onRetry == null
                    ? null
                    : l10n.consultationAvailabilityRetry,
                onAction: widget.onRetry,
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

class _AvailabilityMessage extends StatelessWidget {
  const _AvailabilityMessage({
    required this.textTheme,
    required this.message,
    this.actionLabel,
    this.onAction,
  });

  final TextTheme textTheme;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          message,
          style: textTheme.bodyMedium?.copyWith(
            color: const Color(0xFF5F6C7C),
            fontSize: 13.sp,
          ),
        ),
        if (actionLabel != null && onAction != null) ...[
          SizedBox(height: 8.h),
          TextButton(onPressed: onAction, child: Text(actionLabel!)),
        ],
      ],
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
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
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
          style: textTheme.bodySmall?.copyWith(
            color: isSelected
                ? ConsultationUiConfig.ctaColor
                : const Color(0xFF5F6C7C),
            fontSize: 12.sp,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
