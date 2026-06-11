import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../components/widgets/app_button.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';

class LoginSubmitButton extends StatelessWidget {
  const LoginSubmitButton({
    super.key,
    required this.onPressed,
  });

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return BlocSelector<AuthCubit, AuthState, (bool, bool)>(
      selector: (state) => (state.otpRequested, state.isLoading),
      builder: (context, values) {
        final (otpRequested, isLoading) = values;
        final l10n = AppLocalizations.of(context)!;
        return AppButton.primary(
          text: otpRequested ? l10n.authVerifyCta : l10n.authSendOtpCta,
          onPressed: isLoading ? null : onPressed,
          isLoading: isLoading,
          backgroundColor: AppColors.clr0FAA9A,
          foregroundColor: AppColors.clrWhite,
          height: 62.h,
          borderRadius: AppSizes.radiusXL,
          fontSize: AppSizes.textSizeL,
          fontWeight: FontWeight.w700,
        );
      },
    );
  }
}
