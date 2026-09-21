import 'package:intl/intl.dart';

import '../../domain/entities/instant_doctor_booking_entity.dart';
import '../models/instant_doctor_booking_model.dart';

class InstantDoctorBookingMapper {
  InstantDoctorBookingMapper._();

  static InstantDoctorBookingsPageEntity toPageEntity(
    InstantDoctorBookingsPageModel model,
  ) {
    return InstantDoctorBookingsPageEntity(
      items: model.items.map(toEntity).toList(growable: false),
      page: model.page,
      limit: model.limit,
      total: model.total,
    );
  }

  static InstantDoctorBookingEntity toEntity(
    InstantDoctorBookingItemModel model,
  ) {
    final dateSource = model.bookingAt.isNotEmpty
        ? model.bookingAt
        : model.createdAt;
    return InstantDoctorBookingEntity(
      orderId: model.orderId,
      status: model.status,
      createdAt: model.createdAt,
      bookingAt: model.bookingAt,
      imageUrl: model.imageUrl,
      doctorName: model.doctorName,
      specialty: model.specialty,
      fee: model.fee,
      currency: model.currency,
      partnerId: model.partnerId,
      partnerName: model.partnerName,
      partnerImageUrl: model.partnerImageUrl,
      prescription: model.prescription,
      prescriptionUrl: model.prescriptionUrl,
      listDate: _formatListDate(dateSource),
      feeLabel: _formatFee(model.fee, model.currency),
    );
  }

  static String _formatListDate(String raw) {
    final parsed = DateTime.tryParse(raw);
    if (parsed == null) return raw.trim();
    return DateFormat('dd/MM/yy').format(parsed.toLocal());
  }

  static String _formatFee(double fee, String currency) {
    final amount = fee.truncateToDouble() == fee
        ? fee.toStringAsFixed(0)
        : fee.toStringAsFixed(2);
    if (fee <= 0) return 'Rs. 0/-';
    final prefix = currency.trim().toUpperCase() == 'PKR' ? 'Rs.' : currency;
    return '$prefix $amount/-';
  }
}
