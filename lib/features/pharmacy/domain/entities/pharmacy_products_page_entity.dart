import 'pharmacy_medicine_entity.dart';

class PharmacyProductsPageEntity {
  const PharmacyProductsPageEntity({
    required this.items,
    required this.currentPage,
    required this.lastPage,
    required this.total,
  });

  final List<PharmacyMedicineEntity> items;
  final int currentPage;
  final int lastPage;
  final int total;

  bool get hasMore => currentPage < lastPage;
}
