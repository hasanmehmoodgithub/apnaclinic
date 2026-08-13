import 'package:flutter/material.dart';

import '../../../../core/extensions/screen_util_extensions.dart';
import '../../domain/entities/pharmacy_medicine_entity.dart';
import 'pharmacy_medicine_card.dart';

/// Grid section for filtered medicines on pharmacy main.
class PharmacyMainMedicinesGridWidget extends StatelessWidget {
  const PharmacyMainMedicinesGridWidget({
    super.key,
    required this.medicines,
    required this.onMedicineTap,
    required this.onAddToCartTap,
  });

  final List<PharmacyMedicineEntity> medicines;
  final ValueChanged<PharmacyMedicineEntity> onMedicineTap;
  final ValueChanged<PharmacyMedicineEntity> onAddToCartTap;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.only(top: 10.h),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: medicines.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 10.h,
        crossAxisSpacing: 10.w,
        childAspectRatio: 0.62,
      ),
      itemBuilder: (context, index) {
        final item = medicines[index];
        return PharmacyMedicineCard(
          medicine: item,
          onTap: () => onMedicineTap(item),
          onAddToCart: () => onAddToCartTap(item),
        );
      },
    );
  }
}
