import 'package:intl/intl.dart';

import '../../domain/entities/consultation_doctor_slots_entity.dart';

class ConsultationDoctorSlotsModel {
  const ConsultationDoctorSlotsModel({
    required this.monthLabel,
    required this.days,
    this.doctorInfo,
  });

  final String monthLabel;
  final List<ConsultationAvailabilityDayEntity> days;
  final ConsultationDoctorSlotsDoctorInfoEntity? doctorInfo;

  factory ConsultationDoctorSlotsModel.fromJson(Map<String, dynamic> json) {
    final rawDays = _extractTimeslotDays(json);
    final doctorInfo = _parseDoctorInfo(json);

    final parsedDays = rawDays
        .whereType<Map<String, dynamic>>()
        .map(_parseDay)
        .where((day) => day.date.isNotEmpty)
        .toList(growable: false);

    // Fill gaps in the returned range so missing dates render as disabled.
    final days = _fillMissingDates(parsedDays);

    final monthLabel =
        days.isNotEmpty ? _monthLabelForDays(days) : '';

    return ConsultationDoctorSlotsModel(
      monthLabel: monthLabel,
      days: days,
      doctorInfo: doctorInfo,
    );
  }

  ConsultationDoctorSlotsEntity toEntity() {
    return ConsultationDoctorSlotsEntity(
      monthLabel: monthLabel,
      days: days,
      doctorInfo: doctorInfo,
    );
  }

  static List<dynamic> _extractTimeslotDays(Map<String, dynamic> json) {
    final data = json['data'];
    if (data is Map<String, dynamic>) {
      final doctorInfo = data['doctorInfo'];
      if (doctorInfo is Map<String, dynamic>) {
        final timeslots = doctorInfo['timeslots'] ?? doctorInfo['timeSlots'];
        if (timeslots is List) return timeslots;
      }
      if (data['data'] is List) return data['data'] as List<dynamic>;
    }
    if (data is List) return data;
    return const [];
  }

  static ConsultationDoctorSlotsDoctorInfoEntity? _parseDoctorInfo(
    Map<String, dynamic> json,
  ) {
    final data = json['data'];
    if (data is! Map<String, dynamic>) return null;
    final doctorInfo = data['doctorInfo'];
    if (doctorInfo is! Map<String, dynamic>) return null;

    return ConsultationDoctorSlotsDoctorInfoEntity(
      ratings: _readDouble(doctorInfo['ratings']),
      pmdcVerified: doctorInfo['pmdcVerified'] == true,
      verifiedPatientsCount:
          _readInt(doctorInfo['verifiedPatientsCount']),
      patientsSatisfiedPercentage:
          _readDouble(doctorInfo['patientsSatisfiedPercentage']),
      patientReviews: _parsePatientReviews(doctorInfo['patientReviews']),
    );
  }

  static ConsultationPatientReviewsEntity _parsePatientReviews(dynamic raw) {
    if (raw is! Map<String, dynamic>) {
      return ConsultationPatientReviewsEntity.empty;
    }

    final reviewsRaw = raw['reviews'];
    final reviews = reviewsRaw is List
        ? reviewsRaw
            .whereType<Map<String, dynamic>>()
            .map(_parsePatientReview)
            .where((review) =>
                review.comment.isNotEmpty || review.patientName.isNotEmpty)
            .toList(growable: false)
        : const <ConsultationPatientReviewEntity>[];

    return ConsultationPatientReviewsEntity(
      totalCount: _readInt(raw['totalCount'] ?? raw['total_count']),
      filteredCount: _readInt(raw['filteredCount'] ?? raw['filtered_count']),
      reviews: reviews,
    );
  }

  static ConsultationPatientReviewEntity _parsePatientReview(
    Map<String, dynamic> json,
  ) {
    final rating = _readDouble(
      json['rating'] ??
          json['ratings'] ??
          json['score'] ??
          json['starRating'] ??
          json['star_rating'],
    );
    final parsedMax = _readDouble(
      json['maxRating'] ?? json['max_rating'] ?? json['outOf'],
    );
    final maxRating = parsedMax > 0 ? parsedMax : 5.0;
    final comment = _readString(json, const [
      'comment',
      'review',
      'feedback',
      'title',
      'text',
      'content',
      'reviewText',
      'review_text',
      'message',
    ]);
    final patientName = _readString(json, const [
      'patientName',
      'patient_name',
      'name',
      'reviewerName',
      'reviewer_name',
      'displayName',
      'display_name',
      'maskedName',
      'masked_name',
    ]);
    final dateLabel = _formatReviewDate(_readString(json, const [
      'date',
      'reviewDate',
      'review_date',
      'createdAt',
      'created_at',
      'reviewedAt',
      'reviewed_at',
      'updatedAt',
      'updated_at',
    ]));

    return ConsultationPatientReviewEntity(
      rating: rating,
      maxRating: maxRating,
      dateLabel: dateLabel,
      comment: comment,
      patientName: patientName,
    );
  }

  static String _readString(Map<String, dynamic> json, List<String> keys) {
    for (final key in keys) {
      final value = json[key];
      if (value == null) continue;
      final text = value.toString().trim();
      if (text.isNotEmpty) return text;
    }
    return '';
  }

  static String _formatReviewDate(String raw) {
    final trimmed = raw.trim();
    if (trimmed.isEmpty) return '';

    final parsed = DateTime.tryParse(trimmed);
    if (parsed != null) {
      return DateFormat('dd/MM/yyyy').format(parsed);
    }

    // Already display-formatted (e.g. 08/12/2025).
    return trimmed;
  }

