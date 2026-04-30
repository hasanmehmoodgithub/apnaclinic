import 'package:flutter/material.dart';

import '../../../../core/extensions/screen_util_extensions.dart';
import '../../domain/entities/pharmacy_medicine_entity.dart';
import 'pharmacy_medicine_card.dart';

class PharmacyMainContentSection extends StatelessWidget {
  const PharmacyMainContentSection({
    super.key,
    required this.medicines,
    required this.searchQuery,
    required this.onSearchChanged,
    required this.onMedicineTap,
    required this.onAddToCartTap,
  });

  final List<PharmacyMedicineEntity> medicines;
  final String searchQuery;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<PharmacyMedicineEntity> onMedicineTap;
  final ValueChanged<PharmacyMedicineEntity> onAddToCartTap;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.fromLTRB(18.w, 16.h, 18.w, 24.h),
      children: [
        Text(
          'Choose Medicine',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: const Color(0xFF1A2B49),
                fontWeight: FontWeight.w600,
              ),
        ),
        SizedBox(height: 10.h),
        SizedBox(
          height: 45.r,
          child: TextFormField(
            onChanged: onSearchChanged,
            initialValue: searchQuery,
            decoration: InputDecoration(
              hintText: 'Search name..',
              suffixIcon: const Icon(Icons.search, color: Color(0xFF9AA4B2)),
              filled: true,
              fillColor: Colors.white,
              contentPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14.r),
                borderSide: const BorderSide(color: Color(0xFFE3E8EE)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14.r),
                borderSide: const BorderSide(color: Color(0xFFE3E8EE)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14.r),
                borderSide: const BorderSide(color: Color(0xFF9EC7E8)),
              ),
            ),
          ),
        ),
        SizedBox(height: 8.h),
        if (medicines.isEmpty)
          Padding(
            padding: EdgeInsets.symmetric(vertical: 28.h),
            child: Center(
              child: Text(
                'No medicine found',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: const Color(0xFF6C7C92),
                    ),
              ),
            ),
          )
        else
          GridView.builder(
            padding: EdgeInsets.only(top: 10),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: medicines.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 0.h,
              crossAxisSpacing: 8.w,
              childAspectRatio: 0.76,
            ),
            itemBuilder: (context, index) {
              final item = medicines[index];
              return PharmacyMedicineCard(
                medicine: item,
                onTap: () => onMedicineTap(item),
                onAddToCart: () => onAddToCartTap(item),
              );
            },
          ),
      ],
    );
  }
}
