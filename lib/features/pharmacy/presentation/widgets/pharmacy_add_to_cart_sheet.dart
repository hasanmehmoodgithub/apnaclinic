import 'package:file_picker/file_picker.dart';
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
import '../../../../core/utils/auth_guard.dart';
import '../../domain/entities/pharmacy_medicine_entity.dart';
import '../cubit/pharmacy_cubit.dart';
import 'pharmacy_prescription_attached_section.dart';
import 'pharmacy_prescription_upload_section.dart';
import 'pharmacy_quantity_stepper.dart';

const int _kMaxPrescriptionBytes = 5 * 1024 * 1024;
const Set<String> _kAllowedPrescriptionExtensions = {
  'png',
  'jpg',
  'jpeg',
  'webp',
  'pdf',
};

Future<void> showPharmacyAddToCartSheet(
  BuildContext context,
  PharmacyMedicineEntity medicine, {
  required String loaderIdPrefix,
}) async {
  if (!context.requireLogin()) return;

  final pharmacyCubit = context.read<PharmacyCubit>();
  final hostContext = context;
  var qty = 1;
  String? pickedPath;
  String? pickedName;
  var forceReupload = false;

  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppColors.clrWhite,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
    ),
    builder: (sheetContext) {
      return SafeArea(
        child: StatefulBuilder(
          builder: (context, setSheetState) {
            final l10n = AppLocalizations.of(context)!;
            final existingPrescriptionUrl = pharmacyCubit.state.cartItems
                .where((item) => item.medicine.id == medicine.id)
                .map((item) => item.prescriptionUrl.trim())
                .firstWhere((url) => url.isNotEmpty, orElse: () => '');
            final hasExistingPrescription =
                medicine.prescriptionRequired &&
                existingPrescriptionUrl.isNotEmpty &&
                !forceReupload;
            // Ask for upload when Rx required and no URL, or user chose re-upload.
            final needsPrescriptionUpload = medicine.prescriptionRequired &&
                (existingPrescriptionUrl.isEmpty || forceReupload);
            final hasLocalFile =
                (pickedPath ?? '').trim().isNotEmpty &&
                (pickedName ?? '').trim().isNotEmpty;

            Future<void> pickPrescription() async {
              try {
                final result = await FilePicker.pickFiles(
                  allowMultiple: false,
                  type: FileType.custom,
                  allowedExtensions: _kAllowedPrescriptionExtensions.toList(),
                );
                if (result == null || result.files.isEmpty) return;

                final file = result.files.first;
                final path = (file.path ?? '').trim();
                final name = file.name.trim();
                final ext = name.contains('.')
                    ? name.split('.').last.toLowerCase()
                    : '';

                if (path.isEmpty || name.isEmpty) {
                  if (sheetContext.mounted) {
                    ScaffoldMessenger.of(sheetContext).showSnackBar(
                      SnackBar(
                        content: Text(l10n.pharmacyPrescriptionPickFailed),
                      ),
                    );
                  }
                  return;
                }

                if (!_kAllowedPrescriptionExtensions.contains(ext)) {
                  if (sheetContext.mounted) {
                    ScaffoldMessenger.of(sheetContext).showSnackBar(
                      SnackBar(
                        content: Text(l10n.pharmacyPrescriptionInvalidType),
                      ),
                    );
                  }
                  return;
                }

                final size = file.size;
                if (size > _kMaxPrescriptionBytes) {
                  if (sheetContext.mounted) {
                    ScaffoldMessenger.of(sheetContext).showSnackBar(
                      SnackBar(
                        content: Text(l10n.pharmacyPrescriptionTooLarge),
                      ),
                    );
                  }
                  return;
                }

                setSheetState(() {
                  pickedPath = path;
                  pickedName = name;
                });
              } catch (_) {
                if (sheetContext.mounted) {
                  ScaffoldMessenger.of(sheetContext).showSnackBar(
                    SnackBar(
                      content: Text(l10n.pharmacyPrescriptionPickFailed),
                    ),
                  );
                }
              }
            }

            return Padding(
              padding: EdgeInsets.fromLTRB(
                18.w,
                16.h,
                18.w,
                18.h + MediaQuery.viewInsetsOf(context).bottom,
              ),
              child: SingleChildScrollView(
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
                            errorWidget: (context, url, error) =>
                                const ColoredBox(
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
                    if (hasExistingPrescription) ...[
                      SizedBox(height: 16.h),
                      PharmacyPrescriptionAttachedSection(
                        prescriptionUrl: existingPrescriptionUrl,
                        onReupload: () => setSheetState(() {
                          forceReupload = true;
                          pickedPath = null;
                          pickedName = null;
                        }),
                      ),
                    ] else if (needsPrescriptionUpload) ...[
                      SizedBox(height: 16.h),
                      PharmacyPrescriptionUploadSection(
                        fileName: pickedName,
                        onPickFile: pickPrescription,
                        onClearFile: hasLocalFile
                            ? () => setSheetState(() {
                                pickedPath = null;
                                pickedName = null;
                              })
                            : null,
                      ),
                      if (forceReupload && existingPrescriptionUrl.isNotEmpty)
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () => setSheetState(() {
                              forceReupload = false;
                              pickedPath = null;
                              pickedName = null;
                            }),
                            child: Text(l10n.pharmacyPrescriptionKeepCurrent),
                          ),
                        ),
                    ],
                    SizedBox(height: 14.h),
                    Divider(
                      color: AppColors.clrD9DEE6,
                      thickness: 1,
                      height: 1,
                    ),
                    SizedBox(height: 18.h),
                    SizedBox(
                      width: double.infinity,
                      child: AppButtonWidget(
                        title: l10n.pharmacyAddToCart,
                        bgClr: AppColors.clr27B3A6,
                        onTap: () async {
                          final messenger = ScaffoldMessenger.of(sheetContext);
                          String prescriptionUrl = existingPrescriptionUrl;

                          if (needsPrescriptionUpload) {
                            if (!hasLocalFile) {
                              messenger.showSnackBar(
                                SnackBar(
                                  content: Text(
                                    l10n.pharmacyPrescriptionRequiredToAdd,
                                  ),
                                ),
                              );
                              return;
                            }

                            final loaderId =
                                '${loaderIdPrefix}_rx_${medicine.id}';
                            final loaderContext = hostContext.mounted
                                ? hostContext
                                : sheetContext;
                            if (loaderContext.mounted) {
                              showHeartLoaderDialog(
                                loaderContext,
                                id: loaderId,
                                size: 120,
                              );
                            }
                            try {
                              final uploaded =
                                  await pharmacyCubit.uploadPrescription(
                                productId: medicine.id,
                                filePath: pickedPath!,
                                fileName: pickedName!,
                              );
                              if (uploaded == null || uploaded.isEmpty) {
                                if (sheetContext.mounted) {
                                  messenger.showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        l10n.pharmacyPrescriptionUploadFailed,
                                      ),
                                    ),
                                  );
                                }
                                return;
                              }
                              prescriptionUrl = uploaded;
                            } finally {
                              HeartLoaderDialogController.close(loaderId);
                            }
                          }

                          final loaderId = '${loaderIdPrefix}_${medicine.id}';
                          final loaderContext =
                              hostContext.mounted ? hostContext : sheetContext;
                          if (loaderContext.mounted) {
                            showHeartLoaderDialog(
                              loaderContext,
                              id: loaderId,
                              size: 120,
                            );
                          }
                          var success = false;
                          try {
                            success = await pharmacyCubit.addToCartApi(
                              medicine,
                              quantity: qty,
                              prescriptionUrl: prescriptionUrl,
                            );
                          } finally {
                            HeartLoaderDialogController.close(loaderId);
                          }
                          if (success && sheetContext.mounted) {
                            sheetContext.pop();
                          } else if (!success && sheetContext.mounted) {
                            messenger.showSnackBar(
                              SnackBar(
                                content: Text(l10n.pharmacyAddToCartFailed),
                              ),
                            );
                          }
                        },
                      ),
                    ),
                    SizedBox(height: 18.h),
                  ],
                ),
              ),
            );
          },
        ),
      );
    },
  );
}
