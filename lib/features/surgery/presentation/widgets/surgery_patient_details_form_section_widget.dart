import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';
import 'surgery_gender_field_widget.dart';
import 'surgery_text_input_field_widget.dart';

class SurgeryPatientDetailsFormSectionWidget extends StatelessWidget {
  const SurgeryPatientDetailsFormSectionWidget({
    super.key,
    required this.patientNameController,
    required this.ageController,
    required this.contactNumberController,
    required this.emergencyContactController,
    required this.selectedGender,
    required this.showNameError,
    required this.showAgeError,
    required this.showGenderError,
    required this.showContactError,
    required this.showEmergencyError,
    required this.onGenderTap,
  });

  final TextEditingController patientNameController;
  final TextEditingController ageController;
  final TextEditingController contactNumberController;
  final TextEditingController emergencyContactController;
  final String? selectedGender;
  final bool showNameError;
  final bool showAgeError;
  final bool showGenderError;
  final bool showContactError;
  final bool showEmergencyError;
  final VoidCallback onGenderTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SurgeryTextInputFieldWidget(
          title: l10n.surgeryPatientNameLabel,
          hintText: l10n.surgeryPatientNameHint,
          controller: patientNameController,
          keyboardType: TextInputType.name,
          hasError: showNameError,
          errorText: l10n.surgeryPatientNameError,
        ),
        SizedBox(height: 14.h),
        SurgeryTextInputFieldWidget(
          title: l10n.surgeryPatientAgeLabel,
          hintText: l10n.surgeryPatientAgeHint,
          controller: ageController,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(3),
          ],
          hasError: showAgeError,
          errorText: l10n.surgeryPatientAgeError,
        ),
        SizedBox(height: 14.h),
        SurgeryGenderFieldWidget(
          selectedGender: selectedGender,
          hasError: showGenderError,
          onTap: onGenderTap,
        ),
        SizedBox(height: 14.h),
        SurgeryTextInputFieldWidget(
          title: l10n.surgeryContactNumberLabel,
          hintText: l10n.surgeryContactNumberHint,
          controller: contactNumberController,
          keyboardType: TextInputType.phone,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(11),
          ],
          hasError: showContactError,
          errorText: l10n.surgeryContactNumberError,
        ),
        SizedBox(height: 14.h),
        SurgeryTextInputFieldWidget(
          title: l10n.surgeryEmergencyContactLabel,
          hintText: l10n.surgeryEmergencyContactHint,
          controller: emergencyContactController,
          keyboardType: TextInputType.phone,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(11),
          ],
          hasError: showEmergencyError,
          errorText: l10n.surgeryEmergencyContactError,
        ),
      ],
    );
  }
}
