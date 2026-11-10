/// Aggregator pharmacy error codes (`data.code` or `data.errorCode`).
class PharmacyApiErrorCodes {
  PharmacyApiErrorCodes._();

  static const pharmacyCityNotServed = 'PHARMACY_CITY_NOT_SERVED';
  static const pharmacyCityInvalid = 'PHARMACY_CITY_INVALID';
  static const pharmacyCityMismatch = 'PHARMACY_CITY_MISMATCH';
  static const cartItemsInvalid = 'CART_ITEMS_INVALID';

  static bool isCitySelectionError(String? code) {
    final normalized = (code ?? '').trim().toUpperCase();
    return normalized == pharmacyCityNotServed ||
        normalized == pharmacyCityInvalid;
  }
}
