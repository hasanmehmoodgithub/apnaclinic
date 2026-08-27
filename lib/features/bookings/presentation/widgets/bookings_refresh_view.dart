import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';

/// Pull-to-refresh for bookings lists. Set [expandChild] for empty/error bodies.
class BookingsRefreshView extends StatelessWidget {
  const BookingsRefreshView({
    super.key,
    required this.onRefresh,
    required this.child,
    this.expandChild = false,
  });

  final RefreshCallback onRefresh;
  final Widget child;
  final bool expandChild;

  @override
  Widget build(BuildContext context) {
    final scrollChild = expandChild
        ? CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverFillRemaining(
                hasScrollBody: false,
                child: child,
              ),
            ],
          )
        : child;

    return RefreshIndicator(
      color: AppColors.clr0FAA9A,
      onRefresh: onRefresh,
      child: scrollChild,
    );
  }
}
