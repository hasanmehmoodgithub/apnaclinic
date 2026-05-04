import 'package:flutter/material.dart';

import '../../../../core/extensions/screen_util_extensions.dart';
import 'pharmacy_cart_icon_with_count.dart';

/// Top bar: back, title, cart. Cart count comes from the parent (e.g. after [BlocSelector]).
class PharmacyScreenHeaderWidget extends StatelessWidget {
  const PharmacyScreenHeaderWidget({
    super.key,
    required this.title,
    required this.cartCount,
    required this.onBackTap,
    required this.onCartTap,
  });

  final String title;
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
              title,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleLarge?.copyWith(
                color: const Color(0xFF0E2D55),
                fontWeight: FontWeight.w700,
                fontSize: 21.sp,
              ),
            ),
          ),
          PharmacyCartIconWithCount(cartCount: cartCount, onTap: onCartTap),
        ],
      ),
    );
  }
}
