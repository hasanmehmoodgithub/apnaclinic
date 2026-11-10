import '../domain/entities/pharmacy_cart_invalid_item_entity.dart';
import '../domain/pharmacy_api_error_codes.dart';
import 'pharmacy_api_failure.dart';

/// Extracts aggregator `data.code` / `data.errorCode` and optional `failedItems`.
class PharmacyApiErrorParser {
  PharmacyApiErrorParser._();

  static PharmacyApiFailure? fromResponseBody(
    Map<String, dynamic>? body, {
    required String fallbackMessage,
    int? statusCode,
  }) {
    if (body == null) return null;
    final message = (body['message'] ?? fallbackMessage).toString().trim();
    final data = body['data'];
    String? code;
    List<PharmacyCartInvalidItemEntity> failedItems = const [];

    if (data is Map) {
      final map = Map<String, dynamic>.from(data);
      final rawCode = map['code'] ?? map['errorCode'] ?? map['error_code'];
      if (rawCode != null) {
        code = rawCode.toString().trim();
      }
      failedItems = _parseFailedItems(map['failedItems'] ?? map['failed_items']);
    } else if (data is String && data.trim().isNotEmpty) {
      // Rare: code sent as plain data string.
      code = data.trim();
    }

    if ((code == null || code.isEmpty) && failedItems.isEmpty) {
      return null;
    }

    return PharmacyApiFailure(
      message: message.isNotEmpty ? message : fallbackMessage,
      code: code,
      statusCode: statusCode,
      failedItems: failedItems,
    );
  }

  static bool isCitySelectionFailure(Object error) {
    if (error is PharmacyApiFailure) {
      return PharmacyApiErrorCodes.isCitySelectionError(error.code);
    }
    return false;
  }

  static List<PharmacyCartInvalidItemEntity> _parseFailedItems(dynamic raw) {
    if (raw is! List) return const [];
    final items = <PharmacyCartInvalidItemEntity>[];
    for (final entry in raw) {
      if (entry is! Map) continue;
      final map = Map<String, dynamic>.from(entry);
      final rawId = map['productId'] ?? map['product_id'];
      final productId = rawId is int
          ? rawId
          : int.tryParse(rawId?.toString() ?? '') ?? 0;
      final name = (map['name'] ?? map['display_name'] ?? '').toString().trim();
      if (productId <= 0 && name.isEmpty) continue;
      items.add(
        PharmacyCartInvalidItemEntity(
          productId: productId,
          name: name,
          imageUrl: (map['imageUrl'] ?? map['image_url'] ?? '')
              .toString()
              .trim(),
          priceMismatch: map['priceMismatch'] == true ||
              map['price_mismatch'] == true,
          outOfStock:
              map['outOfStock'] == true || map['out_of_stock'] == true,
        ),
      );
    }
    return items;
  }
}
