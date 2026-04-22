import 'package:flutter/material.dart';

import '../../../../core/extensions/screen_util_extensions.dart';
import 'pharmacy_cart_icon_with_count.dart';

class PharmacyScreenHeader extends StatelessWidget {
  const PharmacyScreenHeader({
    super.key,
    required this.cartCount,
    required this.onBackTap,
    required this.onCartTap,
  });

  final int cartCount;
  final VoidCallback onBackTap;
  final VoidCallback onCartTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.fromLTRB(12.w, 12.h, 12.w, 13.h),
      child: Row(
        children: [
          IconButton(
            onPressed: onBackTap,
            icon: const Icon(
              Icons.arrow_back_rounded,
              color: Color(0xFF08294D),
            ),
          ),
          Expanded(
            child: Text(
              'Pharmacy',
              textAlign: TextAlign.center,
              style: theme.textTheme.titleLarge?.copyWith(
                color: const Color(0xFF0E2D55),
                fontWeight: FontWeight.w700,
                fontSize: 21.sp,
              ),
            ),
          ),
          PharmacyCartIconWithCount(
            cartCount: cartCount,
            onTap: onCartTap,
          ),
        ],
      ),
    );
  }
}
