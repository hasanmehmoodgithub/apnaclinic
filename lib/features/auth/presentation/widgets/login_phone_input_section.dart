import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';

class LoginPhoneInputSection extends StatelessWidget {
  const LoginPhoneInputSection({
    super.key,
    required this.controller,
    required this.onChanged,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(l10n.authMobileNumberLabel, style: AppTextStyles.loginTitle),
        SizedBox(height: 2.h),
        Text(l10n.authLoginSubtitle, style: AppTextStyles.loginSubtitle),
        SizedBox(height: 12.h),
        TextFormField(
          controller: controller,
          keyboardType: TextInputType.phone,
          maxLength: 10,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          style: AppTextStyles.loginField,
          decoration: InputDecoration(
            hintText: l10n.authPhoneHint.replaceFirst('+92 ', ''),
            hintStyle: AppTextStyles.loginFieldHint,
            prefixIcon: Padding(
              padding: EdgeInsets.only(left: 16.w, right: 6.w),
              child: Text('+92', style: AppTextStyles.loginPrefix),
            ),
            prefixIconConstraints: const BoxConstraints(
              minWidth: 0,
              minHeight: 0,
            ),
            counterText: '',
            filled: true,
            fillColor: AppColors.clrWhite,
            contentPadding: EdgeInsets.symmetric(
              horizontal: 12.w,
              vertical: 15.h,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: const BorderSide(
                color: AppColors.clr9BA6A7,
                width: 0.9,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: const BorderSide(
                color: AppColors.clr9BA6A7,
                width: 0.9,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: const BorderSide(
                color: AppColors.clrE01F26,
                width: 0.9,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: const BorderSide(
                color: AppColors.clrE01F26,
                width: 0.9,
              ),
            ),
            errorStyle: AppTextStyles.loginError,
          ),
          onChanged: onChanged,
          validator: (value) {
            final digits = (value ?? '').replaceAll(RegExp(r'\D'), '');
            final isValidPakMobile = RegExp(r'^3\d{9}$').hasMatch(digits);
            if (!isValidPakMobile) {
              return l10n.authPhoneValidationError;
            }
            return null;
          },
        ),
        SizedBox(height: 4.h),
        Text(l10n.authOtpHint, style: AppTextStyles.loginCaption),
        BlocSelector<AuthCubit, AuthState, (bool, String?)>(
          selector: (state) => (state.otpRequested, state.errorMessage),
          builder: (context, values) {
            final (otpRequested, errorMessage) = values;
            if (otpRequested || errorMessage == null) {
              return const SizedBox.shrink();
            }
            return Padding(
              padding: EdgeInsets.only(top: 6.h),
              child: Text(errorMessage, style: AppTextStyles.loginError),
            );
          },
        ),
      ],
    );
  }
}
