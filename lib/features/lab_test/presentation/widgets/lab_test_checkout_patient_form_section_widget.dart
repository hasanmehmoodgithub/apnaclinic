import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/utils/no_emoji_text_input_formatter.dart';

/// Patient details + emergency contact for checkout.
///
/// Design 1 (before Edit): read-only patient rows with **Edit**.
/// Design 2 (after Edit): editable form fields.
class LabTestCheckoutPatientFormSectionWidget extends StatelessWidget {
  const LabTestCheckoutPatientFormSectionWidget({
    super.key,
    required this.theme,
    required this.nameController,
    required this.phoneController,
    required this.ageController,
    required this.emergencyController,
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
  final String gender;
  final ValueChanged<String> onGender;
  final bool isEditingPatientDetails;
  final VoidCallback onToggleEdit;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final genderLabel =
        gender == 'female' ? l10n.commonFemale : l10n.commonMale;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (isEditingPatientDetails)
          _EditPatientCard(
            theme: theme,
            l10n: l10n,
            nameController: nameController,
            phoneController: phoneController,
            ageController: ageController,
            gender: gender,
            onGender: onGender,
            onDone: onToggleEdit,
          )
        else
          _ReadonlyPatientCard(
            theme: theme,
            l10n: l10n,
            name: nameController.text.trim(),
            genderLabel: genderLabel,
            age: ageController.text.trim(),
            phone: phoneController.text.trim(),
            onEdit: onToggleEdit,
          ),
        SizedBox(height: 12.h),
        _EmergencyContactCard(
          theme: theme,
          l10n: l10n,
          controller: emergencyController,
        ),
      ],
    );
  }
}

class _ReadonlyPatientCard extends StatelessWidget {
  const _ReadonlyPatientCard({
    required this.theme,
    required this.l10n,
    required this.name,
    required this.genderLabel,
    required this.age,
    required this.phone,
    required this.onEdit,
  });

  final ThemeData theme;
  final AppLocalizations l10n;
  final String name;
  final String genderLabel;
  final String age;
  final String phone;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                l10n.labTestPatientDetailsTitle,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: AppColors.clr061E40,
                  fontWeight: FontWeight.w600,
                  fontSize: 16.sp,
                ),
              ),
            ),
            TextButton(
              onPressed: onEdit,
              style: TextButton.styleFrom(
                foregroundColor: AppColors.clr024886,
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                l10n.commonEdit,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.clr024886,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 8.h),
        _ReadonlyRow(label: l10n.labTestPatientNameLabel, value: name),
        _Divider(),
        _ReadonlyRow(label: l10n.profileGenderLabel, value: genderLabel),
        _Divider(),
        _ReadonlyRow(label: l10n.labTestAgeLabel, value: age),
        _Divider(),
        _ReadonlyRow(label: l10n.labTestContactNumberLabel, value: phone),
      ],
    );
  }
}

class _EditPatientCard extends StatelessWidget {
  const _EditPatientCard({
    required this.theme,
    required this.l10n,
    required this.nameController,
    required this.phoneController,
    required this.ageController,
    required this.gender,
    required this.onGender,
    required this.onDone,
  });

  final ThemeData theme;
  final AppLocalizations l10n;
  final TextEditingController nameController;
  final TextEditingController phoneController;
  final TextEditingController ageController;
  final String gender;
  final ValueChanged<String> onGender;
  final VoidCallback onDone;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: 8.h),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  l10n.labTestPatientDetailsTitle,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: AppColors.clr061E40,
                    fontWeight: FontWeight.w500,
                    fontSize: 16.sp,
                  ),
                ),
              ),
              TextButton(
                onPressed: onDone,
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.clr024886,
                  padding: EdgeInsets.symmetric(horizontal: 8.w),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  l10n.commonDone,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.clr024886,
                  ),
                ),
              ),
            ],
          ),
        ),
        _WhiteCard(
          child: Padding(
            padding: EdgeInsets.fromLTRB(14.w, 12.h, 14.w, 14.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _LabeledField(
                  theme: theme,
                  label: l10n.labTestPatientNameLabel,
                  controller: nameController,
                ),
                SizedBox(height: 12.h),
                _LabeledField(
                  theme: theme,
                  label: l10n.labTestContactNumberLabel,
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                ),
                SizedBox(height: 12.h),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.profileGenderLabel,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: AppColors.clr061E40,
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 6.h),
                          SizedBox(
                            height: 34.h,
                            child: Row(
                              children: [
                                Expanded(
                                  child: _GenderRadio(
                                    label: l10n.commonMale,
                                    selected: gender == 'male',
                                    onTap: () => onGender('male'),
                                  ),
                                ),
                                SizedBox(width: 8.w),
                                Expanded(
                                  child: _GenderRadio(
                                    label: l10n.commonFemale,
                                    selected: gender == 'female',
                                    onTap: () => onGender('female'),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 12.w),
                    SizedBox(
                      width: 150.w,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.labTestAgeLabel,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: AppColors.clr061E40,
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 6.h),
                          SizedBox(
                            height: 34.h,
                            width: double.infinity,
                            child: _AgeInputBox(
                              theme: theme,
                              controller: ageController,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _EmergencyContactCard extends StatelessWidget {
  const _EmergencyContactCard({
    required this.theme,
    required this.l10n,
    required this.controller,
  });

  final ThemeData theme;
  final AppLocalizations l10n;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          l10n.labTestEmergencyContactTitle,
          style: theme.textTheme.titleMedium?.copyWith(
            color: AppColors.clr061E40,
            fontWeight: FontWeight.w600,
            fontSize: 16.sp,
          ),
        ),
        SizedBox(height: 6.h),
        Text(
          l10n.labTestEmergencyContactHintText,
          style: theme.textTheme.bodySmall?.copyWith(
            color: AppColors.clr667B99,
            fontSize: 12.sp,
            height: 1.35,
          ),
        ),
        SizedBox(height: 10.h),
        _InputBox(
          theme: theme,
          controller: controller,
          hint: l10n.labTestEmergencyNumberHint,
          keyboardType: TextInputType.phone,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(11),
          ],
        ),
      ],
    );
  }
}

class _WhiteCard extends StatelessWidget {
  const _WhiteCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.clrWhite,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: AppColors.clrE5E8EC),
      ),
      child: child,
    );
  }
}

