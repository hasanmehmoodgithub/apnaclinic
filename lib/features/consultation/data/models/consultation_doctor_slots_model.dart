import 'package:intl/intl.dart';

import '../../domain/entities/consultation_doctor_slots_entity.dart';

class ConsultationDoctorSlotsModel {
  const ConsultationDoctorSlotsModel({
    required this.monthLabel,
    required this.days,
  });

  final String monthLabel;
  final List<ConsultationAvailabilityDayEntity> days;

  factory ConsultationDoctorSlotsModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    final rawDays = data is List ? data : const <dynamic>[];

    final days = rawDays
        .whereType<Map<String, dynamic>>()
        .map(_parseDay)
        .where((day) => day.slots.isNotEmpty)
        .toList(growable: false);

    final monthLabel = days.isNotEmpty
        ? _monthLabelForDate(days.first.date)
        : '';

    return ConsultationDoctorSlotsModel(monthLabel: monthLabel, days: days);
  }

  ConsultationDoctorSlotsEntity toEntity() {
    return ConsultationDoctorSlotsEntity(monthLabel: monthLabel, days: days);
  }

  static ConsultationAvailabilityDayEntity _parseDay(
    Map<String, dynamic> json,
  ) {
    final date = (json['date'] ?? '').toString().trim();
    final parsedDate = DateTime.tryParse(date);
    final weekDay = parsedDate != null
        ? DateFormat('EEE').format(parsedDate)
        : '';
    final dayOfMonth = parsedDate != null
        ? DateFormat('d').format(parsedDate)
        : '';

    final slotsRaw = json['slots'];
    final slots = slotsRaw is List
        ? slotsRaw
            .whereType<Map<String, dynamic>>()
            .map(_parseSlot)
            .where((slot) => slot.label.isNotEmpty)
            .toList(growable: false)
        : const <ConsultationTimeSlotEntity>[];

    return ConsultationAvailabilityDayEntity(
      date: date,
      weekDay: weekDay,
      dayOfMonth: dayOfMonth,
      slots: slots,
    );
  }

  static ConsultationTimeSlotEntity _parseSlot(Map<String, dynamic> json) {
    final startTime =
        (json['start_time'] ?? json['startTime'] ?? '').toString().trim();
    final endTime = (json['end_time'] ?? json['endTime'] ?? '').toString().trim();
    final label = startTime.isNotEmpty && endTime.isNotEmpty
        ? '${_formatTime12h(startTime)} - ${_formatTime12h(endTime)}'
        : '';

    return ConsultationTimeSlotEntity(
      startTime: startTime,
      endTime: endTime,
      label: label,
    );
  }

  static String _monthLabelForDate(String date) {
    final parsed = DateTime.tryParse(date);
    if (parsed == null) return '';
    return DateFormat('MMMM yyyy').format(parsed);
  }

  static String _formatTime12h(String time24) {
    final parts = time24.split(':');
    if (parts.length < 2) return time24;

    var hour = int.tryParse(parts[0]) ?? 0;
    final minute = parts[1].padLeft(2, '0');
    final period = hour >= 12 ? 'PM' : 'AM';
    hour = hour % 12;
    if (hour == 0) hour = 12;
    return '$hour:$minute $period';
  }
}
