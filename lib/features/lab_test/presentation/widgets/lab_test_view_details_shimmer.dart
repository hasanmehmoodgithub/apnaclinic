import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../components/shimmer/app_shimmer.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/widgets/app_scaffold_gradient.dart';

class LabTestViewDetailsShimmer extends StatelessWidget {
  const LabTestViewDetailsShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffoldGradient(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 4, 16, 18),
            child: Row(
              children: [
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: () => context.pop(),
                    child: const SizedBox(
                      width: 40,
                      height: 40,
                      child: Icon(
                        Icons.arrow_back_rounded,
                        color: Color(0xFF061E40),
                        size: 24,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    'View details',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: const Color(0xFF061E40),
                      fontWeight: FontWeight.w700,
                      fontSize: 20.sp,
                    ),
                  ),
                ),
                const SizedBox(width: 40),
              ],
            ),
          ),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFFF4F4F4),
                borderRadius: BorderRadius.vertical(top: Radius.circular(42.r)),
              ),
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(20.w, 22.h, 20.w, 20.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppShimmerText(width: 90.w, height: 18.h, borderRadius: 6.r),
                    SizedBox(height: 10.h),
                    AppShimmerCard(height: 146.h, borderRadius: 12.r),
                    SizedBox(height: 18.h),
                    AppShimmerText(width: 90.w, height: 18.h, borderRadius: 6.r),
                    SizedBox(height: 10.h),
                    AppShimmerCard(height: 190.h, borderRadius: 12.r),
                    SizedBox(height: 16.h),
                    AppShimmerCard(height: 58.h, borderRadius: 10.r),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
