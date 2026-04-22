import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/widgets/app_button_widget.dart';
import '../../../../core/widgets/app_scaffold_gradient.dart';
import '../cubit/pharmacy_cubit.dart';
import '../cubit/pharmacy_state.dart';
import '../widgets/pharmacy_cart_item_tile.dart';

class PharmacyCartScreen extends StatelessWidget {
  const PharmacyCartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PharmacyCubit, PharmacyState>(
      builder: (context, state) {
        return AppScaffoldGradient(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(12.w, 12.h, 12.w, 13.h),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.of(context).maybePop(),
                      icon: const Icon(
                        Icons.arrow_back_rounded,
                        color: Color(0xFF061E40),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'Cart',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF061E40),
                              fontSize: 31.sp / 1.6,
                            ),
                      ),
                    ),
                    SizedBox(width: 44.w),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(42.r)),
                  ),
                  child: Stack(
                    children: [
                      if (state.cartItems.isEmpty)
                        const Center(child: Text('Your cart is empty'))
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
                          separatorBuilder: (_, __) => SizedBox(height: 30.h),
                          itemCount: state.cartItems.length,
                        ),
                      Positioned(
                        left: 23.w,
                        right: 23.w,
                        bottom: 22.h,
                        child: SafeArea(
                          top: false,
                          child: AppButtonWidget(
                            title: 'Check Out',
                            onTap: state.cartItems.isEmpty
                                ? null
                                : () {
                                    context.pushNamed(AppRoutes.pharmacyCheckout);
                                  },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
