import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../domain/entities/apna_clinic_ai_card_entity.dart';
import '../constants/apna_clinic_ai_ui_config.dart';
import '../cubit/apna_clinic_ai_cubit.dart';
import '../cubit/apna_clinic_ai_state.dart';

class ApnaClinicAiSlotCalendar extends StatelessWidget {
  const ApnaClinicAiSlotCalendar({
    super.key,
    required this.days,
    required this.onSend,
  });

  final List<ApnaClinicAiSlotDayEntity> days;
  final ValueChanged<String> onSend;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    if (days.isEmpty) return const SizedBox.shrink();

    return BlocSelector<ApnaClinicAiCubit, ApnaClinicAiState, int>(
      selector: (state) {
        if (days.isEmpty) return 0;
        return state.selectedSlotDayIndex.clamp(0, days.length - 1);
      },
      builder: (context, selected) {
        final day = days[selected];
        return Container(
          width: double.infinity,
          margin: EdgeInsets.only(bottom: 10.h),
          padding: EdgeInsets.all(14.r),
          decoration: BoxDecoration(
            color: ApnaClinicAiUiConfig.panel,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: ApnaClinicAiUiConfig.borderStrong),
            boxShadow: ApnaClinicAiUiConfig.cardShadow,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      l10n.apnaClinicAiSlots,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 14.sp,
                        color: ApnaClinicAiUiConfig.primaryText,
                      ),
                    ),
                  ),
                  Text(
                    l10n.apnaClinicAiPickADay,
                    style: TextStyle(
                      fontSize: 11.sp,
                      color: ApnaClinicAiUiConfig.muted,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.h),
              SizedBox(
                height: 58.h,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: days.length,
                  separatorBuilder: (_, _) => SizedBox(width: 6.w),
                  itemBuilder: (context, i) {
                    final item = days[i];
                    final isSelected = i == selected;
                    final parts = _dayParts(item.date);
                    return Material(
                      color: isSelected
                          ? ApnaClinicAiUiConfig.cta
                          : ApnaClinicAiUiConfig.sand,
                      borderRadius: BorderRadius.circular(12.r),
                      child: InkWell(
                        onTap: () =>
                            context.read<ApnaClinicAiCubit>().selectSlotDay(i),
                        borderRadius: BorderRadius.circular(12.r),
                        child: ConstrainedBox(
                          constraints: BoxConstraints(minWidth: 58.w),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 10.w,
                              vertical: 6.h,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12.r),
                              border: Border.all(
                                color: isSelected
                                    ? ApnaClinicAiUiConfig.cta
                                    : ApnaClinicAiUiConfig.border,
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  parts.$1,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 15.sp,
                                    height: 1.1,
                                    color: isSelected
                                        ? ApnaClinicAiUiConfig.panel
                                        : ApnaClinicAiUiConfig.primaryText,
                                  ),
                                ),
                                if (parts.$2.isNotEmpty)
                                  Text(
                                    parts.$2,
                                    style: TextStyle(
                                      fontSize: 10.sp,
                                      height: 1.1,
                                      letterSpacing: 0.4,
                                      color: isSelected
                                          ? Colors.white.withValues(alpha: 0.85)
                                          : ApnaClinicAiUiConfig.muted,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 10.h),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: day.slots.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 6.w,
                  mainAxisSpacing: 6.h,
                  childAspectRatio: 2.4,
                ),
                itemBuilder: (context, i) {
                  final slot = day.slots[i];
                  return Material(
                    color: ApnaClinicAiUiConfig.panel,
                    borderRadius: BorderRadius.circular(10.r),
                    child: InkWell(
                      onTap: () => onSend(slot.send),
                      borderRadius: BorderRadius.circular(10.r),
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.r),
                          border: Border.all(
                            color: ApnaClinicAiUiConfig.border,
                          ),
                        ),
                        child: Text(
                          slot.label,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 12.sp,
                            color: ApnaClinicAiUiConfig.primaryText,
                            fontFeatures: const [
                              FontFeature.tabularFigures(),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

/// Formats calendar day keys like `2026-10-21` → (`21`, `OCT`).
(String, String) _dayParts(String raw) {
  final value = raw.trim();
  if (value.isEmpty) return ('—', '');

  final parsed = DateTime.tryParse(value);
  if (parsed != null) {
    return ('${parsed.day}', _monthLabel(parsed.month));
  }

  final iso = RegExp(r'(\d{4})-(\d{2})-(\d{2})').firstMatch(value);
  if (iso != null) {
    final day = int.tryParse(iso.group(3)!)?.toString() ?? iso.group(3)!;
    final month = int.tryParse(iso.group(2)!) ?? 0;
    return (day, _monthLabel(month));
  }

  final dayFirst = RegExp(r'^(\d{1,2})\s+([A-Za-z]{3,})').firstMatch(value);
  if (dayFirst != null) {
    return (
      dayFirst.group(1)!,
      dayFirst.group(2)!.substring(0, 3).toUpperCase(),
    );
  }
  final monthFirst = RegExp(r'^([A-Za-z]{3,})\s+(\d{1,2})').firstMatch(value);
  if (monthFirst != null) {
    return (
      monthFirst.group(2)!,
      monthFirst.group(1)!.substring(0, 3).toUpperCase(),
    );
  }
  return (value, '');
}

String _monthLabel(int month) {
  const months = [
    '',
    'JAN',
    'FEB',
    'MAR',
    'APR',
    'MAY',
    'JUN',
    'JUL',
    'AUG',
    'SEP',
    'OCT',
    'NOV',
    'DEC',
  ];
  return month >= 1 && month <= 12 ? months[month] : '';
}
