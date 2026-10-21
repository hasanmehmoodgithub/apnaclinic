import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/router/app_routes.dart';
import '../../domain/entities/pharmacy_medicine_entity.dart';
import '../../domain/entities/prescription_extract_entity.dart';
import '../cubit/prescription_scan_state.dart';
import '../pharmacy_navigation.dart';
import 'pharmacy_add_to_cart_sheet.dart';
import 'pharmacy_network_image.dart';

class PrescriptionScanResult extends StatelessWidget {
  const PrescriptionScanResult({
    super.key,
    required this.result,
    required this.matches,
    required this.prescriptionPath,
  });

  final PrescriptionExtractEntity result;
  final List<PrescriptionMedicineMatch> matches;
  final String? prescriptionPath;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: EdgeInsets.all(16.r),
          decoration: BoxDecoration(
            color: AppColors.clrWhite,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: AppColors.clrE3E8EE),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _TypeChip(label: _typeLabel(l10n, result)),
              if (result.pages > 1) ...[
                SizedBox(height: 8.h),
                Text(
                  l10n.pharmacyScanPages(result.pages),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.clr8A9AAE,
                  ),
                ),
              ],
              SizedBox(height: 12.h),
              _DetailRow(
                label: l10n.pharmacyScanPatient,
                value: result.patient,
              ),
              _DetailRow(label: l10n.pharmacyScanDoctor, value: result.doctor),
              _DetailRow(label: l10n.pharmacyScanDate, value: result.date),
              _DetailRow(
                label: l10n.pharmacyScanInstitute,
                value: result.institute,
              ),
              _DetailRow(
                label: l10n.pharmacyScanLocation,
                value: result.location,
              ),
            ],
          ),
        ),
        if (result.tests.isNotEmpty) ...[
          SizedBox(height: 18.h),
          Text(
            l10n.pharmacyScanTests,
            style: theme.textTheme.titleMedium?.copyWith(
              color: AppColors.clr060,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 10.h),
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: [
              for (final test in result.tests)
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 8.h,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.clrE0F7F6,
                    borderRadius: BorderRadius.circular(99.r),
                  ),
                  child: Text(
                    test,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: AppColors.clr00897B,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
        ],
        SizedBox(height: 18.h),
        Text(
          l10n.pharmacyScanMedicines,
          style: theme.textTheme.titleMedium?.copyWith(
            color: AppColors.clr060,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: 10.h),
        if (result.medicines.isEmpty)
          Text(
            l10n.pharmacyScanNoMedicines,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: AppColors.clr6B7280,
              height: 1.35,
            ),
          )
        else
          for (var index = 0; index < result.medicines.length; index++)
            Padding(
              padding: EdgeInsets.only(bottom: 12.h),
              child: _MedicineCard(
                medicine: result.medicines[index],
                match: index < matches.length
                    ? matches[index]
                    : const PrescriptionMedicineMatch(loading: true),
                prescriptionPath: prescriptionPath,
              ),
            ),
      ],
    );
  }
}

String _typeLabel(AppLocalizations l10n, PrescriptionExtractEntity result) {
  if (result.isLabReport) return l10n.pharmacyScanLabReport;
  if (result.type.trim().toLowerCase() == 'visit') {
    return l10n.pharmacyScanVisit;
  }
  final type = result.type.trim();
  return type.isEmpty ? l10n.pharmacyScanVisit : type;
}

