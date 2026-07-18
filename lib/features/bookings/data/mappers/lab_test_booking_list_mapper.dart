import 'package:intl/intl.dart';

import '../../../../core/l10n/app_localizations.dart';
import '../../../lab_test/domain/entities/lab_order_entity.dart';
import '../../../lab_test/presentation/lab_test_route_args.dart';
import '../models/lab_test_booking_item_model.dart';

class LabTestBookingListMapper {
  LabTestBookingListMapper._();

  /// Temporary sample PDF until the API always returns `invoice`.
  static const String mockInvoicePdfUrl =
      'https://medicalguidelines.msf.org/sites/default/files/2026-05/guideline-170-en.pdf';

  static LabTestBookingItemModel fromOrder(LabOrderEntity order) {
    final pricing = order.pricing;
    final isConfirmed = _isConfirmedStatus(order.status);
    final invoice = order.invoice?.trim();

    return LabTestBookingItemModel(
      orderId: order.orderId,
      publicId: order.publicId,
      orderType: order.orderType,
      reportTitle: order.tests.map((t) => t.name).where((n) => n.isNotEmpty).join(', '),
      statusLabel: _displayStatus(order.status),
      reportStatus: order.reportStatus,
      paymentMethod: order.paymentMethod,
      isConfirmed: isConfirmed,
      totalFee: _formatAmount(pricing.total, pricing.currency),
      discountedFee: _formatAmount(pricing.total, pricing.currency),
      originalFee: _formatAmount(pricing.subtotal, pricing.currency),
      dateLabel: _formatDate(order.placedAt.isNotEmpty ? order.placedAt : order.createdAt),
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
            (t) => LabTestBookingTestItem(name: t.name, price: t.price, status: t.status),
          )
          .toList(growable: false),
      discountCode: order.discountCode,
      partnerRef: order.partnerRef,
      invoice: (invoice != null && invoice.isNotEmpty) ? invoice : mockInvoicePdfUrl,
    );
  }

  static LabTestViewDetailsContent toViewDetailsContent(
    LabOrderEntity order,
    AppLocalizations l10n,
  ) {
    final booking = fromOrder(order);
    final invoice = booking.invoice?.trim();
    return LabTestViewDetailsContent(
      testTitle: booking.reportTitle,
      labName: booking.labName,
      labLogoUrl: booking.labLogoUrl,
      partnerLogoUrl: booking.partnerLogoUrl,
      sampleType: l10n.labTestSampleTypeNotAvailable,
      discountedFee: booking.discountedFee,
      originalFee: booking.originalFee,
      discountCode: booking.discountCode,
      patientName: booking.patientName,
      orderNo: booking.orderNo,
      bookingDate: booking.dateLabel,
      statusLabel: booking.statusLabel,
      note: _reportNote(booking.reportStatus, l10n),
      invoiceUrl:
          (invoice != null && invoice.isNotEmpty) ? invoice : mockInvoicePdfUrl,
    );
  }

  static String _reportNote(String reportStatus, AppLocalizations l10n) {
    if (reportStatus.trim().toUpperCase() == 'AVAILABLE') {
      return l10n.labTestReportAvailableNote;
    }
    return l10n.labTestReportPendingNote;
  }

  static bool _isConfirmedStatus(String status) {
    final normalized = status.trim().toUpperCase();
    return normalized != 'CANCELLED' &&
        normalized != 'CANCELED' &&
        normalized != 'REJECTED' &&
        normalized != 'FAILED';
  }

  static String _displayStatus(String raw) {
    final normalized = raw.trim().replaceAll('_', ' ').toLowerCase();
    if (normalized.isEmpty) return 'Placed';
    return normalized
        .split(' ')
        .where((part) => part.isNotEmpty)
        .map((part) => '${part[0].toUpperCase()}${part.substring(1)}')
        .join(' ');
  }

  static String _formatAmount(int amount, String currency) {
    final formatted = NumberFormat('#,##0').format(amount);
    final prefix = currency.trim().toUpperCase() == 'PKR' ? 'Rs.' : currency.trim();
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

    const patterns = <String>[
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
}