  static ConsultationAvailabilityDayEntity _parseDay(
    Map<String, dynamic> json,
  ) {
    final date = (json['date'] ?? '').toString().trim();
    return _dayEntity(
      date: date,
      slots: _parseSlots(json['slots']),
    );
  }

  static List<ConsultationTimeSlotEntity> _parseSlots(dynamic slotsRaw) {
    if (slotsRaw is! List) return const [];
    return slotsRaw
        .whereType<Map<String, dynamic>>()
        .map(_parseSlot)
        .where((slot) => slot.label.isNotEmpty)
        .toList(growable: false);
  }

  static ConsultationAvailabilityDayEntity _dayEntity({
    required String date,
    required List<ConsultationTimeSlotEntity> slots,
  }) {
    final parsedDate = DateTime.tryParse(date);
    final weekDay =
        parsedDate != null ? DateFormat('EEE').format(parsedDate) : '';
    final dayOfMonth =
        parsedDate != null ? DateFormat('d').format(parsedDate) : '';

    return ConsultationAvailabilityDayEntity(
      date: date,
      weekDay: weekDay,
      dayOfMonth: dayOfMonth,
      slots: slots,
    );
  }

  /// Inserts empty days for any date gaps between the first and last timeslot.
  static List<ConsultationAvailabilityDayEntity> _fillMissingDates(
    List<ConsultationAvailabilityDayEntity> days,
  ) {
    if (days.isEmpty) return days;

    final byDate = <String, ConsultationAvailabilityDayEntity>{};
    DateTime? minDate;
    DateTime? maxDate;

    for (final day in days) {
      final parsed = DateTime.tryParse(day.date);
      if (parsed == null) continue;
      final dateOnly = DateTime(parsed.year, parsed.month, parsed.day);
      final key = _dateKey(dateOnly);
      byDate[key] = day;
      if (minDate == null || dateOnly.isBefore(minDate)) minDate = dateOnly;
      if (maxDate == null || dateOnly.isAfter(maxDate)) maxDate = dateOnly;
    }

    if (minDate == null || maxDate == null) return days;

    final filled = <ConsultationAvailabilityDayEntity>[];
    for (var cursor = minDate;
        !cursor.isAfter(maxDate);
        cursor = cursor.add(const Duration(days: 1))) {
      final key = _dateKey(cursor);
      filled.add(
        byDate[key] ??
            _dayEntity(date: key, slots: const <ConsultationTimeSlotEntity>[]),
      );
    }
    return filled;
  }

  static String _dateKey(DateTime date) =>
      '${date.year.toString().padLeft(4, '0')}-'
      '${date.month.toString().padLeft(2, '0')}-'
      '${date.day.toString().padLeft(2, '0')}';

  static ConsultationTimeSlotEntity _parseSlot(Map<String, dynamic> json) {
    final rawStart =
        (json['start_time'] ?? json['startTime'] ?? '').toString().trim();
    final rawEnd =
        (json['end_time'] ?? json['endTime'] ?? '').toString().trim();
    final startTime = _to24Hour(rawStart);
    final endTime = _to24Hour(rawEnd);
    final startDisplay = _toDisplayTime(rawStart);
    final endDisplay = _toDisplayTime(rawEnd);
    final label = startDisplay.isNotEmpty && endDisplay.isNotEmpty
        ? '$startDisplay - $endDisplay'
        : '';

    return ConsultationTimeSlotEntity(
      startTime: startTime,
      endTime: endTime,
      label: label,
    );
  }

  static String _to24Hour(String time) {
    final trimmed = time.trim();
    if (trimmed.isEmpty) return '';

    final upper = trimmed.toUpperCase();
    if (upper.contains('AM') || upper.contains('PM')) {
      final parsed = _parse12Hour(trimmed);
      if (parsed != null) {
        return DateFormat('HH:mm').format(parsed);
      }
      return trimmed;
    }

    final parts = trimmed.split(':');
    if (parts.length < 2) return trimmed;

    final hour = int.tryParse(parts[0]) ?? 0;
    final minute = int.tryParse(parts[1].replaceAll(RegExp(r'\D'), '')) ?? 0;
    return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
  }

  static String _toDisplayTime(String time) {
    final trimmed = time.trim();
    if (trimmed.isEmpty) return '';

    final upper = trimmed.toUpperCase();
    if (upper.contains('AM') || upper.contains('PM')) {
      return trimmed;
    }

    return _formatTime12h(trimmed);
  }

  static DateTime? _parse12Hour(String time) {
    for (final pattern in ['h:mm a', 'hh:mm a']) {
      try {
        return DateFormat(pattern).parseLoose(time);
      } catch (_) {}
    }
    return null;
  }

  static String _monthLabelForDays(List<ConsultationAvailabilityDayEntity> days) {
    final first = DateTime.tryParse(days.first.date);
    final last = DateTime.tryParse(days.last.date);
    if (first == null || last == null) return '';
    if (first.year == last.year && first.month == last.month) {
      return DateFormat('MMMM yyyy').format(first);
    }
    if (first.year == last.year) {
      return '${DateFormat('MMMM').format(first)} - ${DateFormat('MMMM yyyy').format(last)}';
    }
    return '${DateFormat('MMM yyyy').format(first)} - ${DateFormat('MMM yyyy').format(last)}';
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

  static double _readDouble(dynamic value) {
    if (value is num) return value.toDouble();
    return double.tryParse(value?.toString() ?? '') ?? 0;
  }

  static int _readInt(dynamic value) {
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }
}
