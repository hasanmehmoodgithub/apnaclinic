import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/enums/state_status.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/widgets/app_scaffold_gradient.dart';
import '../../../../core/widgets/heart_loader_widget.dart';
import '../../../../generated/assets.dart';
import '../../domain/entities/pharmacy_medicine_entity.dart';
import '../cubit/pharmacy_cubit.dart';
import '../cubit/pharmacy_state.dart';
import '../widgets/pharmacy_medicine_content_section.dart';
import '../widgets/pharmacy_quantity_stepper.dart';
import '../widgets/pharmacy_screen_header.dart';
import '../widgets/pharmacy_screen_state_view.dart';
import 'pharmacy_cart_screen.dart';

class PharmacyScreen extends StatelessWidget {
  const PharmacyScreen({
    super.key,
    this.initialFeaturedMedicine,
  });

  final PharmacyMedicineEntity? initialFeaturedMedicine;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PharmacyCubit, PharmacyState>(
      builder: (context, state) {
        return AppScaffoldGradient(
          child: Column(
            children: [
              PharmacyScreenHeader(
                cartCount: state.cartCount,
                onBackTap: () => Navigator.of(context).maybePop(),
                onCartTap: () => _openCart(context),
              ),
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Colors.white,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(42.r)),
                  ),
                  child: _buildBody(context, state),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, PharmacyState state) {
    if (state.medicinesLoadingStateStatus == StateStatus.loading) {
      return const PharmacyScreenStateView.loading();
    }

    if (state.medicinesLoadingStateStatus == StateStatus.error) {
      return PharmacyScreenStateView.error(
        message: state.medicinesErrorMessage ?? AppStrings.pharmacyLoadError,
      );
    }

    if (state.medicines.isEmpty) {
      return const PharmacyScreenStateView.empty();
    }

    final featuredMedicine = initialFeaturedMedicine == null
        ? state.medicines.first
        : state.medicines.firstWhere(
            (medicine) => medicine.id == initialFeaturedMedicine!.id,
            orElse: () => initialFeaturedMedicine!,
          );

    return PharmacyMedicineContentSection(
      medicines: state.medicines,
      featuredMedicine: featuredMedicine,
      onAddToCart: (medicine) => _openDetailsSheet(context, medicine),
      onMedicineTap: (medicine) => _openPharmacyScreen(context, medicine),
    );
  }

  Future<void> _openDetailsSheet(
    BuildContext context,
    PharmacyMedicineEntity medicine,
  ) async {
    final pharmacyCubit = context.read<PharmacyCubit>();
    final bottomSheetNavigator = Navigator.of(context);
    var qty = 1;
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
      ),
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Padding(
              padding: EdgeInsets.fromLTRB(18.w, 16.h, 18.w, 18.h),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12.r),
                        child: Image.network(
                          medicine.imageUrl,
                          width: 88.r,
                          height: 88.r,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SvgPicture.asset(
                              Assets.iconsMedicine,
                              width: 18.r,
                              height: 18.r,
                            ),
                            SizedBox(width: 6.w),
                            Expanded(
                              child: Text(
                                medicine.name,
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.w700,
                                      color: const Color(0xFF102A56),
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.h),
                  Row(
                    children: [
                      Text(
                        'Rs ${medicine.price.toStringAsFixed(0)} /-',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: const Color(0xFF1F2A44),
                              fontSize: 18.sp,
                            ),
                      ),
                      const Spacer(),
                      PharmacyQuantityStepper(
                        quantity: qty,
                        onAdd: () => setSheetState(() => qty++),
                        onRemove: () {
                          if (qty <= 1) return;
                          setSheetState(() => qty--);
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 12.h),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: () async {
                        final loaderId = 'pharmacy_add_to_cart_${medicine.id}';
                        showHeartLoaderDialog(sheetContext, id: loaderId, size: 120);
                        final success = await pharmacyCubit.addToCartApi(
                          medicine,
                          quantity: qty,
                        );
                        HeartLoaderDialogController.close(loaderId);
                        if (success && bottomSheetNavigator.mounted) {
                          bottomSheetNavigator.pop();
                        }
                      },
                      style: FilledButton.styleFrom(
                        backgroundColor: const Color(0xFF27B3A6),
                        minimumSize: Size.fromHeight(52.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14.r),
                        ),
                      ),
                      child: const Text('Add to Cart'),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _openCart(BuildContext context) {
    final navigator = Navigator.of(context);
    final pharmacyCubit = context.read<PharmacyCubit>();
    navigator.push(
      MaterialPageRoute<void>(
        builder: (_) => BlocProvider.value(
          value: pharmacyCubit,
          child: const PharmacyCartScreen(),
        ),
      ),
    );
  }

  void _openPharmacyScreen(BuildContext context, PharmacyMedicineEntity medicine) {
    final navigator = Navigator.of(context);
    final pharmacyCubit = context.read<PharmacyCubit>();
    navigator.pushReplacement(
      MaterialPageRoute<void>(
        builder: (_) => BlocProvider.value(
          value: pharmacyCubit,
          child: PharmacyScreen(initialFeaturedMedicine: medicine),
        ),
      ),
    );
  }
}
