import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/extensions/screen_util_extensions.dart';
import 'surgery_booking_filter_row_widget.dart';
import 'surgery_booking_filter_selection.dart';
import 'surgery_booking_filter_selection_sheet_widget.dart';

class SurgeryBookingFilterSheetWidget extends StatefulWidget {
  const SurgeryBookingFilterSheetWidget({
    super.key,
    required this.hospitals,
    required this.specialties,
    required this.selectedHospital,
    required this.selectedSpecialty,
  });

  final List<String> hospitals;
  final List<String> specialties;
  final String? selectedHospital;
  final String? selectedSpecialty;

  @override
  State<SurgeryBookingFilterSheetWidget> createState() =>
      _SurgeryBookingFilterSheetWidgetState();
}

class _SurgeryBookingFilterSheetWidgetState
    extends State<SurgeryBookingFilterSheetWidget> {
  String? selectedHospital;
  String? selectedSpecialty;

  @override
  void initState() {
    super.initState();
    selectedHospital = widget.selectedHospital;
    selectedSpecialty = widget.selectedSpecialty;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsets.fromLTRB(20.w, 14.h, 20.w, 20.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: const Color(0xFFCACACA),
                  borderRadius: BorderRadius.circular(100.r),
                ),
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              'Filter',
              style: theme.textTheme.titleMedium?.copyWith(
                color: Colors.black,
                fontWeight: FontWeight.w700,
                fontSize: 14.sp,
              ),
            ),
            SizedBox(height: 14.h),
            SurgeryBookingFilterRowWidget(
              label: selectedHospital ?? 'Hospital',
              onTap: () async {
                final selected = await _showSelectionSheet(
                  title: 'Hospital',
                  options: widget.hospitals,
                  selected: selectedHospital,
                );
                if (!mounted || selected == null) return;
                setState(() => selectedHospital = selected);
              },
            ),
            SizedBox(height: 12.h),
            SurgeryBookingFilterRowWidget(
              label: selectedSpecialty ?? 'Speciality',
              onTap: () async {
                final selected = await _showSelectionSheet(
                  title: 'Speciality',
                  options: widget.specialties,
                  selected: selectedSpecialty,
                );
                if (!mounted || selected == null) return;
                setState(() => selectedSpecialty = selected);
              },
            ),
            SizedBox(height: 15.h),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () => context.pop(
                  SurgeryBookingFilterSelection(
                    selectedHospital: selectedHospital,
                    selectedSpecialty: selectedSpecialty,
                  ),
                ),
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFF0FAA9A),
                  minimumSize: Size.fromHeight(54.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.909.r),
                  ),
                ),
                child: Text(
                  'Proceed',
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 14.sp,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<String?> _showSelectionSheet({
    required String title,
    required List<String> options,
    required String? selected,
  }) {
    return showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3.r)),
      builder: (context) {
        return SurgeryBookingFilterSelectionSheetWidget(
          title: title,
          options: options,
          selected: selected,
        );
      },
    );
  }
}
