import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/extensions/screen_util_extensions.dart';
import 'surgery_booking_filter_row_widget.dart';

class SurgeryBookingFilterSelectionSheetWidget extends StatefulWidget {
  const SurgeryBookingFilterSelectionSheetWidget({
    super.key,
    required this.title,
    required this.options,
    required this.selected,
  });

  final String title;
  final List<String> options;
  final String? selected;

  @override
  State<SurgeryBookingFilterSelectionSheetWidget> createState() =>
      _SurgeryBookingFilterSelectionSheetWidgetState();
}

class _SurgeryBookingFilterSelectionSheetWidgetState
    extends State<SurgeryBookingFilterSelectionSheetWidget> {
  late String? selected;

  @override
  void initState() {
    super.initState();
    selected = widget.selected;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsets.fromLTRB(24.w, 18.h, 24.w, 18.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 36.98.w,
              height: 2.h,
              decoration: BoxDecoration(
                color: const Color(0xFFC4C4C4),
                borderRadius: BorderRadius.circular(100.r),
              ),
            ),
            SizedBox(height: 18.h),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Filter',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: 14.sp,
                  color: Colors.black,
                ),
              ),
            ),
            SizedBox(height: 16.h),
            SurgeryBookingFilterRowWidget(label: selected ?? widget.title, onTap: () {}),
            Container(
              constraints: BoxConstraints(maxHeight: 352.h),
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFFD0D0D0), width: 0.253),
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(4.r)),
                boxShadow: const [
                  BoxShadow(
                    color: Color.fromRGBO(0, 0, 0, 0.35),
                    blurRadius: 17,
                    offset: Offset(0, 4),
                    spreadRadius: -10,
                  ),
                ],
              ),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: widget.options.length,
                itemBuilder: (context, index) {
                  final option = widget.options[index];
                  final isSelected = option == selected;
                  return InkWell(
                    onTap: () => setState(() => selected = option),
                    child: Container(
                      height: 44.h,
                      padding: EdgeInsets.symmetric(horizontal: 12.w),
                      decoration: BoxDecoration(
                        color: isSelected ? const Color(0xFFF1F1F1) : Colors.white,
                        border: const Border(
                          bottom: BorderSide(
                            color: Color(0xFFD0D0D0),
                            width: 0.253,
                          ),
                        ),
                      ),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        option,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: const Color(0xFF061E40),
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 16.h),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () => context.pop(selected),
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFF0FAA9A),
                  minimumSize: Size.fromHeight(57.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.9.r),
                  ),
                ),
                child: Text(
                  'Proceed',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: Colors.white,
                    fontSize: 12.9.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
