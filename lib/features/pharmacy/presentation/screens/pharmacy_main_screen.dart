import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/enums/state_status.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/widgets/heart_loader_widget.dart';
import '../../../../generated/assets.dart';
import '../../domain/entities/pharmacy_medicine_entity.dart';
import '../cubit/pharmacy_cubit.dart';
import '../cubit/pharmacy_state.dart';
import '../widgets/pharmacy_main_content_section.dart';
import '../widgets/pharmacy_main_top_header.dart';
import '../widgets/pharmacy_quantity_stepper.dart';
import '../widgets/pharmacy_screen_state_view.dart';
import 'pharmacy_cart_screen.dart';

class PharmacyMainScreen extends StatefulWidget {
  const PharmacyMainScreen({super.key});

  @override
  State<PharmacyMainScreen> createState() => _PharmacyMainScreenState();
}

class _PharmacyMainScreenState extends State<PharmacyMainScreen> {
  String _searchQuery = '';
  static const double _topBannerFraction = 0.32;

  @override
  Widget build(BuildContext context) {
    final bannerHeight = MediaQuery.sizeOf(context).height * _topBannerFraction;
    return Scaffold(
      body: BlocBuilder<PharmacyCubit, PharmacyState>(
        builder: (context, state) {
          return ColoredBox(
            color: const Color(0xFFF4F6F8),
            child: Column(
              children: [
                SizedBox(
                  height: bannerHeight,
                  child: PharmacyMainTopHeader(
                    cartCount: state.cartCount,
                    onBackTap: () => Navigator.of(context).maybePop(),
                    onCartTap: () => _openCart(context),
                  ),
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
      ),
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

    final medicines = state.medicines.where((medicine) {
      final query = _searchQuery.trim().toLowerCase();
      if (query.isEmpty) return true;
      return medicine.name.toLowerCase().contains(query);
    }).toList();

    return PharmacyMainContentSection(
      medicines: medicines,
      searchQuery: _searchQuery,
      onSearchChanged: (value) => setState(() => _searchQuery = value),
      onMedicineTap: (medicine) => _openPharmacyScreen(context, medicine),
      onAddToCartTap: (medicine) => _openAddToCartSheet(context, medicine),
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
    final pharmacyCubit = context.read<PharmacyCubit>();
    context.pushNamed(
      AppRoutes.pharmacy,
      extra: {
        'selectedMedicine': medicine,
        'pharmacyCubit': pharmacyCubit,
      },
    );
  }

  Future<void> _openAddToCartSheet(
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
                        final loaderId = 'pharmacy_main_add_to_cart_${medicine.id}';
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
}
