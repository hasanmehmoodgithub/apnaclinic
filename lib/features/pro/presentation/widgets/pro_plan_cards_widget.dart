import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../domain/entities/pro_plan_entity.dart';

class ProPlanCardsWidget extends StatelessWidget {
  const ProPlanCardsWidget({
    super.key,
    required this.sectionTitle,
    required this.plans,
    required this.selectedPlanId,
    required this.onPlanSelected,
  });

  final String sectionTitle;
  final List<ProPlanEntity> plans;
  final String? selectedPlanId;
  final ValueChanged<String> onPlanSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          sectionTitle,
          style: TextStyle(
            color: AppColors.clr111827,
            fontWeight: FontWeight.w600,
            fontSize: 14.sp,
          ),
        ),
        SizedBox(height: 12.h),
        Row(
          children: [
            for (var i = 0; i < plans.length; i++) ...[
              if (i > 0) SizedBox(width: 8.w),
              Expanded(
                child: _PlanCard(
                  plan: plans[i],
                  isSelected: plans[i].planId == selectedPlanId,
                  onTap: () => onPlanSelected(plans[i].planId),
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }
}

class _PlanCard extends StatelessWidget {
  const _PlanCard({
    required this.plan,
    required this.isSelected,
    required this.onTap,
  });

  final ProPlanEntity plan;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.r),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 14.h),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.clrE8F8F5 : AppColors.clrF3F4F6,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: isSelected ? AppColors.clr1FAFA3 : AppColors.clrE3E8EE,
              width: isSelected ? 1.5 : 1,
            ),
          ),
          child: Column(
            children: [
              Text(
                plan.priceDisplay,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.clr111827,
                  fontWeight: FontWeight.w700,
                  fontSize: 14.sp,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                plan.durationDisplay,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.clr6B7280,
                  fontWeight: FontWeight.w500,
                  fontSize: 11.sp,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
