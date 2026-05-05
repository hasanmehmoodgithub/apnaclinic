import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../domain/entities/pharmacy_medicine_entity.dart';
import 'pharmacy_medicine_card.dart';
import 'pharmacy_selected_card.dart';

class PharmacyMedicineContentSection extends StatelessWidget {
  const PharmacyMedicineContentSection({
    super.key,
    required this.medicines,
    required this.featuredMedicine,
    required this.onAddToCart,
    required this.onMedicineTap,
  });

  final List<PharmacyMedicineEntity> medicines;
  final PharmacyMedicineEntity featuredMedicine;
  final ValueChanged<PharmacyMedicineEntity> onAddToCart;
  final ValueChanged<PharmacyMedicineEntity> onMedicineTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final featured = featuredMedicine;
    return ListView(
      padding: EdgeInsets.fromLTRB(18.w, 16.h, 18.w, 24.h),
      children: [
        PharmacySelectedCard(
          featured: featured,
          onAddToCart: () => onAddToCart(featured),
        ),

        Divider(height: 30.h, color: AppColors.clrD8D8D8),
        Text(
          l10n.pharmacyMoreLike,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: AppColors.clr060,
            fontWeight: FontWeight.w500,
            fontSize: 22.sp / 1.6,
          ),
        ),
        SizedBox(height: 10.h),
        LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;
            final crossAxisCount = width >= 900
                ? 4
                : width >= 640
                ? 3
                : 2;
            final crossSpacing = 6.w;
            final mainSpacing = 16.h;
            final itemWidth =
                (width - (crossAxisCount - 1) * crossSpacing) / crossAxisCount;
            final itemHeight = width >= 640 ? 242.h : 220.h;
            final childAspectRatio = itemWidth / itemHeight;

            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: medicines.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                mainAxisSpacing: mainSpacing,
                crossAxisSpacing: crossSpacing,
                childAspectRatio: childAspectRatio,
              ),
              itemBuilder: (context, index) {
                final item = medicines[index];
                return PharmacyMedicineCard(
                  medicine: item,
                  onTap: () => onMedicineTap(item),
                  onAddToCart: () => onAddToCart(item),
                );
              },
            );
          },
        ),
      ],
    );
  }
}
