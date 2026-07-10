import 'pharmacy_medicine_entity.dart';

class PharmacyProductDetailEntity {
  const PharmacyProductDetailEntity({
    required this.product,
    required this.relatedItems,
  });

  final PharmacyMedicineEntity product;
  final List<PharmacyMedicineEntity> relatedItems;
}
