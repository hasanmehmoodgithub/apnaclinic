import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../components/widgets/app_button.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../core/enums/app_enums.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/router/app_routes.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';
import '../widgets/auth_shell.dart';
import '../widgets/login_legal_text.dart';
import '../widgets/login_otp_section.dart';
import '../widgets/login_phone_input_section.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthCubit>(
      create: (_) => sl<AuthCubit>(),
      child: const _LoginView(),
    );
  }
}

class _LoginView extends StatefulWidget {
  const _LoginView();

  @override
  State<_LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<_LoginView> {
  final _phoneController = TextEditingController();
  final _otpController = TextEditingController();
  final _otpFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();

  String get _otpCode => _otpController.text;

  @override
  void dispose() {
    _phoneController.dispose();
    _otpController.dispose();
    _otpFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        return AuthShell(
          onBackTap: () => _handleBackTap(state),
          child: Padding(
            padding: EdgeInsets.fromLTRB(30.w, 22.h, 30.w, 20.h),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  LoginPhoneInputSection(
                    controller: _phoneController,
                    onChanged: _handlePhoneChanged,
                    errorText: !state.otpRequested ? state.errorMessage : null,
                  ),
                  if (state.otpRequested) ...[
                    LoginOtpSection(
                      controller: _otpController,
                      focusNode: _otpFocusNode,
                      otpSecondsRemaining: state.otpSecondsRemaining,
                      canResendOtp: state.canResendOtp,
                      onResendTap: () => context.read<AuthCubit>().requestOtp(
                        context.read<AuthCubit>().formatPhoneInput(
                          _phoneController.text.trim(),
                        ),
                      ),
                      onOtpChanged: (_) =>
                          context.read<AuthCubit>().clearError(),
                      errorText: state.errorMessage,
                    ),
                  ],
                  const Spacer(),
                  AppButton.primary(
                    text: state.otpRequested
                        ? l10n.authVerifyCta
                        : l10n.authSendOtpCta,
                    onPressed: state.isLoading ? null : () => _submit(state),
                    isLoading: state.isLoading,
                    backgroundColor: AppColors.clr0FAA9A,
                    foregroundColor: AppColors.clrWhite,
                    height: 62.h,
                    borderRadius: 20.r,
                    fontSize: (30 / 1.65).sp,
                  ),
                  SizedBox(height: 20.h),
                  const LoginLegalText(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _clearOtpInputs() {
    _otpController.clear();
    _otpFocusNode.requestFocus();
  }

  void _handlePhoneChanged(String value) {
    final shouldClearOtp = context.read<AuthCubit>().onPhoneInputChanged(value);
    if (shouldClearOtp) _clearOtpInputs();
  }

  void _handleBackTap(AuthState state) {
    if (!mounted) return;

    if (state.otpRequested) {
      context.read<AuthCubit>().hideOtpSection();
      return;
    }

    if (context.canPop()) {
      context.pop();
      return;
    }

    context.go(AppRoutes.path(AppRoutes.onboarding));
  }

  Future<void> _submit(AuthState state) async {
    final l10n = AppLocalizations.of(context)!;
    FocusScope.of(context).unfocus();
    final cubit = context.read<AuthCubit>();
    final result = await cubit.submitLogin(
      isFormValid: _formKey.currentState!.validate(),
      rawPhoneInput: _phoneController.text,
      otpCode: _otpCode,
    );
    if (!mounted) return;

    switch (result) {
      case AuthSubmitResult.otpSent:
        _clearOtpInputs();
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.authOtpSentMessage)));
        break;
      case AuthSubmitResult.invalidOtp:
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.authOtpValidationError)));
        break;
      case AuthSubmitResult.verifiedGoHome:
        context.go(AppRoutes.path(AppRoutes.home));
        break;
      case AuthSubmitResult.verifiedGoProfileSetup:
        context.go(AppRoutes.path(AppRoutes.profileSetup));
        break;
      case AuthSubmitResult.validationFailed:
      case AuthSubmitResult.failed:
        break;
    }
  }
}
