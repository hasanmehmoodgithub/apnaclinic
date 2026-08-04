import '../../domain/entities/pharmacy_booking_entity.dart';
import '../../domain/entities/pharmacy_booking_detail_entity.dart';
import '../models/pharmacy_booking_detail_model.dart';
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
      orderNo: model.orderNo,
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

  static PharmacyBookingDetailEntity toDetailEntity(
    PharmacyBookingDetailModel model,
  ) {
    return PharmacyBookingDetailEntity(
      type: model.type,
      orderId: model.orderId,
      orderNo: model.orderNo,
      status: model.status,
      statusTimeline: model.statusTimeline
          .map(
            (step) => PharmacyBookingTimelineStepEntity(
              label: step.label,
              completed: step.completed,
            ),
          )
          .toList(growable: false),
      items: model.items
          .map(
            (item) => PharmacyBookingLineItemEntity(
              productName: item.productName,
              quantity: item.quantity,
              unitPrice: item.unitPrice,
              lineTotal: item.lineTotal,
              imageUrl: item.imageUrl,
            ),
          )
          .toList(growable: false),
      subtotal: model.subtotal,
      deliveryCharge: model.deliveryCharge,
      discount: model.discount,
      discountPercent: model.discountPercent,
      total: model.total,
      currency: model.currency,
      paymentMethod: model.paymentMethod,
      deliveryAddress: model.deliveryAddress,
      city: model.city,
      invoiceUrl: model.invoiceUrl,
      messageAlert: model.messageAlert,
    );
  }
}
