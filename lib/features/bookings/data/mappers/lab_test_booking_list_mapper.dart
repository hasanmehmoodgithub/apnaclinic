import 'package:intl/intl.dart';

import '../../../lab_test/domain/entities/lab_order_entity.dart';
import '../models/lab_test_booking_item_model.dart';

class LabTestBookingListMapper {
  LabTestBookingListMapper._();

  static LabTestBookingItemModel fromOrder(LabOrderEntity order) {
    final pricing = order.pricing;
    final isConfirmed = _isConfirmedStatus(order.status);

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
    );
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
