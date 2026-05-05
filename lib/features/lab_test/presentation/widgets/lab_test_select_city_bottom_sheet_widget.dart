import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../generated/assets.dart';
import 'lab_test_figma_image.dart';

/// Bottom sheet to pick a city from the catalog city list.
class LabTestSelectCityBottomSheetWidget extends StatefulWidget {
  const LabTestSelectCityBottomSheetWidget({
    super.key,
    required this.cities,
    required this.sheetTitle,
    required this.searchHint,
  });

  final List<String> cities;
  final String sheetTitle;
  final String searchHint;

  @override
  State<LabTestSelectCityBottomSheetWidget> createState() =>
      _LabTestSelectCityBottomSheetWidgetState();
}

class _LabTestSelectCityBottomSheetWidgetState
    extends State<LabTestSelectCityBottomSheetWidget> {
  final TextEditingController _query = TextEditingController();

  @override
  void dispose() {
    _query.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bottom = MediaQuery.paddingOf(context).bottom;
    final filtered = widget.cities
        .where(
          (c) => c.toLowerCase().contains(_query.text.trim().toLowerCase()),
        )
        .toList();

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.vertical(top: Radius.circular(12.r)),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(24.w, 18.h, 24.w, 0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              LabTestFigmaImage(
                url: Assets.labTestSheetHandle,
                width: 37,
                height: 4,
              ),
              SizedBox(height: 18.h),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  widget.sheetTitle,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: const Color(0xFF061E40),
                    fontWeight: FontWeight.w700,
                    fontSize: 16.437.sp,
                  ),
                ),
              ),
              SizedBox(height: 24.h),
              Container(
                height: 45.h,
                padding: EdgeInsets.symmetric(horizontal: 11.w),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: const Color(0xFF9BA6A7),
                    width: 1.0,
                  ),
                ),
                child: Row(
                  children: [
                    LabTestFigmaImage(
                      url: Assets.labTestSearchGlyph,
                      width: 19,
                      height: 19,
                    ),
                    SizedBox(width: 14.w),
                    Expanded(
                      child: TextField(
                        controller: _query,
                        onChanged: (_) => setState(() {}),
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: const Color(0xFF061E40),
                          fontSize: 14.sp,
                        ),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          isDense: true,
                          hintText: widget.searchHint,
                          hintStyle: theme.textTheme.bodyMedium?.copyWith(
                            color: const Color(0xFF9E9E9E),
                            fontWeight: FontWeight.w500,
                            fontSize: 14.sp,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 12.h),
              SizedBox(
                height: MediaQuery.sizeOf(context).height * 0.42,
                child: ListView.separated(
                  itemCount: filtered.length,
                  separatorBuilder: (context, index) => SizedBox(height: 12.h),
                  itemBuilder: (context, i) {
                    final city = filtered[i];
                    return Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () => context.pop(city),
                        borderRadius: BorderRadius.circular(4.r),
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(
                            horizontal: 12.w,
                            vertical: 16.h,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4.r),
                            border: Border.all(
                              color: const Color(0xFF9BA6A7),
                              width: 1.0,
                            ),
                          ),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            city,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: const Color(0xFF061E40),
                              fontWeight: FontWeight.w500,
                              fontSize: 14.sp,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 11.h + bottom),
              Center(
                child: Container(
                  width: 135.w,
                  height: 5.h,
                  margin: EdgeInsets.only(bottom: 8.h),
                  decoration: BoxDecoration(
                    color: const Color(0xFFB9C0C9),
                    borderRadius: BorderRadius.circular(100.r),
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
