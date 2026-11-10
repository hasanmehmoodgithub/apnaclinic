import 'package:equatable/equatable.dart';

/// Item rejected at checkout (`CART_ITEMS_INVALID` / `failedItems`).
class PharmacyCartInvalidItemEntity extends Equatable {
  const PharmacyCartInvalidItemEntity({
    required this.productId,
    required this.name,
    this.imageUrl = '',
    this.priceMismatch = false,
    this.outOfStock = false,
  });

  final int productId;
  final String name;
  final String imageUrl;
  final bool priceMismatch;
  final bool outOfStock;

  @override
  List<Object?> get props =>
      [productId, name, imageUrl, priceMismatch, outOfStock];
}
