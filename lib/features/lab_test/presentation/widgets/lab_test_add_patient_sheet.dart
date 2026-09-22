import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/preference/app_pref.dart';
import '../../../../core/utils/max_int_text_input_formatter.dart';
import '../../../../core/utils/no_emoji_text_input_formatter.dart';
import '../../domain/entities/lab_test_patient_details.dart';

Future<LabTestPatientDetails?> showLabTestAddPatientSheet(
  BuildContext context, {
  LabTestPatientDetails? initial,
}) {
  return showModalBottomSheet<LabTestPatientDetails>(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppColors.clrWhite,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
    ),
    builder: (context) => LabTestAddPatientSheetWidget(
      initial: initial ?? labTestPatientFromAppPref(sl<AppPref>()),
    ),
  );
}

LabTestPatientDetails? labTestPatientFromAppPref(AppPref appPref) {
  final user = appPref.getUserLocalModel();
  if (user == null) return null;

  final name = '${user.firstName} ${user.lastName}'.trim();
  final gender = _normalizeGender(user.gender) ?? 'male';
  final age = _ageFromDateOfBirth(user.dateOfBirth);

  if (name.isEmpty && age == null) {
    return LabTestPatientDetails(name: '', age: '', gender: gender);
  }

  return LabTestPatientDetails(
    name: name,
    age: age != null && age > 0 && age <= 99 ? age.toString() : '',
    gender: gender,
  );
}

String? _normalizeGender(String rawGender) {
  final value = rawGender.trim().toLowerCase();
  if (value.isEmpty) return null;
  if (value == 'female' || value == 'f') return 'female';
  if (value == 'male' || value == 'm') return 'male';
  return null;
}

int? _ageFromDateOfBirth(String rawDob) {
  final value = rawDob.trim();
  if (value.isEmpty) return null;
  final dob = DateTime.tryParse(value);
  if (dob == null) return null;
  final now = DateTime.now();
  var age = now.year - dob.year;
  final hasHadBirthday =
      now.month > dob.month || (now.month == dob.month && now.day >= dob.day);
  if (!hasHadBirthday) age -= 1;
  return age;
}

class LabTestAddPatientSheetWidget extends StatefulWidget {
  const LabTestAddPatientSheetWidget({super.key, this.initial});

  final LabTestPatientDetails? initial;

  @override
  State<LabTestAddPatientSheetWidget> createState() =>
      _LabTestAddPatientSheetWidgetState();
}

