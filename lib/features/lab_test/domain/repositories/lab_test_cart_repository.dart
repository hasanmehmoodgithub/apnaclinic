import '../entities/lab_test_cart_item.dart';

/// Local persistence for lab test cart JSON (same key as legacy screens).
abstract class LabTestCartRepository {
  Future<List<LabTestCartItem>> readCart();

  Future<void> writeCart(List<LabTestCartItem> items);
}
