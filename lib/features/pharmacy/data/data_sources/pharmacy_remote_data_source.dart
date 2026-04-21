import '../models/pharmacy_medicine_model.dart';

abstract class PharmacyRemoteDataSource {
  Future<PharmacyMedicinesResponseModel> getPharmacyMedicines();
  Future<PharmacyCartResponseModel> getPharmacyCart();
  Future<Map<String, dynamic>> addToCart({
    required String medicineId,
    required int quantity,
  });
}
