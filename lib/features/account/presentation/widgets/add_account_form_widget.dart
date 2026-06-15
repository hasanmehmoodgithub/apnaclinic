import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../components/widgets/app_button.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';

class AddAccountFormWidget extends StatelessWidget {
  const AddAccountFormWidget({
    super.key,
    required this.formKey,
    required this.accountMethods,
    required this.selectedAccountMethod,
    required this.onAccountMethodChanged,
    required this.accountNumberController,
    required this.accountNumberValidator,
    required this.onSavePressed,
    this.isLoading = false,
  });

  final GlobalKey<FormState> formKey;
  final List<String> accountMethods;
  final String selectedAccountMethod;
  final ValueChanged<String> onAccountMethodChanged;
  final TextEditingController accountNumberController;
  final FormFieldValidator<String> accountNumberValidator;
  final VoidCallback onSavePressed;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            l10n.accountEnterDetailsTitle,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: AppColors.clr060,
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 18.h),
          Text(
            l10n.accountMethodLabel,
            style: theme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w500,
              color: AppColors.clr060,
              fontSize: 16.sp,
            ),
          ),
          SizedBox(height: 4.h),
          DropdownButtonFormField<String>(
            initialValue: selectedAccountMethod,
            decoration: _fieldDecoration(),
            items: accountMethods
                .map(
                  (method) => DropdownMenuItem<String>(
                    value: method,
                    child: Text(method),
                  ),
                )
                .toList(),
            onChanged: (value) {
              if (value == null) return;
              onAccountMethodChanged(value);
            },
          ),
          SizedBox(height: 18.h),
          Text(
            l10n.accountNumberLabel,
            style: theme.textTheme.bodySmall?.copyWith(
              color: AppColors.clr060,
              fontWeight: FontWeight.w500,
              fontSize: 16.sp,
            ),
          ),
          SizedBox(height: 4.h),
          TextFormField(
            controller: accountNumberController,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(11),
            ],
            decoration: _fieldDecoration(),
            validator: accountNumberValidator,
          ),
          const Spacer(),
          AppButton.primary(
            text: l10n.accountSaveCta,
            onPressed: isLoading ? null : onSavePressed,
            isLoading: isLoading,
            backgroundColor: AppColors.clr40AFA2,
            foregroundColor: AppColors.clrWhite,
            height: 56.h,
            borderRadius: 10.r,
          ),
        ],
      ),
    );
  }

  InputDecoration _fieldDecoration({Widget? suffixIcon}) {
    return InputDecoration(
      filled: true,
      fillColor: AppColors.clrF7F7F7,
      contentPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
      counterText: '',
      suffixIcon: suffixIcon,
      border: const OutlineInputBorder(),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.r),
        borderSide: const BorderSide(color: Colors.transparent),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.r),
        borderSide: const BorderSide(color: Colors.transparent),
      ),
    );
  }
}
