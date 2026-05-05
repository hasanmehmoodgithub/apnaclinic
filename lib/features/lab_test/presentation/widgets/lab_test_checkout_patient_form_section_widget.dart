import 'package:flutter/material.dart';

import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../generated/assets.dart';
import 'lab_test_figma_image.dart';

class LabTestCheckoutPatientFormSectionWidget extends StatelessWidget {
  const LabTestCheckoutPatientFormSectionWidget({
    super.key,
    required this.theme,
    required this.nameController,
    required this.phoneController,
    required this.ageController,
    required this.emergencyController,
    required this.addressController,
    required this.gender,
    required this.onGender,
    required this.isEditingPatientDetails,
    required this.onToggleEdit,
  });

  final ThemeData theme;
  final TextEditingController nameController;
  final TextEditingController phoneController;
  final TextEditingController ageController;
  final TextEditingController emergencyController;
  final TextEditingController addressController;
  final String gender;
  final ValueChanged<String> onGender;
  final bool isEditingPatientDetails;
  final VoidCallback onToggleEdit;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(l10n.labTestPatientDetailsTitle),
            TextButton(
              onPressed: onToggleEdit,
              child: Text(isEditingPatientDetails ? l10n.commonDone : l10n.commonEdit),
            ),
          ],
        ),
        _field(context, l10n.labTestPatientNameLabel, nameController, l10n.labTestFullNameHint),
        _field(context, l10n.labTestContactNumberLabel, phoneController, l10n.labTestPhonebookHint, suffix: LabTestFigmaImage(url: Assets.labTestAddressBook, width: 16, height: 16)),
        _field(context, l10n.labTestAgeLabel, ageController, ''),
        _field(context, l10n.labTestAddressLabel, addressController, l10n.labTestAddressHint),
        const SizedBox(height: 8),
        Text(l10n.labTestEmergencyContactTitle),
        _field(context, '', emergencyController, l10n.labTestEmergencyNumberHint),
        Row(
          children: [
            Expanded(child: _genderChip(context, l10n.commonMale, gender == 'male', () => onGender('male'))),
            const SizedBox(width: 8),
            Expanded(child: _genderChip(context, l10n.commonFemale, gender == 'female', () => onGender('female'))),
          ],
        ),
      ],
    );
  }

  Widget _field(BuildContext context, String label, TextEditingController c, String hint, {Widget? suffix}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        if (label.isNotEmpty) Text(label),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFFF2F2F2),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Row(children: [
            Expanded(
              child: TextField(
                controller: c,
                style: theme.textTheme.bodySmall?.copyWith(fontSize: 12.sp),
                decoration: InputDecoration(border: InputBorder.none, isDense: true, hintText: hint),
              ),
            ),
            suffix ?? const SizedBox.shrink(),
          ]),
        ),
      ]),
    );
  }

  Widget _genderChip(BuildContext context, String label, bool selected, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: selected ? const Color(0xFF061E40) : const Color(0xFFE7E7E7)),
        ),
        child: Center(child: Text(label)),
      ),
    );
  }
}
