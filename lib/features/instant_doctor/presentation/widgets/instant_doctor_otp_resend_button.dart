import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../cubit/instant_doctor_cubit.dart';
import '../cubit/instant_doctor_state.dart';

class InstantDoctorOtpResendButton extends StatelessWidget {
  const InstantDoctorOtpResendButton({
    super.key,
    required this.isVerifying,
  });

  final bool isVerifying;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocSelector<InstantDoctorCubit, InstantDoctorState, (bool, int)>(
      selector: (state) => (state.canResendOtp, state.otpSecondsRemaining),
      builder: (context, resendState) {
        final canResend = resendState.$1;

        return Align(
          child: TextButton(
            onPressed: canResend && !isVerifying
                ? () => context.read<InstantDoctorCubit>().resendOtp()
                : null,
            child: canResend
                ? Text(
                    l10n.authResendOtp,
                    style: AppTextStyles.loginResend,
                  )
                : Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(text: '${l10n.authResendOtp} '),
                        TextSpan(
                          text:
                              '${resendState.$2} ${l10n.authOtpSecondsShort}',
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                    style: AppTextStyles.loginResend,
                  ),
          ),
        );
      },
    );
  }
}
