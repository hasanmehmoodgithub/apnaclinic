import 'package:intl/intl.dart';

import '../../../../core/l10n/app_localizations.dart';
import '../../../lab_test/domain/entities/lab_order_entity.dart';
import '../../../lab_test/domain/utils/lab_test_item_booking_helper.dart';
import '../../../lab_test/presentation/lab_test_route_args.dart';
import '../models/lab_test_booking_item_model.dart';

class LabTestBookingListMapper {
  LabTestBookingListMapper._();

  static LabTestBookingItemModel fromOrder(LabOrderEntity order) {
    final pricing = order.pricing;
    final invoice = order.invoice?.trim();
    final totalText = _formatAmount(pricing.total, pricing.currency);

    return LabTestBookingItemModel(
      orderId: order.orderId,
      publicId: order.publicId,
      orderType: order.orderType,
      sampleType: _rawSampleType(order),
      reportTitle: order.tests
          .map((t) => t.name)
          .where((n) => n.isNotEmpty)
          .join(', '),
      statusLabel: order.status,
      reportStatus: order.reportStatus,
      paymentMethod: order.paymentMethod,
      totalFee: totalText,
      discountedFee: totalText,
      // List / details show total only; keep original aligned to total.
      originalFee: totalText,
      dateLabel: _formatDate(
        order.placedAt.isNotEmpty ? order.placedAt : order.createdAt,
      ),
      labName: order.labName,
      labLogoUrl: order.labLogoUrl,
      partnerName: order.partnerName,
      partnerLogoUrl: order.partnerLogoUrl,
      patientName: order.patientName,
      patientAge: order.patientAge,
      patientGender: order.patientGender,
      patientPhone: order.patientPhone,
      tests: order.tests
          .map(
            (t) => LabTestBookingTestItem(
              name: t.name,
              price: t.price,
              status: t.status,
            ),
          )
          .toList(growable: false),
      discountCode: order.discountCode,
      partnerRef: order.partnerRef,
      invoice: (invoice != null && invoice.isNotEmpty) ? invoice : null,
    );
  }

  static LabTestViewDetailsContent toViewDetailsContent(
    LabOrderEntity order,
    AppLocalizations l10n,
  ) {
    final booking = fromOrder(order);
    final tests = order.tests
        .map(
          (t) => LabTestViewDetailsTestLine(
            name: t.name.trim(),
            fee: _formatAmount(t.price, order.pricing.currency),
            status: t.status,
          ),
        )
        .where((t) => t.name.isNotEmpty)
        .toList(growable: false);
    final invoice = booking.invoice?.trim();
    return LabTestViewDetailsContent(
      testTitle: booking.reportTitle,
      tests: tests.isNotEmpty
          ? tests
          : [
              LabTestViewDetailsTestLine(
                name: booking.reportTitle,
                fee: booking.discountedFee,
                status: booking.statusLabel,
              ),
            ],
      labName: booking.labName,
      labLogoUrl: booking.labLogoUrl,
      partnerLogoUrl: booking.partnerLogoUrl,
      sampleType: sampleTypeLabel(booking.sampleType, l10n),
      orderTypeLabel: orderTypeLabel(booking.orderType, l10n),
      discountedFee: booking.discountedFee,
      originalFee: booking.originalFee,
      discountCode: booking.discountCode,
      patientName: booking.patientName,
      orderId: order.orderId,
      orderNo: booking.orderNo,
      bookingDate: booking.dateLabel,
      statusLabel: booking.statusLabel,
      note: _reportNote(order.reportStatus, l10n),
      invoiceUrl: (invoice != null && invoice.isNotEmpty) ? invoice : null,
      reportUrls: order.reports
          .map((url) => url.trim())
          .where((url) => url.isNotEmpty)
          .toList(growable: false),
    );
  }

  /// Biological `sampleType` (Blood / Urine).
  static String sampleTypeLabel(String raw, AppLocalizations l10n) {
    final formatted = _formatSampleType(raw);
    if (formatted.isNotEmpty) return formatted;
    return l10n.labTestSampleTypeNotAvailable;
  }

  /// Booking method from API `orderType` (`WALK_IN` / `HOME_SAMPLING`).
  static String orderTypeLabel(String raw, AppLocalizations l10n) {
    switch (raw.trim().toUpperCase()) {
      case LabTestItemBookingHelper.orderTypeWalkIn:
        return l10n.labTestBookingMethodWalkIn;
      case LabTestItemBookingHelper.orderTypeHomeSampling:
        return l10n.labTestBookingMethodHomeSample;
      default:
        return l10n.labTestSampleTypeNotAvailable;
    }
  }

  static String _rawSampleType(LabOrderEntity order) {
    final fromOrder = order.sampleType.trim();
    if (fromOrder.isNotEmpty) return fromOrder;
    for (final test in order.tests) {
      final fromTest = test.sampleType.trim();
      if (fromTest.isNotEmpty) return fromTest;
    }
    return '';
  }

  static String _formatSampleType(String raw) {
    final trimmed = raw.trim();
    if (trimmed.isEmpty) return '';
    return trimmed
        .toLowerCase()
        .split(RegExp(r'\s+'))
        .where((part) => part.isNotEmpty)
        .map((part) => '${part[0].toUpperCase()}${part.substring(1)}')
        .join(' ');
  }

  static String _reportNote(String reportStatus, AppLocalizations l10n) {
    switch (reportStatus.trim().toUpperCase()) {
      case 'AVAILABLE':
      case 'READY':
        return l10n.labTestReportAvailableNote;
      default:
        return l10n.labTestReportPendingNote;
    }
  }

  static String _formatAmount(int amount, String currency) {
    final formatted = NumberFormat('#,##0').format(amount);
    final prefix = currency.trim().toUpperCase() == 'PKR'
        ? 'Rs.'
        : currency.trim();
    return '$prefix $formatted/-';
  }

  static String _formatDate(String raw) {
    final parsed = _tryParseDateTime(raw);
    if (parsed != null) {
      return DateFormat('d MMM, yyyy').format(parsed);
    }
    return raw;
  }

  static DateTime? _tryParseDateTime(String raw) {
    final text = raw.trim();
    if (text.isEmpty) return null;

    final iso = DateTime.tryParse(text);
    if (iso != null) return iso;

    const patterns = <String>['yyyy-MM-dd HH:mm', 'yyyy-MM-dd'];
    for (final pattern in patterns) {
      try {
        return DateFormat(pattern).parseLoose(text);
      } catch (_) {}
    }
    return null;
  }
}
