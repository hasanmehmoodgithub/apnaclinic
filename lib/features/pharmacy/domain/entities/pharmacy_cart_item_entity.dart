import 'pharmacy_medicine_entity.dart';

class PharmacyCartItemEntity {
  const PharmacyCartItemEntity({
    required this.medicine,
    required this.quantity,
  });

  final PharmacyMedicineEntity medicine;
  final int quantity;

  PharmacyCartItemEntity copyWith({
    PharmacyMedicineEntity? medicine,
    int? quantity,
  }) {
    return PharmacyCartItemEntity(
      medicine: medicine ?? this.medicine,
      quantity: quantity ?? this.quantity,
    );
  }

  double get total => medicine.price * quantity;
}
