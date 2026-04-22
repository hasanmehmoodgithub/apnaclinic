import '../../domain/entities/pharmacy_medicine_entity.dart';
import '../../domain/entities/pharmacy_cart_item_entity.dart';
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
    );
  }

  static List<PharmacyMedicineEntity> toEntityList(
    PharmacyMedicinesResponseModel model,
  ) {
    return model.medicines.map(toEntity).toList();
  }

  static PharmacyCartItemEntity toCartItemEntity(PharmacyCartItemModel item) {
    return PharmacyCartItemEntity(
      medicine: toEntity(item.medicine),
      quantity: item.quantity,
    );
  }

  static List<PharmacyCartItemEntity> toCartItemEntityList(
    PharmacyCartResponseModel model,
  ) {
    return model.items.map(toCartItemEntity).toList();
  }
}
