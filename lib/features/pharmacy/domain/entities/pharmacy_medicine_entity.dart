class PharmacyMedicineEntity {
  const PharmacyMedicineEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.price,
    required this.oldPrice,
  });

  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final double price;
  final double oldPrice;
}
