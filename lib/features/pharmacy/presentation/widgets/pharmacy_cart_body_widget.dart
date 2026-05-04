import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/widgets/app_button_widget.dart';
import '../cubit/pharmacy_cubit.dart';
import '../cubit/pharmacy_state.dart';
import 'pharmacy_cart_item_tile.dart';

/// Cart panel content: cart list/empty-state and sticky checkout button.
class PharmacyCartBodyWidget extends StatelessWidget {
  const PharmacyCartBodyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BlocBuilder<PharmacyCubit, PharmacyState>(
      buildWhen: (previous, current) => previous.cartItems != current.cartItems,
      builder: (context, state) {
        return Stack(
          children: [
            if (state.cartItems.isEmpty)
              Center(child: Text(l10n.pharmacyCartEmpty))
            else
              ListView.separated(
                padding: EdgeInsets.fromLTRB(23.w, 25.h, 23.w, 120.h),
                itemBuilder: (_, index) {
                  final item = state.cartItems[index];
                  return PharmacyCartItemTile(
                    item: item,
                    onIncrease: () => context
                        .read<PharmacyCubit>()
                        .increaseQuantity(item.medicine.id),
                    onDecrease: () => context
                        .read<PharmacyCubit>()
                        .decreaseQuantity(item.medicine.id),
                  );
                },
                separatorBuilder: (_, _) => SizedBox(height: 30.h),
                itemCount: state.cartItems.length,
              ),
            Positioned(
              left: 23.w,
              right: 23.w,
              bottom: 22.h,
              child: SafeArea(
                top: false,
                child: AppButtonWidget(
                  title: l10n.pharmacyCheckoutCta,
                  onTap: state.cartItems.isEmpty
                      ? null
                      : () => context.pushNamed(AppRoutes.pharmacyCheckout),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
