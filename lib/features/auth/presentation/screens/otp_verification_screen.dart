import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../components/widgets/app_button.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/router/app_routes.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';
import '../widgets/auth_shell.dart';

class OtpRouteData {
  const OtpRouteData({required this.phoneNumber});

  final String phoneNumber;
}

class OtpVerificationScreen extends StatelessWidget {
  const OtpVerificationScreen({super.key, required this.phoneNumber});

  final String phoneNumber;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthCubit>(
      create: (_) => sl<AuthCubit>()..setPhoneNumber(phoneNumber),
      child: _OtpView(phoneNumber: phoneNumber),
    );
  }
}

class _OtpView extends StatefulWidget {
  const _OtpView({required this.phoneNumber});

  final String phoneNumber;

  @override
  State<_OtpView> createState() => _OtpViewState();
}

class _OtpViewState extends State<_OtpView> {
  final _otpController = TextEditingController();

  Future<void> _submit() async {
    final l10n = AppLocalizations.of(context)!;
    final otp = _otpController.text.trim();
    if (otp.length != 4) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.authOtpValidationError)));
      return;
    }

    final success = await context.read<AuthCubit>().verifyOtp(otp);
    if (!mounted || !success) return;
    context.go(AppRoutes.path(AppRoutes.profileSetup));
  }

  Future<void> _resendOtp() async {
    final l10n = AppLocalizations.of(context)!;
    final success = await context.read<AuthCubit>().requestOtp(
      widget.phoneNumber,
    );
    if (!mounted || !success) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(l10n.authOtpSentMessage)));
  }

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return AuthShell(
      child: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          final resendText = state.canResendOtp
              ? l10n.authResendOtp
              : '${l10n.authResendOtp} ${state.otpSecondsRemaining}s';

          return Padding(
            padding: EdgeInsets.fromLTRB(24.w, 22.h, 24.w, 20.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  l10n.authOtpVerificationTitle,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF061E40),
                  ),
                ),
                SizedBox(height: 18.h),
                Text(
                  '${l10n.authOtpSentTo} ${widget.phoneNumber}',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: const Color(0xFF667B99),
                  ),
                ),
                SizedBox(height: 14.h),
                TextField(
                  controller: _otpController,
                  maxLength: 4,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  textAlign: TextAlign.center,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    letterSpacing: 14.w,
                  ),
                  decoration: InputDecoration(
                    counterText: '',
                    hintText: l10n.authOtpHintCode,
                    hintStyle: theme.textTheme.bodyMedium?.copyWith(
                      letterSpacing: 4.w,
                      color: const Color(0xFF9BA6A7),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(9.r),
                      borderSide: const BorderSide(
                        color: Color(0xFF9BA6A7),
                        width: 0.3,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(9.r),
                      borderSide: const BorderSide(
                        color: Color(0xFF9BA6A7),
                        width: 0.3,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 8.h),
                Align(
                  child: TextButton(
                    onPressed: state.canResendOtp ? _resendOtp : null,
                    child: Text(
                      resendText,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: const Color(0xFF5D758F),
                      ),
                    ),
                  ),
                ),
                if (state.errorMessage != null) ...[
                  SizedBox(height: 8.h),
                  Text(
                    state.errorMessage!,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: const Color(0xFFE01F26),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
                const Spacer(),
                AppButton.primary(
                  text: l10n.authProceedCta,
                  onPressed: state.isLoading ? null : _submit,
                  isLoading: state.isLoading,
                  backgroundColor: const Color(0xFF0FAA9A),
                  foregroundColor: Colors.white,
                  height: 62.h,
                  borderRadius: 20.r,
                  fontSize: (30 / 1.65).sp,
                ),
                SizedBox(height: 20.h),
                Text(
                  l10n.authTermsAndPrivacy,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: const Color(0xFF7E7E7E),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
