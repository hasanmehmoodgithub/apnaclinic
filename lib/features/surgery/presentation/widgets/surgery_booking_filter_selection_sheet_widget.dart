import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';
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
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 20.w),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.r)),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 20.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              widget.title,
              style: theme.textTheme.titleMedium?.copyWith(
                color: const Color(0xFF061E40),
                fontWeight: FontWeight.w700,
                fontSize: 17.sp,
              ),
            ),
            SizedBox(height: 16.h),
            SurgeryBookingFilterRowWidget(
              label: selected ?? widget.title,
              onTap: () {},
            ),
            SizedBox(height: 8.h),
            Container(
              constraints: BoxConstraints(maxHeight: 280.h),
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFFD0D0D0), width: 0.5),
                borderRadius: BorderRadius.circular(4.r),
              ),
              clipBehavior: Clip.antiAlias,
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
                        color:
                            isSelected ? const Color(0xFFF1F1F1) : Colors.white,
                        border: Border(
                          bottom: index < widget.options.length - 1
                              ? const BorderSide(
                                  color: Color(0xFFD0D0D0),
                                  width: 0.5,
                                )
                              : BorderSide.none,
                        ),
                      ),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        option,
                        style: theme.textTheme.titleSmall?.copyWith(
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
            SizedBox(height: 18.h),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () => context.pop(selected),
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFF0FAA9A),
                  minimumSize: Size.fromHeight(50.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                child: Text(
                  l10n.commonProceed,
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: Colors.white,
                    fontSize: 14.sp,
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
