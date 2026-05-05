import 'dart:convert';

import '../../../../core/preference/app_pref.dart';
import '../../domain/entities/lab_test_cart_item.dart';
import '../../domain/repositories/lab_test_cart_repository.dart';

class LabTestCartRepositoryImpl implements LabTestCartRepository {
  LabTestCartRepositoryImpl(this._appPref);

  final AppPref _appPref;

  static const String _cartPrefKey = 'lab_test_cart_items';

  @override
  Future<List<LabTestCartItem>> readCart() async {
    final raw = _appPref.getString(_cartPrefKey)?.trim();
    if (raw == null || raw.isEmpty) return <LabTestCartItem>[];
    try {
      final decoded = jsonDecode(raw);
      if (decoded is! List) return <LabTestCartItem>[];
      return decoded
          .whereType<Map<String, dynamic>>()
          .map(LabTestCartItem.fromJson)
          .toList(growable: false);
    } catch (_) {
      return <LabTestCartItem>[];
    }
  }

  @override
  Future<void> writeCart(List<LabTestCartItem> items) async {
    final payload = items.map((e) => e.toJson()).toList(growable: false);
    await _appPref.setString(_cartPrefKey, jsonEncode(payload));
  }
}
