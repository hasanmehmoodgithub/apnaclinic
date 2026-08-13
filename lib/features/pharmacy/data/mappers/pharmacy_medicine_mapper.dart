import '../../domain/entities/pharmacy_add_address_result_entity.dart';
import '../../domain/entities/pharmacy_add_to_cart_result_entity.dart';
import '../../domain/entities/pharmacy_cart_address_entity.dart';
import '../../domain/entities/pharmacy_cart_entity.dart';
import '../../domain/entities/pharmacy_cart_item_entity.dart';
import '../../domain/entities/pharmacy_checkout_result_entity.dart';
import '../../domain/entities/pharmacy_medicine_entity.dart';
import '../../domain/entities/pharmacy_payment_breakdown_entity.dart';
import '../../domain/entities/pharmacy_products_page_entity.dart';
import '../../domain/entities/pharmacy_product_detail_entity.dart';
import '../models/pharmacy_medicine_model.dart';

class PharmacyMedicineMapper {
  static PharmacyMedicineEntity toEntity(PharmacyMedicineModel model) {
    return PharmacyMedicineEntity(
      id: model.id,
      name: model.name,
      description: model.description,
      imageUrl: model.imageUrl,
      companyUrl: model.companyUrl,
      price: model.price,
      oldPrice: model.oldPrice,
      manufacturer: model.manufacturer,
      category: model.category,
      prescriptionRequired: model.prescriptionRequired,
      genericName: model.genericName,
      packageType: model.packageType,
      indications: model.indications,
      contraIndications: model.contraIndications,
      images: model.images,
    );
  }

  static List<PharmacyMedicineEntity> toEntityList(
    List<PharmacyMedicineModel> models,
  ) {
    return models.map(toEntity).toList(growable: false);
  }

  static PharmacyProductsPageEntity toProductsPageEntity(
    PharmacyProductsPageModel model,
  ) {
    return PharmacyProductsPageEntity(
      items: toEntityList(model.medicines),
      currentPage: model.currentPage,
      lastPage: model.lastPage,
      total: model.total,
      hasNextPage: model.hasNextPage,
    );
  }

  static PharmacyProductDetailEntity toProductDetailEntity(
    PharmacyProductDetailModel model,
  ) {
    return PharmacyProductDetailEntity(
      product: toEntity(model.product),
      relatedItems: toEntityList(model.relatedItems),
    );
  }

  static PharmacyCartItemEntity toCartItemEntity(PharmacyCartItemModel item) {
    return PharmacyCartItemEntity(
      medicine: toEntity(item.medicine),
      quantity: item.quantity,
      lineId: item.lineId,
      unitPrice: item.unitPrice,
      lineTotal: item.lineTotal,
      prescriptionUrl: item.prescriptionUrl,
    );
  }

  static PharmacyPaymentBreakdownEntity? toPaymentBreakdownEntity(
    PharmacyPaymentBreakdownModel? model,
  ) {
    if (model == null) return null;
    return PharmacyPaymentBreakdownEntity(
      deliveryCharges: model.deliveryCharges,
      discount: model.discount,
      total: model.total,
      subtotal: model.subtotal,
      discountPercent: model.discountPercent,
    );
  }

  static PharmacyCartEntity toCartEntity(PharmacyCartResponseModel model) {
    return PharmacyCartEntity(
      bookingId: model.bookingId,
      items: toCartItemEntityList(model),
      paymentBreakdown: toPaymentBreakdownEntity(model.paymentBreakdown),
      addresses: model.addresses
          .map(
            (item) => PharmacyCartAddressEntity(
              id: item.id,
              address: item.address,
              region: item.region,
              cityId: item.cityId,
              isDefault: item.isDefault,
            ),
          )
          .toList(growable: false),
    );
  }

  static PharmacyAddToCartResultEntity toAddToCartResultEntity(
    PharmacyCartResponseModel model,
  ) {
    return PharmacyAddToCartResultEntity(
      message: model.message,
      bookingId: model.bookingId,
      items: toCartItemEntityList(model),
      hasProductList: model.hasProductList,
    );
  }

  static PharmacyCheckoutResultEntity toCheckoutResultEntity(
    Map<String, dynamic> response,
  ) {
    final payload = _unwrapCheckoutPayload(response);
    final bookingId = _stringOrNull(
      payload['booking_id'] ?? payload['bookingId'],
    );
    final orderNo = _stringOrNull(
          payload['order_no'] ??
              payload['orderNo'] ??
              payload['order_id'] ??
              payload['orderId'],
        ) ??
        bookingId ??
        '';
    final status = _stringOrNull(payload['status']) ?? 'confirmed';
    final paymentUrl = _stringOrNull(
      payload['paymentUrl'] ?? payload['payment_url'],
    );

    return PharmacyCheckoutResultEntity(
      orderNo: orderNo,
      bookingId: bookingId,
      status: status,
      paymentUrl: paymentUrl,
    );
  }

  static PharmacyAddAddressResultEntity toAddAddressResultEntity(
    Map<String, dynamic> response,
  ) {
    final payload = _unwrapCheckoutPayload(response);
    return PharmacyAddAddressResultEntity(
      id: _stringOrNull(
        payload['address_id'] ??
            payload['addressId'] ??
            payload['id'],
      ),
      address: _stringOrNull(
            payload['line1'] ??
                payload['address'] ??
                payload['full_address'] ??
                payload['fullAddress'],
          ) ??
          '',
      region: _stringOrNull(
            payload['city_name'] ??
                payload['cityName'] ??
                payload['region'] ??
                payload['city'],
          ) ??
          '',
    );
  }

  static Map<String, dynamic> _unwrapCheckoutPayload(
    Map<String, dynamic> response,
  ) {
    final data = response['data'];
    if (data is Map<String, dynamic>) {
      final nested = data['data'];
      if (nested is Map<String, dynamic>) return nested;
      return data;
    }
    return response;
  }

  static String? _stringOrNull(Object? value) {
    if (value == null) return null;
    final text = value.toString().trim();
    return text.isEmpty ? null : text;
  }

  /// Parses prescription upload response for a stored file URL.
  static String prescriptionUrlFromUploadResponse(
    Map<String, dynamic> response,
  ) {
    final data = _unwrapCheckoutPayload(response);
    final candidates = <Object?>[
      data['url'],
      data['prescription_url'],
      data['prescriptionUrl'],
      data['file_url'],
      data['fileUrl'],
      data['path'],
    ];
    for (final candidate in candidates) {
      final url = _stringOrNull(candidate);
      if (url != null) return url;
    }
    return '';
  }

  static List<PharmacyCartItemEntity> toCartItemEntityList(
    PharmacyCartResponseModel model,
  ) {
    return model.items.map(toCartItemEntity).toList();
  }
}
