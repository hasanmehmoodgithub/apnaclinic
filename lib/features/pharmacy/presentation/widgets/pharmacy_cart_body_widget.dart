import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/widgets/app_button_widget.dart';
import '../../../../core/widgets/heart_loader_widget.dart';
import '../cubit/pharmacy_cubit.dart';
import '../cubit/pharmacy_state.dart';
import 'pharmacy_cart_item_tile.dart';
import 'pharmacy_error_dialog.dart';

/// Cart panel content: cart list/empty-state and sticky checkout button.
class PharmacyCartBodyWidget extends StatefulWidget {
  const PharmacyCartBodyWidget({super.key});

  @override
  State<PharmacyCartBodyWidget> createState() => _PharmacyCartBodyWidgetState();
}

class _PharmacyCartBodyWidgetState extends State<PharmacyCartBodyWidget> {
  static const _qtyLoaderId = 'pharmacy_cart_qty_loader';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<PharmacyCubit>().loadCart();
    });
  }

  Future<void> _changeQuantity({
    required String medicineId,
    required bool increase,
  }) async {
    if (!mounted) return;
    if (!HeartLoaderDialogController.isOpen(_qtyLoaderId)) {
      showHeartLoaderDialog(context, id: _qtyLoaderId, size: 120);
    }
    String? error;
    try {
      final cubit = context.read<PharmacyCubit>();
      error = increase
          ? await cubit.increaseQuantity(medicineId)
          : await cubit.decreaseQuantity(medicineId);
    } finally {
      HeartLoaderDialogController.close(_qtyLoaderId);
    }
    if (!mounted || error == null) return;
    await _showCartError(error);
  }

  Future<void> _showCartError(String error) {
    final l10n = AppLocalizations.of(context)!;
    return showPharmacyErrorDialog(
      context,
      title: l10n.pharmacyCartTitle,
      message: error.trim().isNotEmpty
          ? error.trim()
          : l10n.pharmacyCartUpdateFailed,
    );
  }

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
                    onIncrease: () => _changeQuantity(
                      medicineId: item.medicine.id,
                      increase: true,
                    ),
                    onDecrease: () => _changeQuantity(
                      medicineId: item.medicine.id,
                      increase: false,
                    ),
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
