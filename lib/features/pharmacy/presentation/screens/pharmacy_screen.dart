import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../components/shimmer/app_shimmer.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/enums/state_status.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/widgets/app_scaffold_gradient.dart';
import '../../../../generated/assets.dart';
import '../../domain/entities/pharmacy_medicine_entity.dart';
import '../cubit/pharmacy_cubit.dart';
import '../cubit/pharmacy_state.dart';
import '../widgets/pharmacy_medicine_card.dart';
import '../widgets/pharmacy_quantity_stepper.dart';
import 'pharmacy_cart_screen.dart';

class PharmacyScreen extends StatelessWidget {
  const PharmacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocBuilder<PharmacyCubit, PharmacyState>(
      builder: (context, state) {
        return AppScaffoldGradient(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(12.w, 12.h, 22.w, 13.h),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.of(context).maybePop(),
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
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        InkWell(
                          onTap: () => _openCart(context),
                          borderRadius: BorderRadius.circular(18.r),
                          child: Container(
                            width: 35.r,
                            height: 35.r,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: SvgPicture.asset(
                                Assets.iconsBasket,
                                width: 16.r,
                                height: 16.r,
                                color: const Color(0xFF667B99),
                              ),
                            ),
                          ),
                        ),
                        if (state.cartCount > 0)
                          Positioned(
                            right: -2.w,
                            top: -2.h,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 5.w,
                                vertical: 1.h,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFF0FAA9A),
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                              child: Text(
                                '${state.cartCount}',
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3F3F3),
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
      return ListView(
        padding: EdgeInsets.all(16.r),
        children: [
          AppShimmerCard(height: 220.h, borderRadius: 20.r),
          SizedBox(height: 12.h),
          AppShimmerText(height: 18.h, width: 230.w),
          SizedBox(height: 8.h),
          AppShimmerText(height: 14.h),
          SizedBox(height: 14.h),
          AppShimmerGrid(
            itemCount: 4,
            crossAxisCount: 2,
            childAspectRatio: 0.72,
            borderRadius: 16.r,
          ),
        ],
      );
    }

    if (state.medicinesLoadingStateStatus == StateStatus.error) {
      return Center(
        child: Text(
          state.medicinesErrorMessage ?? AppStrings.pharmacyLoadError,
          textAlign: TextAlign.center,
        ),
      );
    }

    if (state.medicines.isEmpty) {
      return const Center(child: Text('No medicine found'));
    }

    final featured = state.medicines.first;
    return ListView(
      padding: EdgeInsets.fromLTRB(18.w, 16.h, 18.w, 24.h),
      children: [
        Container(
          height: 260.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(26.r),
            color: const Color(0xFFE6EDF1),
          ),
          clipBehavior: Clip.antiAlias,
          child: Image.network(
            featured.imageUrl,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
        SizedBox(height: 16.h),
        Row(
          children: [
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SvgPicture.asset(Assets.iconsMedicine, width: 35.r, height: 35.r),
                  SizedBox(width: 6.w),
                  Expanded(
                    child: Text(
                      featured.name,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: const Color(0xFF102A56),
                            fontWeight: FontWeight.w700,
                            fontSize: 31.sp / 1.6,
                          ),
                    ),
                  ),
                ],
              ),
            ),
            OutlinedButton.icon(
              onPressed: () => context.read<PharmacyCubit>().addToCart(featured),
              icon: SvgPicture.asset(
                Assets.iconsBasket,
                width: 15.r,
                height: 15.r,
                color: const Color(0xFF667B99),
              ),
              label: const Text('Add to cart'),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFF9BA6A7), width: 0.8),
                foregroundColor: const Color(0xFF061E40),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(36.r),
                ),
              ),
            ),
          ],
        ),
        Text(
          'Rs ${featured.price.toStringAsFixed(0)} /-',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: const Color(0xFF4D5A70),
                fontWeight: FontWeight.w500,
              ),
        ),
        SizedBox(height: 8.h),
        Text(
          featured.description,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: const Color(0xFF4A4A4A),
                height: 1.2,
                fontSize: 16.sp,
              ),
        ),
        Divider(height: 30.h, color: const Color(0xFFD8D8D8)),
        Text(
          'More Like',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: const Color(0xFF061E40),
                fontWeight: FontWeight.w500,
                fontSize: 22.sp / 1.6,
              ),
        ),
        SizedBox(height: 10.h),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: state.medicines.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 16.h,
            crossAxisSpacing: 6.w,
            childAspectRatio: 0.83,
          ),
          itemBuilder: (context, index) {
            final item = state.medicines[index];
            return PharmacyMedicineCard(
              medicine: item,
              onTap: () => _openDetailsSheet(context, item),
              onAddToCart: () => context.read<PharmacyCubit>().addToCart(item),
            );
          },
        ),
      ],
    );
  }

  Future<void> _openDetailsSheet(
    BuildContext context,
    PharmacyMedicineEntity medicine,
  ) async {
    final pharmacyCubit = context.read<PharmacyCubit>();
    var qty = 1;
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
      ),
      builder: (context) {
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
                      onPressed: () {
                        pharmacyCubit.addToCart(medicine, quantity: qty);
                        Navigator.of(context).pop();
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
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => BlocProvider.value(
          value: context.read<PharmacyCubit>(),
          child: const PharmacyCartScreen(),
        ),
      ),
    );
  }
}
