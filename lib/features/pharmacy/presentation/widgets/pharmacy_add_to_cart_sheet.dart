import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';

import '../../../../components/shimmer/app_shimmer.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/widgets/app_button_widget.dart';
import '../../../../core/widgets/heart_loader_widget.dart';
import '../../domain/entities/pharmacy_medicine_entity.dart';
import '../cubit/pharmacy_cubit.dart';
import 'pharmacy_quantity_stepper.dart';

Future<void> showPharmacyAddToCartSheet(
  BuildContext context,
  PharmacyMedicineEntity medicine, {
  required String loaderIdPrefix,
}) async {
  final pharmacyCubit = context.read<PharmacyCubit>();
  var qty = 1;

  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppColors.clrWhite,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
    ),
    builder: (sheetContext) {
      return StatefulBuilder(
        builder: (context, setSheetState) {
          final l10n = AppLocalizations.of(context)!;
          return Padding(
            padding: EdgeInsets.fromLTRB(18.w, 16.h, 18.w, 18.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 68.w,
                  height: 6.h,
                  margin: EdgeInsets.only(bottom: 16.h),
                  decoration: BoxDecoration(
                    color: AppColors.clrC3C3C3,
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12.r),
                      child: CachedNetworkImage(
                        imageUrl: medicine.imageUrl,
                        width: 88.r,
                        height: 88.r,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => AppShimmer(
                          width: 88.r,
                          height: 88.r,
                          borderRadius: 12.r,
                          shape: ShimmerShape.roundedRectangle,
                        ),
                        errorWidget: (context, url, error) => const ColoredBox(
                          color: AppColors.clrF0F4F8,
                          child: Center(
                            child: Icon(
                              Icons.medication_rounded,
                              color: AppColors.clr8A9AAE,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            medicine.name,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.clr102A56,
                                ),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            '${l10n.pharmacyCurrencyPrefix}${medicine.price.toStringAsFixed(0)} /-',
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(
                                  color: AppColors.clr1F2A44,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 18.sp,
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
                    const Spacer(),
                    PharmacyQuantityStepper(
                      quantity: qty,
                      height: 38.h,
                      horizontalPadding: 20.w,
                      itemSpacing: 24.w,
                      quantityFontSize: 19.sp,
                      actionFontSize: 16.sp,
                      borderRadius: 40.r,
                      onAdd: () => setSheetState(() => qty++),
                      onRemove: () {
                        if (qty <= 1) return;
                        setSheetState(() => qty--);
                      },
                    ),
                  ],
                ),
                SizedBox(height: 14.h),
                Divider(color: AppColors.clrD9DEE6, thickness: 1, height: 1),
                SizedBox(height: 18.h),
                SizedBox(
                  width: double.infinity,
                  child: AppButtonWidget(
                    title: l10n.pharmacyAddToCart,
                    bgClr: AppColors.clr27B3A6,
                    onTap: () async {
                      final loaderId = '${loaderIdPrefix}_${medicine.id}';
                      showHeartLoaderDialog(
                        sheetContext,
                        id: loaderId,
                        size: 120,
                      );
                      final success = await pharmacyCubit.addToCartApi(
                        medicine,
                        quantity: qty,
                      );
                      HeartLoaderDialogController.close(loaderId);
                      if (success && sheetContext.mounted) {
                        sheetContext.pop();
                      }
                    },
                  ),
                ),
                SizedBox(height: 18.h),
              ],
            ),
          );
        },
      );
    },
  );
}
