import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';
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
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Filter',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: const Color(0xFF061E40),
                      fontWeight: FontWeight.w700,
                      fontSize: 17.sp,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => context.pop(
                    const SurgeryBookingFilterSelection(
                      selectedHospital: null,
                      selectedSpecialty: null,
                    ),
                  ),
                  child: Text(
                    l10n.commonReset,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: const Color(0xFF0FAA9A),
                      fontWeight: FontWeight.w600,
                      fontSize: 14.sp,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            SurgeryBookingFilterRowWidget(
              label: selectedHospital ?? 'Hospital',
              onTap: () async {
                final selected = await _showSelectionDialog(
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
                final selected = await _showSelectionDialog(
                  title: 'Speciality',
                  options: widget.specialties,
                  selected: selectedSpecialty,
                );
                if (!mounted || selected == null) return;
                setState(() => selectedSpecialty = selected);
              },
            ),
            SizedBox(height: 18.h),
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
                  minimumSize: Size.fromHeight(50.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                child: Text(
                  l10n.commonProceed,
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

  Future<String?> _showSelectionDialog({
    required String title,
    required List<String> options,
    required String? selected,
  }) {
    return showDialog<String>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.45),
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
