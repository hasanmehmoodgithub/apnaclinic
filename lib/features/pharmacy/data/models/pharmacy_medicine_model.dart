class PharmacyMedicineModel {
  const PharmacyMedicineModel({
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

  factory PharmacyMedicineModel.fromJson(Map<String, dynamic> json) {
    return PharmacyMedicineModel(
      id: (json['id'] ?? '').toString(),
      name: (json['name'] ?? '').toString(),
      description: (json['description'] ?? '').toString(),
      imageUrl: (json['imageUrl'] ?? '').toString(),
      price: (json['price'] as num?)?.toDouble() ?? 0,
      oldPrice: (json['oldPrice'] as num?)?.toDouble() ?? 0,
    );
  }
}

class PharmacyMedicinesResponseModel {
  const PharmacyMedicinesResponseModel({
    required this.success,
    required this.message,
    required this.medicines,
  });

  final bool success;
  final String message;
  final List<PharmacyMedicineModel> medicines;

  factory PharmacyMedicinesResponseModel.fromJson(Map<String, dynamic> json) {
    final rawList = json['medicines'] ?? json['data'] ?? <dynamic>[];
    final list = (rawList is List ? rawList : <dynamic>[])
        .whereType<Map<String, dynamic>>()
        .map(PharmacyMedicineModel.fromJson)
        .toList();

    return PharmacyMedicinesResponseModel(
      success: json['success'] == true,
      message: (json['message'] ?? '').toString(),
      medicines: list,
    );
  }
}
