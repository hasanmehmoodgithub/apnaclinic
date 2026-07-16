import 'pharmacy_medicine_entity.dart';

class PharmacyCartItemEntity {
  const PharmacyCartItemEntity({
    required this.medicine,
    required this.quantity,
    this.lineId = '',
    this.unitPrice,
    this.lineTotal,
  });

  final PharmacyMedicineEntity medicine;
  final int quantity;
  final String lineId;
  final double? unitPrice;
  final double? lineTotal;

  PharmacyCartItemEntity copyWith({
    PharmacyMedicineEntity? medicine,
    int? quantity,
    String? lineId,
    double? unitPrice,
    double? lineTotal,
  }) {
    return PharmacyCartItemEntity(
      medicine: medicine ?? this.medicine,
      quantity: quantity ?? this.quantity,
      lineId: lineId ?? this.lineId,
      unitPrice: unitPrice ?? this.unitPrice,
      lineTotal: lineTotal ?? this.lineTotal,
    );
  }

  double get displayUnitPrice => unitPrice ?? medicine.price;

  double get total {
    if (lineTotal != null && lineTotal! > 0) return lineTotal!;
    return displayUnitPrice * quantity;
  }
}
