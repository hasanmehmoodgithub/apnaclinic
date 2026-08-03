import '../../domain/entities/pharmacy_booking_entity.dart';
import '../models/pharmacy_booking_model.dart';

class PharmacyBookingsMapper {
  PharmacyBookingsMapper._();

  static PharmacyBookingsPageEntity toPageEntity(
    PharmacyBookingsPageModel model,
  ) {
    return PharmacyBookingsPageEntity(
      items: model.items.map(toEntity).toList(growable: false),
      page: model.page,
      limit: model.limit,
      total: model.total,
    );
  }

  static PharmacyBookingEntity toEntity(PharmacyBookingItemModel model) {
    return PharmacyBookingEntity(
      orderId: model.orderId,
      productName: model.productName,
      imageUrl: model.imageUrl,
      quantity: model.quantity,
      unitPrice: model.unitPrice,
      total: model.total,
      currency: model.currency,
      status: model.status,
      createdAt: model.createdAt,
    );
  }
}