class _TypeChip extends StatelessWidget {
  const _TypeChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: AppColors.clrE0F7F6,
        borderRadius: BorderRadius.circular(99.r),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
          color: AppColors.clr00897B,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final text = value.trim();
    if (text.isEmpty) return const SizedBox.shrink();
    final theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 88.w,
            child: Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: AppColors.clr8A9AAE,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppColors.clr060,
                fontWeight: FontWeight.w600,
                height: 1.3,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MedicineCard extends StatelessWidget {
  const _MedicineCard({
    required this.medicine,
    required this.match,
    required this.prescriptionPath,
  });

  final PrescriptionMedicineEntity medicine;
  final PrescriptionMedicineMatch match;
  final String? prescriptionPath;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final subtitle = [
      medicine.dosage,
      medicine.frequency,
      medicine.duration,
      medicine.instructions,
    ].where((part) => part.trim().isNotEmpty).join(' · ');

    return Container(
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: AppColors.clrWhite,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.clrE3E8EE),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            medicine.name,
            style: theme.textTheme.titleSmall?.copyWith(
              color: AppColors.clr060,
              fontWeight: FontWeight.w700,
              fontSize: 15.sp,
            ),
          ),
          if (subtitle.isNotEmpty) ...[
            SizedBox(height: 4.h),
            Text(
              subtitle,
              style: theme.textTheme.bodySmall?.copyWith(
                color: AppColors.clr6B7280,
                height: 1.3,
              ),
            ),
          ],
          if (medicine.quantity > 0) ...[
            SizedBox(height: 4.h),
            Text(
              l10n.pharmacyScanQuantity(medicine.quantity),
              style: theme.textTheme.bodySmall?.copyWith(
                color: AppColors.clr00897B,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
          SizedBox(height: 12.h),
          if (match.loading)
            Row(
              children: [
                SizedBox(
                  width: 16.r,
                  height: 16.r,
                  child: const CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.clr27B3A6,
                  ),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: Text(
                    l10n.pharmacyScanMatching,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: AppColors.clr6B7280,
                    ),
                  ),
                ),
              ],
            )
          else if (match.products.isEmpty)
            Text(
              l10n.pharmacyScanNotInCatalog,
              style: theme.textTheme.bodySmall?.copyWith(
                color: AppColors.clr6B7280,
              ),
            )
          else
            for (final product in match.products)
              Padding(
                padding: EdgeInsets.only(bottom: 8.h),
                child: _CatalogProductRow(
                  product: product,
                  quantity: medicine.quantity,
                  prescriptionPath: prescriptionPath,
                ),
              ),
        ],
      ),
    );
  }
}

class _CatalogProductRow extends StatelessWidget {
  const _CatalogProductRow({
    required this.product,
    required this.quantity,
    required this.prescriptionPath,
  });

  final PharmacyMedicineEntity product;
  final int quantity;
  final String? prescriptionPath;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final packageLabel = product.packageType.trim();

    return Material(
      color: AppColors.clrF5FBFA,
      borderRadius: BorderRadius.circular(12.r),
      child: InkWell(
        borderRadius: BorderRadius.circular(12.r),
        onTap: () {
          context.pushNamed(
            AppRoutes.pharmacy,
            extra: {PharmacyRouteExtraKeys.selectedMedicine: product},
          );
        },
        child: Padding(
          padding: EdgeInsets.all(8.r),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8.r),
                child: SizedBox(
                  width: 48.r,
                  height: 48.r,
                  child: PharmacyNetworkImage(
                    imageUrl: product.imageUrl,
                    fit: BoxFit.contain,
                    memCacheWidth: 200,
                  ),
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: AppColors.clr060,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      packageLabel.isEmpty
                          ? '${l10n.pharmacyCurrencyPrefix}${product.price.toStringAsFixed(0)}'
                          : '${l10n.pharmacyCurrencyPrefix}${product.price.toStringAsFixed(0)} / $packageLabel',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: AppColors.clr15A9A0,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 8.w),
              FilledButton(
                onPressed: () {
                  showPharmacyAddToCartSheet(
                    context,
                    product,
                    loaderIdPrefix: 'prescription_scan_add',
                    initialQuantity: quantity < 1 ? 1 : quantity,
                    initialPrescriptionPath: prescriptionPath,
                  );
                },
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.clr27B3A6,
                  foregroundColor: AppColors.clrWhite,
                  minimumSize: Size(0, 36.h),
                  padding: EdgeInsets.symmetric(horizontal: 12.w),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                child: Text(
                  l10n.pharmacyAddToCartLower,
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: AppColors.clrWhite,
                    fontWeight: FontWeight.w700,
                    fontSize: 12.sp,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
