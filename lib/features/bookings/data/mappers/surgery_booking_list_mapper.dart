import 'package:intl/intl.dart';

import '../../../../core/utils/phone_format_utils.dart';
import '../../../consultation/presentation/constants/consultation_partner_filter_defaults.dart';
import '../../../surgery/domain/entities/surgery_lead_entity.dart';
import '../models/surgery_booking_list_item_model.dart';
import '../models/surgery_details_item.dart';

class SurgeryBookingListMapper {
  SurgeryBookingListMapper._();

  static SurgeryBookingListItemModel fromLead(SurgeryLeadEntity lead) {
    final fee = lead.fee;
    final discountAmount = lead.discount;
    final total = lead.total > 0
        ? lead.total
        : (fee > discountAmount ? fee - discountAmount : fee);
    final discountPercent = fee > 0 && discountAmount > 0
        ? ((discountAmount / fee) * 100).round()
        : 0;

    final bookingStatus = _mapStatus(
      status: lead.status,
      paymentAllowed: lead.paymentAllowed,
    );
    final hasScheduledDate =
        lead.scheduledDate != null && lead.scheduledDate!.trim().isNotEmpty;
    final appointment = hasScheduledDate
        ? _parseScheduledAppointment(
            scheduledDate: lead.scheduledDate!,
            scheduledStartTime: lead.scheduledStartTime,
            scheduledEndTime: lead.scheduledEndTime,
          )
        : const _AppointmentParts(
            day: '',
            month: '',
            weekday: '',
            time: '',
            full: '',
          );
    final isPending = bookingStatus == SurgeryBookingStatus.inReview ||
        bookingStatus == SurgeryBookingStatus.paymentPending;

    final hospital = lead.hospitalName.trim().isNotEmpty
        ? lead.hospitalName.trim()
        : '';

    return SurgeryBookingListItemModel(
      bookingId: lead.leadId,
      procedure: lead.surgeryType,
      hospital: hospital,
      doctor: lead.doctorName,
      specialty: lead.specialty,
      qualification: lead.education,
      status: _displayStatus(lead.status, bookingStatus),
      dateCreated: _formatCreatedDate(lead),
      initialStatus: bookingStatus,
      paymentAllowed: lead.paymentAllowed,
      procedureSubtitle: lead.subSurgeryType,
      patientName: lead.patientName,
      age: lead.age,
      gender: _formatGender(lead.gender),
      contactNumber: PhoneFormatUtils.toLocalDisplay(lead.phone),
      emergencyContact: PhoneFormatUtils.toLocalDisplay(lead.emergencyPhone),
      fee: fee,
      discountPercent: discountPercent,
      discountAmount: discountAmount,
      total: total,
      appointmentDay: appointment.day,
      appointmentMonth: appointment.month,
      appointmentWeekday: appointment.weekday,
      appointmentTime: hasScheduledDate
          ? (appointment.time.isNotEmpty
              ? appointment.time
              : lead.leadCreatedTime)
          : (isPending ? 'Applied On' : ''),
      appointmentSubtitle: hasScheduledDate
          ? 'Your appointment has been scheduled.'
          : 'Awaiting confirmation.',
      appointmentDateFull: hasScheduledDate
          ? (appointment.full.isNotEmpty
              ? appointment.full
              : lead.scheduledDate!.trim())
          : '',
      partnerLogoUrl: _resolvePartnerLogo(
        providerId: lead.providerId,
        providerName: lead.providerName,
        providerLogoUrl: lead.providerLogoUrl,
      ),
    );
  }

  static String _resolvePartnerLogo({
    required String providerId,
    required String providerName,
    required String providerLogoUrl,
  }) {
    final remote = providerLogoUrl.trim();
    if (remote.isNotEmpty) return remote;

    final knownById = ConsultationPartnerFilterDefaults.knownById(providerId);
    if (knownById != null && knownById.logoAsset.isNotEmpty) {
      return knownById.logoAsset;
    }

    final name = providerName.trim().toLowerCase();
    for (final partner in ConsultationPartnerFilterDefaults.partners) {
      if (partner.name.toLowerCase() == name && partner.logoAsset.isNotEmpty) {
        return partner.logoAsset;
      }
    }
    return '';
  }

  static SurgeryBookingStatus _mapStatus({
    required String status,
    required bool paymentAllowed,
  }) {
    final normalized = status.trim().toUpperCase();
    if (normalized == 'PAID' ||
        normalized.contains('CONFIRM') ||
        normalized.contains('COMPLETE')) {
      return SurgeryBookingStatus.confirmed;
    }
    if (paymentAllowed ||
        normalized.contains('PAYMENT') ||
        normalized == 'PENDING_PAYMENT') {
      return SurgeryBookingStatus.paymentPending;
    }
    return SurgeryBookingStatus.inReview;
  }

  static String _displayStatus(String rawStatus, SurgeryBookingStatus mapped) {
    final normalized = rawStatus.trim().toUpperCase();
    if (normalized == 'PENDING') return 'Pending';
    if (normalized == 'PAID') return 'Paid';
    if (normalized.isNotEmpty) return _titleCaseStatus(rawStatus);
    switch (mapped) {
      case SurgeryBookingStatus.paymentPending:
        return 'Payment Pending';
      case SurgeryBookingStatus.confirmed:
        return 'Paid';
      case SurgeryBookingStatus.inReview:
        return 'Pending';
    }
  }

