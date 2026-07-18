import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';
import 'surgery_booking_filter_row_widget.dart';
import 'surgery_booking_filter_selection.dart';
import 'surgery_booking_filter_selection_sheet_widget.dart';

enum _SurgeryBookingFilterStep { main, hospital, specialty }

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
  _SurgeryBookingFilterStep _step = _SurgeryBookingFilterStep.main;

  @override
  void initState() {
    super.initState();
    selectedHospital = widget.selectedHospital;
    selectedSpecialty = widget.selectedSpecialty;
  }

  void _openHospitalStep() {
    setState(() => _step = _SurgeryBookingFilterStep.hospital);
  }

  void _openSpecialtyStep() {
    setState(() => _step = _SurgeryBookingFilterStep.specialty);
  }

  void _returnToMainStep() {
    setState(() => _step = _SurgeryBookingFilterStep.main);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 20.w),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.r)),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 20.h),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: switch (_step) {
            _SurgeryBookingFilterStep.main => KeyedSubtree(
              key: const ValueKey('filter-main'),
              child: _buildMainStep(context),
            ),
            _SurgeryBookingFilterStep.hospital => KeyedSubtree(
              key: const ValueKey('filter-hospital'),
              child: SurgeryBookingFilterSelectionContentWidget(
                title: 'Hospital',
                options: widget.hospitals,
                selected: selectedHospital,
                onBack: _returnToMainStep,
                onSelected: (value) {
                  selectedHospital = value;
                  _returnToMainStep();
                },
              ),
            ),
            _SurgeryBookingFilterStep.specialty => KeyedSubtree(
              key: const ValueKey('filter-specialty'),
              child: SurgeryBookingFilterSelectionContentWidget(
                title: 'Speciality',
                options: widget.specialties,
                selected: selectedSpecialty,
                onBack: _returnToMainStep,
                onSelected: (value) {
                  selectedSpecialty = value;
                  _returnToMainStep();
                },
              ),
            ),
          },
        ),
      ),
    );
  }

  Widget _buildMainStep(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Column(
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
          onTap: _openHospitalStep,
        ),
        SizedBox(height: 12.h),
        SurgeryBookingFilterRowWidget(
          label: selectedSpecialty ?? 'Speciality',
          onTap: _openSpecialtyStep,
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
              l10n.commonApplyFilter,
              style: theme.textTheme.titleSmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 14.sp,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
