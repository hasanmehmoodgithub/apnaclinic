class PharmacyMedicineEntity {
  const PharmacyMedicineEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.companyUrl,
    required this.price,
    required this.oldPrice,
    required this.manufacturer,
    required this.category,
    required this.prescriptionRequired,
    required this.genericName,
    required this.packageType,
    required this.indications,
    required this.contraIndications,
    required this.images,
  });

  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final String companyUrl;
  final double price;
  final double oldPrice;
  final String manufacturer;
  final String category;
  final bool prescriptionRequired;
  final String genericName;
  final String packageType;
  final String indications;
  final String contraIndications;
  final List<String> images;
}
