import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../generated/assets.dart';
import '../cubit/lab_test_cubit.dart';
import '../cubit/lab_test_state.dart';
import 'lab_test_figma_image.dart';

/// City summary row; only rebuilds when [LabTestState.selectedCity] changes.
class LabTestCitySelectorFieldWidget extends StatelessWidget {
  const LabTestCitySelectorFieldWidget({
    super.key,
    required this.selectCityPlaceholder,
    required this.cityFieldLabel,
    required this.changeCityCta,
    required this.onTap,
  });

  final String selectCityPlaceholder;
  final String cityFieldLabel;
  final String changeCityCta;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocSelector<LabTestCubit, LabTestState, String?>(
      selector: (s) => s.selectedCity,
      builder: (context, selectedCity) {
        return Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(5.32.r),
            child: Container(
              height: 62.h,
              padding: EdgeInsets.symmetric(horizontal: 13.w, vertical: 14.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5.32.r),
                border: Border.all(
                  color: const Color(0xFF9BA6A7),
                  width: 1.0,
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: selectedCity == null || selectedCity.isEmpty
                        ? Text(
                            selectCityPlaceholder,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: const Color(0xFF061E40),
                              fontWeight: FontWeight.w500,
                              fontSize: 14.sp,
                            ),
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                cityFieldLabel,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: const Color(0xFF667B99),
                                  fontSize: 12.sp,
                                  height: 1,
                                ),
                              ),
                              Text(
                                selectedCity,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: const Color(0xFF061E40),
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14.sp,
                                  height: 1,
                                ),
                              ),
                            ],
                          ),
                  ),
                  Text(
                    changeCityCta,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: const Color(0xFF667B99),
                      fontSize: 12.sp,
                      height: 1,
                    ),
                  ),
                  SizedBox(width: 4.w),
                  LabTestFigmaImage(
                    url: Assets.labTestCityChevron,
                    width: 8,
                    height: 4,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
