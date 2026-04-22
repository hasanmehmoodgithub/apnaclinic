import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/dependency_injection.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/preference/app_pref.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/widgets/app_scaffold_gradient.dart';
import '../lab_test_route_args.dart';

class LabTestCartScreen extends StatefulWidget {
  const LabTestCartScreen({super.key});

  @override
  State<LabTestCartScreen> createState() => _LabTestCartScreenState();
}

class _LabTestCartScreenState extends State<LabTestCartScreen> {
  static const String _cartPrefKey = 'lab_test_cart_items';
  final AppPref _appPref = sl<AppPref>();
  List<LabTestCartItem> _items = <LabTestCartItem>[];

  @override
  void initState() {
    super.initState();
    _items = _readCartItems();
  }

  List<LabTestCartItem> _readCartItems() {
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

  Future<void> _persist() async {
    final payload = _items.map((e) => e.toJson()).toList(growable: false);
    await _appPref.setString(_cartPrefKey, jsonEncode(payload));
  }

  Future<void> _removeAt(int index) async {
    if (index < 0 || index >= _items.length) return;
    setState(() => _items = List<LabTestCartItem>.from(_items)..removeAt(index));
    await _persist();
  }

  void _proceedCheckout() {
    if (_items.isEmpty) return;
    context.push(
      AppRoutes.path(AppRoutes.labTestCheckout),
      extra: _items.first.toCheckoutArgs(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppScaffoldGradient(
      child: Column(
        children: [
          _CartHeader(theme: theme),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(42)),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 12),
                child: Column(
                  children: [
                    Expanded(
                      child: _items.isEmpty
                          ? Center(
                              child: Text(
                                'No items in cart',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: const Color(0xFF667B99),
                                  fontSize: 14.sp,
                                ),
                              ),
                            )
                          : ListView.separated(
                              itemCount: _items.length,
                              separatorBuilder: (_, _) => const SizedBox(height: 12),
                              itemBuilder: (context, index) {
                                return _CartItemCard(
                                  item: _items[index],
                                  onRemove: () => _removeAt(index),
                                );
                              },
                            ),
                    ),
                    _CartBottomBar(
                      enabled: _items.isNotEmpty,
                      onProceed: _proceedCheckout,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CartHeader extends StatelessWidget {
  const _CartHeader({required this.theme});

  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 4, 16, 18),
      child: Row(
        children: [
          Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () => context.pop(),
              child: const SizedBox(
                width: 40,
                height: 40,
                child: Icon(
                  Icons.arrow_back_rounded,
                  color: Color(0xFF061E40),
                  size: 24,
                ),
              ),
            ),
          ),
          Expanded(
            child: Text(
              'Cart',
              textAlign: TextAlign.center,
              style: theme.textTheme.titleLarge?.copyWith(
                color: const Color(0xFF061E40),
                fontWeight: FontWeight.w700,
                fontSize: 20.sp,
              ),
            ),
          ),
          const SizedBox(width: 40),
        ],
      ),
    );
  }
}

class _CartItemCard extends StatelessWidget {
  const _CartItemCard({required this.item, required this.onRemove});

  final LabTestCartItem item;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFEDE4E4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(14, 12, 10, 10),
            decoration: const BoxDecoration(
              color: Color(0xFFF5F5F5),
              borderRadius: BorderRadius.vertical(top: Radius.circular(14)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    item.testTitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: const Color(0xFF111827),
                      fontWeight: FontWeight.w500,
                      fontSize: 17.sp,
                    ),
                  ),
                ),
                InkWell(
                  onTap: onRemove,
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFFF0F0F0),
                    ),
                    alignment: Alignment.center,
                    child: const Icon(Icons.close, size: 14, color: Color(0xFF8D8D8D)),
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.labDisplayName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: const Color(0xFF4B5B72),
                    fontSize: 13.sp,
                  ),
                ),
                const SizedBox(height: 10),
                Divider(height: 1, color: const Color(0xFFE4E7EC)),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Text(
                      'Sample Type',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: const Color(0xFF2F3E54),
                        fontSize: 13.sp,
                      ),
                    ),
                    const SizedBox(width: 6),
                    _CartInfoPill(value: item.sampleType),
                    const Spacer(),
                    _CartPricePill(
                      originalFee: item.originalFee,
                      discountedFee: item.discountedFee,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CartInfoPill extends StatelessWidget {
  const _CartInfoPill({required this.value});
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(59),
        border: Border.all(color: const Color(0xFFE7E7E7), width: 1.0),
      ),
      child: Text(
        value,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: const Color(0xFF9A9A9A),
          fontSize: 13.sp,
          height: 1.1,
        ),
      ),
    );
  }
}

class _CartPricePill extends StatelessWidget {
  const _CartPricePill({required this.originalFee, required this.discountedFee});
  final String originalFee;
  final String discountedFee;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: const Color(0xFFE0E3E8), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 7, 12, 7),
            child: Text(
              originalFee,
              style: theme.textTheme.bodySmall?.copyWith(
                color: const Color(0xFFA5A5A5),
                decoration: TextDecoration.lineThrough,
                decorationThickness: 1.5,
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Transform.translate(
            offset: const Offset(-6, 0),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
              decoration: BoxDecoration(
                color: const Color(0xFF11B2A4),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Text(
                discountedFee,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.white,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CartBottomBar extends StatelessWidget {
  const _CartBottomBar({required this.enabled, required this.onProceed});

  final bool enabled;
  final VoidCallback onProceed;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.only(top: 14, bottom: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: double.infinity,
              height: 57,
              child: FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFF0FAA9A),
                  disabledBackgroundColor: const Color(0xFF9BA6A7),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.909),
                  ),
                  textStyle: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16.sp,
                  ),
                ),
                onPressed: enabled ? onProceed : null,
                child: const Text('Proceed Checkout'),
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: Container(
                width: 135,
                height: 5,
                decoration: BoxDecoration(
                  color: const Color(0xFFB9C0C9),
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
