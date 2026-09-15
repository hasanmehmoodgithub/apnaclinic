import 'package:apnaclinic/generated/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../domain/entities/pro_benefit_entity.dart';

class ProBenefitsTableWidget extends StatelessWidget {
  const ProBenefitsTableWidget({
    super.key,
    required this.benefitsTitle,
    required this.basicColumnLabel,
    required this.proColumnLabel,
    required this.benefits,
  });

  final String benefitsTitle;
  final String basicColumnLabel;
  final String proColumnLabel;
  final List<ProBenefitEntity> benefits;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 8.h),
          child: Row(
            children: [
              Expanded(
                flex: 5,
                child: Text(
                  benefitsTitle,
                  style: TextStyle(
                    color: AppColors.clr111827,
                    fontWeight: FontWeight.w700,
                    fontSize: 13.sp,
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  basicColumnLabel,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.clr6B7280,
                    fontWeight: FontWeight.w600,
                    fontSize: 12.sp,
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Center(
                  child: SvgPicture.asset(
                    Assets.proProBadge,
                    height: 16.h,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ],
          ),
        ),
        Divider(height: 1.h, color: AppColors.clrE3E8EE),
        ...benefits.map((benefit) => _BenefitRow(benefit: benefit)),
      ],
    );
  }
}

class _BenefitRow extends StatelessWidget {
  const _BenefitRow({required this.benefit});

  final ProBenefitEntity benefit;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 10.h),
          child: Row(
            children: [
              Expanded(
                flex: 5,
                child: Row(
                  children: [
                    SvgPicture.asset(
                      Assets.proBadge,
                      width: 18.w,
                      height: 18.w,
                      fit: BoxFit.contain,
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: Text(
                        benefit.title,
                        style: TextStyle(
                          color: AppColors.clr111827,
                          fontWeight: FontWeight.w500,
                          fontSize: 12.sp,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  benefit.basicValue,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.clr6B7280,
                    fontWeight: FontWeight.w500,
                    fontSize: 12.sp,
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  benefit.proValue,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.clr111827,
                    fontWeight: benefit.highlightPro
                        ? FontWeight.w700
                        : FontWeight.w500,
                    fontSize: 12.sp,
                  ),
                ),
              ),
            ],
          ),
        ),
        Divider(height: 1.h, color: AppColors.clrWhite),
      ],
    );
  }
}