class _ReadonlyRow extends StatelessWidget {
  const _ReadonlyRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: AppColors.clr667B99,
              fontSize: 13.sp,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              value.isEmpty ? '—' : value,
              textAlign: TextAlign.right,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppColors.clr061E40,
                fontSize: 13.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 0.5,
      color: AppColors.clrE7E7E7,
    );
  }
}

class _LabeledField extends StatelessWidget {
  const _LabeledField({
    required this.theme,
    required this.label,
    required this.controller,
    this.keyboardType,
  });

  final ThemeData theme;
  final String label;
  final TextEditingController controller;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: AppColors.clr061E40,
            fontSize: 12.sp,
          ),
        ),
        SizedBox(height: 6.h),
        _InputBox(
          theme: theme,
          controller: controller,
          keyboardType: keyboardType,
        ),
      ],
    );
  }
}

class _InputBox extends StatelessWidget {
  const _InputBox({
    required this.theme,
    required this.controller,
    this.hint,
    this.keyboardType,
    this.inputFormatters,
    this.textAlign = TextAlign.start,
  });

  final ThemeData theme;
  final TextEditingController controller;
  final String? hint;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final TextAlign textAlign;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: AppColors.clrF2F2F2,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        inputFormatters: NoEmojiTextInputFormatter.merge(
          inputFormatters,
          allowEmailSymbols: keyboardType == TextInputType.emailAddress,
          allowBasicPunctuation: keyboardType != TextInputType.number &&
              keyboardType != TextInputType.phone,
        ),
        textAlign: textAlign,
        style: theme.textTheme.bodyMedium?.copyWith(
          color: AppColors.clr061E40,
          fontSize: 14.sp,
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          isDense: true,
          hintText: hint,
          hintStyle: theme.textTheme.bodyMedium?.copyWith(
            color: AppColors.clr667B99,
            fontSize: 13.sp,
            fontWeight: FontWeight.w400,
          ),
          contentPadding: EdgeInsets.symmetric(vertical: 10.h),
        ),
      ),
    );
  }
}

/// Age field matching gender pill height: light grey fill, slight radius, no border.
class _AgeInputBox extends StatelessWidget {
  const _AgeInputBox({
    required this.theme,
    required this.controller,
  });

  final ThemeData theme;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.clrF2F2F2,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Align(
        alignment: Alignment.centerLeft,
        child: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          inputFormatters: NoEmojiTextInputFormatter.merge([
            FilteringTextInputFormatter.digitsOnly,
          ]),
          textAlign: TextAlign.left,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: AppColors.clr061E40,
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
            height: 1.2,
          ),
          decoration: InputDecoration(
            isCollapsed: true,
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(horizontal: 10.w),
          ),
        ),
      ),
    );
  }
}

class _GenderRadio extends StatelessWidget {
  const _GenderRadio({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final active = AppColors.clr024886;
    final inactive = AppColors.clr667B99;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20.r),
        child: Container(
          width: double.infinity,
          height: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 8.w),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColors.clrWhite,
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(
              color: selected ? active : AppColors.clrE7E7E7,
              width: selected ? 1.25 : 1,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 13.w,
                height: 13.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: selected ? active : inactive,
                    width: 1.25,
                  ),
                ),
                alignment: Alignment.center,
                child: selected
                    ? Container(
                        width: 6.w,
                        height: 6.w,
                        decoration: BoxDecoration(
                          color: active,
                          shape: BoxShape.circle,
                        ),
                      )
                    : null,
              ),
              SizedBox(width: 5.w),
              Flexible(
                child: Text(
                  label,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: selected ? active : inactive,
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w500,
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