  static String _titleCaseStatus(String raw) {
    final normalized = raw.trim().replaceAll('_', ' ').toLowerCase();
    if (normalized.isEmpty) return 'Pending';
    return normalized
        .split(' ')
        .where((part) => part.isNotEmpty)
        .map((part) => '${part[0].toUpperCase()}${part.substring(1)}')
        .join(' ');
  }

  static String _formatGender(String raw) {
    final normalized = raw.trim().toLowerCase();
    if (normalized == 'm' || normalized == 'male') return 'Male';
    if (normalized == 'f' || normalized == 'female') return 'Female';
    if (raw.isEmpty) return '';
    return _titleCaseStatus(raw);
  }

  static String _formatCreatedDate(SurgeryLeadEntity lead) {
    final parsed = _tryParseLeadDateTime(
          lead.leadCreatedAt.isNotEmpty
              ? lead.leadCreatedAt
              : lead.leadCreatedDate,
        ) ??
        _tryParseLeadDateTime(lead.leadCreatedDate);
    if (parsed != null) {
      return DateFormat('d MMM, yyyy').format(parsed);
    }
    return lead.leadCreatedAt.isNotEmpty
        ? lead.leadCreatedAt
        : lead.leadCreatedDate;
  }

  static _AppointmentParts _parseScheduledAppointment({
    required String scheduledDate,
    String? scheduledStartTime,
    String? scheduledEndTime,
  }) {
    final parsed = _tryParseLeadDateTime(scheduledDate);
    if (parsed == null) {
      return const _AppointmentParts(
        day: '',
        month: '',
        weekday: '',
        time: '',
        full: '',
      );
    }

    final day = DateFormat('d').format(parsed);
    final month = DateFormat('MMMM').format(parsed);
    final weekday = DateFormat('EEEE').format(parsed);
    final dayOrdinal = _dayOrdinal(parsed.day);
    final full =
        '$dayOrdinal ${DateFormat('MMMM').format(parsed)}, ${parsed.year}';
    final time = _formatScheduledTimeRange(
      scheduledStartTime: scheduledStartTime,
      scheduledEndTime: scheduledEndTime,
      legacyDateTimeRaw: scheduledDate,
      parsedDate: parsed,
    );

    return _AppointmentParts(
      day: day,
      month: month,
      weekday: weekday,
      time: time,
      full: full,
    );
  }

  static String _formatScheduledTimeRange({
    required String? scheduledStartTime,
    required String? scheduledEndTime,
    required String legacyDateTimeRaw,
    required DateTime parsedDate,
  }) {
    final start = scheduledStartTime?.trim() ?? '';
    final end = scheduledEndTime?.trim() ?? '';
    if (start.isNotEmpty && end.isNotEmpty) return '$start - $end';
    if (start.isNotEmpty) return start;
    if (end.isNotEmpty) return end;

    // Legacy: time was embedded in scheduledDate; ignore bogus midnight.
    if (_isMidnightScheduleArtifact(legacyDateTimeRaw, parsedDate)) {
      return '';
    }
    return DateFormat('hh:mm a').format(parsedDate);
  }

  static bool _isMidnightScheduleArtifact(String raw, DateTime parsed) {
    if (parsed.hour != 0 || parsed.minute != 0) return false;
    final trimmed = raw.trim();
    if (RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(trimmed)) return true;
    if (RegExp(r'12:00\s*AM', caseSensitive: false).hasMatch(trimmed)) {
      return true;
    }
    if (RegExp(r'\b00:00\b').hasMatch(trimmed)) return true;
    return false;
  }

  static DateTime? _tryParseLeadDateTime(String? raw) {
    if (raw == null) return null;
    final text = raw.trim();
    if (text.isEmpty) return null;

    final iso = DateTime.tryParse(text);
    if (iso != null) return iso;

    const patterns = <String>[
      'yyyy-MM-dd hh:mm a',
      'yyyy-MM-dd h:mm a',
      'yyyy-MM-dd HH:mm',
      'yyyy-MM-dd',
    ];
    for (final pattern in patterns) {
      try {
        return DateFormat(pattern).parseLoose(text);
      } catch (_) {}
    }

    final match = RegExp(
      r'^(\d{4})-(\d{2})-(\d{2})(?:\s+(\d{1,2}):(\d{2})\s*(AM|PM))?$',
      caseSensitive: false,
    ).firstMatch(text);
    if (match == null) return null;

    final year = int.tryParse(match.group(1)!);
    final month = int.tryParse(match.group(2)!);
    final day = int.tryParse(match.group(3)!);
    if (year == null || month == null || day == null) return null;

    var hour = int.tryParse(match.group(4) ?? '0') ?? 0;
    final minute = int.tryParse(match.group(5) ?? '0') ?? 0;
    final period = (match.group(6) ?? '').toUpperCase();
    if (period == 'PM' && hour < 12) hour += 12;
    if (period == 'AM' && hour == 12) hour = 0;

    return DateTime(year, month, day, hour, minute);
  }

  static String _dayOrdinal(int day) {
    if (day >= 11 && day <= 13) return '${day}th';
    switch (day % 10) {
      case 1:
        return '${day}st';
      case 2:
        return '${day}nd';
      case 3:
        return '${day}rd';
      default:
        return '${day}th';
    }
  }
}

class _AppointmentParts {
  const _AppointmentParts({
    required this.day,
    required this.month,
    required this.weekday,
    required this.time,
    required this.full,
  });

  final String day;
  final String month;
  final String weekday;
  final String time;
  final String full;
}
