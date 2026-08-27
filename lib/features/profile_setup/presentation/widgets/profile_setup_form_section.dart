import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../components/widgets/app_button.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/utils/no_emoji_text_input_formatter.dart';
import '../cubit/profile_setup_state.dart';

const int _kProfileNameMaxLength = 50;
const int _kProfileAddressMaxLength = 255;

class ProfileSetupFormSection extends StatelessWidget {
  const ProfileSetupFormSection({
    super.key,
    required this.formKey,
    required this.firstNameController,
    required this.lastNameController,
    required this.emailController,
    required this.addressController,
    required this.state,
    required this.dobLabel,
    required this.onPickGender,
    required this.onPickDate,
    required this.onSave,
    required this.isUpdateMode,
    required this.inputDecorationBuilder,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController emailController;
  final TextEditingController addressController;
  final ProfileSetupState state;
  final String dobLabel;
  final VoidCallback onPickGender;
  final VoidCallback onPickDate;
  final VoidCallback onSave;
  final bool isUpdateMode;
  final InputDecoration Function({
    required String hintText,
    Widget? suffixIcon,
    bool isValueText,
  })
  inputDecorationBuilder;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    return Expanded(
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.clrWhite,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(18.w, 20.h, 18.w, 24.h),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  isUpdateMode ? l10n.profileTitle : l10n.profileSetupTitle,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.clr060,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  isUpdateMode
                      ? l10n.profileUpdateSubtitle
                      : l10n.profileSetupSubtitle,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.clr98A2B3,
                  ),
                ),
                SizedBox(height: 18.h),
                _ProfileFieldLabel(text: l10n.profileFirstNameLabel),
                TextFormField(
                  controller: firstNameController,
                  maxLength: _kProfileNameMaxLength,
                  inputFormatters: NoEmojiTextInputFormatter.merge(
                    <TextInputFormatter>[
                      LengthLimitingTextInputFormatter(_kProfileNameMaxLength),
                    ],
                    allowBasicPunctuation: true,
                  ),
                  decoration: inputDecorationBuilder(
                    hintText: l10n.profileFirstNameHint,
                  ).copyWith(counterText: ''),
                  validator: (value) {
                    if ((value ?? '').trim().isEmpty) {
                      return l10n.profileFirstNameRequired;
                    }
                    return null;
                  },
                ),
                SizedBox(height: 22.h),
                _ProfileFieldLabel(text: l10n.profileLastNameLabel),
                TextFormField(
                  controller: lastNameController,
                  maxLength: _kProfileNameMaxLength,
                  inputFormatters: NoEmojiTextInputFormatter.merge(
                    <TextInputFormatter>[
                      LengthLimitingTextInputFormatter(_kProfileNameMaxLength),
                    ],
                    allowBasicPunctuation: true,
                  ),
                  decoration: inputDecorationBuilder(
                    hintText: l10n.profileLastNameHint,
                  ).copyWith(counterText: ''),
                  validator: (value) {
                    if ((value ?? '').trim().isEmpty) {
                      return l10n.profileLastNameRequired;
                    }
                    return null;
                  },
                ),
                SizedBox(height: 22.h),
                _ProfileFieldLabel(text: l10n.profileGenderLabel),
                InkWell(
                  onTap: onPickGender,
                  child: IgnorePointer(
                    child: TextFormField(
                      decoration: inputDecorationBuilder(
                        hintText: state.selectedGender == null
                            ? l10n.profileGenderHint
                            : state.selectedGender == 'male'
                            ? l10n.profileGenderMale
                            : l10n.profileGenderFemale,
                        suffixIcon: Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: AppColors.clr0FAA9A,
                          size: 22.r,
                        ),
                        isValueText: state.selectedGender != null,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 22.h),
                _ProfileFieldLabel(text: l10n.profileEmailLabel),
                TextFormField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  inputFormatters: NoEmojiTextInputFormatter.merge(
                    const <TextInputFormatter>[],
                    allowEmailSymbols: true,
                  ),
                  decoration: inputDecorationBuilder(
                    hintText: l10n.profileEmailHint,
                  ),
                  validator: (value) {
                    final email = (value ?? '').trim();
                    if (email.isEmpty) return null;
                    if (!email.contains('@')) {
                      return l10n.profileEmailRequired;
                    }
                    return null;
                  },
                ),
                SizedBox(height: 22.h),
                _ProfileFieldLabel(text: l10n.profileAddressLabel),
                TextFormField(
                  controller: addressController,
                  maxLength: _kProfileAddressMaxLength,
                  inputFormatters: NoEmojiTextInputFormatter.merge(
                    <TextInputFormatter>[
                      LengthLimitingTextInputFormatter(
                        _kProfileAddressMaxLength,
                      ),
                    ],
                    allowSpecialCharacters: true,
                  ),
                  decoration: inputDecorationBuilder(
                    hintText: l10n.profileAddressHint,
                  ).copyWith(counterText: ''),
                  validator: (value) {
                    if ((value ?? '').trim().isEmpty) {
                      return l10n.profileAddressRequired;
                    }
                    return null;
                  },
                ),
                SizedBox(height: 22.h),
                _ProfileFieldLabel(text: l10n.profileDobLabel),
                InkWell(
                  onTap: onPickDate,
                  child: IgnorePointer(
                    child: TextFormField(
                      decoration: inputDecorationBuilder(
                        hintText: dobLabel,
                        suffixIcon: Icon(
                          Icons.calendar_today_outlined,
                          size: 18.r,
                          color: AppColors.clr98A2B3,
                        ),
                        isValueText: state.dateOfBirth != null,
                      ),
                    ),
                  ),
                ),
                if (state.errorMessage != null) ...[
                  SizedBox(height: 12.h),
                  Text(
                    state.errorMessage!,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: AppColors.clrE01F26,
                    ),
                  ),
                ],
                SizedBox(height: 26.h),
                AppButton.primary(
                  text: isUpdateMode
                      ? l10n.profileUpdateCta
                      : l10n.profileSaveCta,
                  onPressed: state.isSaving ? null : onSave,
                  isLoading: state.isSaving,
                  backgroundColor: AppColors.clr0FAA9A,
                  foregroundColor: AppColors.clrWhite,
                  height: 52.h,
                  borderRadius: 12.r,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ProfileFieldLabel extends StatelessWidget {
  const _ProfileFieldLabel({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(
        context,
      ).textTheme.bodySmall?.copyWith(color: AppColors.clr98A2B3),
    );
  }
}
