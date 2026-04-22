import 'package:flutter/material.dart';

import '../../../../core/extensions/screen_util_extensions.dart';
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
    final featured = featuredMedicine;
    return ListView(
      padding: EdgeInsets.fromLTRB(18.w, 16.h, 18.w, 24.h),
      children: [
        PharmacySelectedCard(
          featured: featured,
          onAddToCart: () => onAddToCart(featured),
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
          itemCount: medicines.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 16.h,
            crossAxisSpacing: 6.w,
            childAspectRatio: 0.76,
          ),
          itemBuilder: (context, index) {
            final item = medicines[index];
            return PharmacyMedicineCard(
              medicine: item,
              onTap: () => onMedicineTap(item),
              onAddToCart: () => onAddToCart(item),
            );
          },
        ),
      ],
    );
  }
}
