import 'package:intl/intl.dart';

import '../../../../core/l10n/app_localizations.dart';
import '../../../lab_test/domain/entities/lab_order_entity.dart';
import '../../../lab_test/presentation/lab_test_route_args.dart';
import '../models/lab_test_booking_item_model.dart';

class LabTestBookingListMapper {
  LabTestBookingListMapper._();

  static LabTestBookingItemModel fromOrder(LabOrderEntity order) {
    final pricing = order.pricing;
    final invoice = order.invoice?.trim();

    return LabTestBookingItemModel(
      orderId: order.orderId,
      publicId: order.publicId,
      orderType: order.orderType,
      reportTitle: order.tests
          .map((t) => t.name)
          .where((n) => n.isNotEmpty)
          .join(', '),
      statusLabel: order.status,
      reportStatus: order.reportStatus,
      paymentMethod: order.paymentMethod,
      totalFee: _formatAmount(pricing.total, pricing.currency),
      discountedFee: _formatAmount(pricing.total, pricing.currency),
      originalFee: _formatAmount(pricing.subtotal, pricing.currency),
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
      sampleType: _orderTypeLabel(order.orderType, l10n),
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

  /// Maps API `orderType` (`HOME_SAMPLING` / `WALK_IN`) for the Sample Type pill.
  static String _orderTypeLabel(String orderType, AppLocalizations l10n) {
    switch (orderType.trim().toUpperCase()) {
      case 'HOME_SAMPLING':
        return l10n.labTestBookingMethodHomeSample;
      case 'WALK_IN':
        return l10n.labTestBookingMethodWalkIn;
      default:
        final raw = orderType.trim();
        return raw.isEmpty ? l10n.labTestSampleTypeNotAvailable : raw;
    }
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
