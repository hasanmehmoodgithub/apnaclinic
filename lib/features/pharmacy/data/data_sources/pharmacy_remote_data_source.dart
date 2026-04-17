import '../models/pharmacy_medicine_model.dart';

abstract class PharmacyRemoteDataSource {
  Future<PharmacyMedicinesResponseModel> getPharmacyMedicines();
}
