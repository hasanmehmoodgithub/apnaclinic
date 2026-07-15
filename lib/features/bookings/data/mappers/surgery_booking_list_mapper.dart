import 'package:intl/intl.dart';

import '../../../../core/utils/phone_format_utils.dart';
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
    final appointmentSource = lead.scheduledDate ??
        lead.confirmedDate ??
        (lead.leadCreatedAt.isNotEmpty
            ? lead.leadCreatedAt
            : lead.leadCreatedDate);
    final appointment = _parseAppointment(appointmentSource);
    final isPending = bookingStatus == SurgeryBookingStatus.inReview ||
        bookingStatus == SurgeryBookingStatus.paymentPending;

    return SurgeryBookingListItemModel(
      bookingId: lead.leadId,
      procedure: lead.surgeryType,
      hospital: lead.providerName,
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
      appointmentTime: appointment.time.isNotEmpty
          ? appointment.time
          : (isPending ? 'Applied On' : ''),
      appointmentSubtitle: isPending && lead.scheduledDate == null
          ? 'Awaiting confirmation.'
          : 'Your appointment has been scheduled.',
      appointmentDateFull: appointment.full.isNotEmpty
          ? appointment.full
          : (lead.scheduledDate ?? lead.confirmedDate ?? ''),
      partnerLogoUrl: '',
    );
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

  static _AppointmentParts _parseAppointment(String? raw) {
    final parsed = _tryParseLeadDateTime(raw);
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
    final time = DateFormat('hh:mm a').format(parsed);
    final dayOrdinal = _dayOrdinal(parsed.day);
    final full = '$dayOrdinal ${DateFormat('MMMM').format(parsed)},'
        '${parsed.year}';

    return _AppointmentParts(
      day: day,
      month: month,
      weekday: weekday,
      time: time,
      full: full,
    );
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
    return null;
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