class _LabTestAddPatientSheetWidgetState
    extends State<LabTestAddPatientSheetWidget> {
  late final TextEditingController _nameController;
  late final TextEditingController _ageController;
  late String _gender;

  @override
  void initState() {
    super.initState();
    final initial = widget.initial;
    _nameController = TextEditingController(text: initial?.name ?? '');
    final initialAge = int.tryParse(initial?.age ?? '') ?? 0;
    _ageController = TextEditingController(
      text: initialAge > 0 && initialAge <= 99 ? initialAge.toString() : '',
    );
    _gender = initial?.gender == 'female' ? 'female' : 'male';
    _nameController.addListener(_onChanged);
    _ageController.addListener(_onChanged);
  }

  @override
  void dispose() {
    _nameController
      ..removeListener(_onChanged)
      ..dispose();
    _ageController
      ..removeListener(_onChanged)
      ..dispose();
    super.dispose();
  }

  void _onChanged() => setState(() {});

  bool get _canSubmit {
    final name = _nameController.text.trim();
    final age = int.tryParse(_ageController.text.trim()) ?? 0;
    return name.isNotEmpty && age > 0 && age <= 99;
  }

  void _submit() {
    if (!_canSubmit) return;
    context.pop(
      LabTestPatientDetails(
        name: _nameController.text.trim(),
        age: _ageController.text.trim(),
        gender: _gender,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;

    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(24.w, 10.h, 24.w, 16.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 40.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: AppColors.clrD6DCE2,
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              Text(
                l10n.labTestAddPatientSheetTitle,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: AppColors.clr061E40,
                  fontWeight: FontWeight.w600,
                  fontSize: 18.sp,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                l10n.labTestAddPatientSeparateCharges,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: AppColors.clr667B99,
                  fontSize: 13.sp,
                  height: 1.3,
                ),
              ),
              SizedBox(height: 18.h),
              Text(
                l10n.labTestPatientNameLabel,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: AppColors.clr061E40,
                  fontWeight: FontWeight.w500,
                  fontSize: 14.sp,
                ),
              ),
              SizedBox(height: 8.h),
              _SheetInput(
                controller: _nameController,
                hint: l10n.labTestFullNameHint,
                keyboardType: TextInputType.name,
              ),
              SizedBox(height: 14.h),
              Text(
                l10n.labTestAgeLabel,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: AppColors.clr061E40,
                  fontWeight: FontWeight.w500,
                  fontSize: 14.sp,
                ),
              ),
              SizedBox(height: 8.h),
              _SheetInput(
                controller: _ageController,
                hint: l10n.labTestAgeLabel,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(2),
                  const MaxIntTextInputFormatter(99),
                ],
              ),
              SizedBox(height: 14.h),
              Text(
                l10n.profileGenderLabel,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: AppColors.clr061E40,
                  fontWeight: FontWeight.w500,
                  fontSize: 14.sp,
                ),
              ),
              SizedBox(height: 8.h),
              SizedBox(
                height: 48.h,
                child: Row(
                  children: [
                    Expanded(
                      child: _GenderPill(
                        label: l10n.commonMale,
                        selected: _gender == 'male',
                        onTap: () => setState(() => _gender = 'male'),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: _GenderPill(
                        label: l10n.commonFemale,
                        selected: _gender == 'female',
                        onTap: () => setState(() => _gender = 'female'),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.h),
              SizedBox(
                height: 57.h,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: _canSubmit
                        ? AppColors.clr0FAA9A
                        : AppColors.clr9BA6A7,
                    foregroundColor: AppColors.clrWhite,
                    disabledBackgroundColor: AppColors.clr9BA6A7,
                    disabledForegroundColor: AppColors.clrWhite,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.909.r),
                    ),
                    textStyle: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 16.sp,
                    ),
                  ),
                  onPressed: _canSubmit ? _submit : null,
                  child: Text(l10n.labTestAddPatientCta),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SheetInput extends StatelessWidget {
  const _SheetInput({
    required this.controller,
    required this.hint,
    this.keyboardType,
    this.inputFormatters,
  });

  final TextEditingController controller;
  final String hint;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      height: 48.h,
      padding: EdgeInsets.symmetric(horizontal: 14.w),
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
        color: AppColors.clrF2F2F2,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        inputFormatters: NoEmojiTextInputFormatter.merge(
          inputFormatters,
          allowBasicPunctuation: keyboardType != TextInputType.number,
        ),
        style: theme.textTheme.bodyMedium?.copyWith(
          color: AppColors.clr061E40,
          fontSize: 14.sp,
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          isDense: true,
          border: InputBorder.none,
          hintText: hint,
          hintStyle: theme.textTheme.bodyMedium?.copyWith(
            color: AppColors.clr667B99,
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }
}

class _GenderPill extends StatelessWidget {
  const _GenderPill({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final active = AppColors.clr061E40;
    final inactive = AppColors.clr667B99;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(28.r),
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColors.clrWhite,
            borderRadius: BorderRadius.circular(28.r),
            border: Border.all(
              color: selected ? active : AppColors.clrE7E7E7,
              width: selected ? 1.25 : 1,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 16.w,
                height: 16.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: selected ? active : inactive,
                    width: 1.5,
                  ),
                ),
                alignment: Alignment.center,
                child: selected
                    ? Container(
                        width: 8.w,
                        height: 8.w,
                        decoration: BoxDecoration(
                          color: active,
                          shape: BoxShape.circle,
                        ),
                      )
                    : null,
              ),
              SizedBox(width: 8.w),
              Text(
                label,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: selected ? active : inactive,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
