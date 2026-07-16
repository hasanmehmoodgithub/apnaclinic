import '../../domain/entities/lab_order_entity.dart';
import '../models/lab_order_model.dart';

class LabOrdersMapper {
  const LabOrdersMapper._();

  static LabOrdersPageEntity toPageEntity(LabOrdersPageModel model) {
    return LabOrdersPageEntity(
      items: model.items.map(_toEntity).toList(growable: false),
      page: model.page,
      limit: model.limit,
      total: model.total,
    );
  }

  static LabOrderEntity _toEntity(LabOrderModel model) {
    return LabOrderEntity(
      orderId: model.orderId,
      publicId: model.publicId,
      orderType: model.orderType,
      status: model.status,
      reportStatus: model.reportStatus,
      paymentMethod: model.paymentMethod,
      discountCode: model.discountCode,
      partnerRef: model.partnerRef,
      labName: model.lab.name,
      labLogoUrl: model.lab.logoUrl,
      partnerName: model.partner.name,
      partnerLogoUrl: model.partner.logoUrl,
      patientName: model.patient.name,
      patientAge: model.patient.age,
      patientGender: model.patient.gender,
      patientPhone: model.patient.phone,
      tests: model.tests
          .map(
            (t) => LabOrderTestEntity(name: t.name, price: t.price, status: t.status),
          )
          .toList(growable: false),
      pricing: LabOrderPricingEntity(
        subtotal: model.pricing.subtotal,
        discount: model.pricing.discount,
        homeSamplingFee: model.pricing.homeSamplingFee,
        total: model.pricing.total,
        currency: model.pricing.currency,
      ),
      reports: model.reports,
      invoice: model.invoice,
      placedAt: model.placedAt,
      createdAt: model.createdAt,
    );
  }
}
