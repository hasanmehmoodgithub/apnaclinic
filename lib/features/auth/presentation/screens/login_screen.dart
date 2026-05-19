import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../core/enums/app_enums.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/router/app_routes.dart';
import '../cubit/auth_cubit.dart';
import '../widgets/auth_top_header_widget.dart';
import '../widgets/login_legal_text.dart';
import '../widgets/login_otp_section.dart';
import '../widgets/login_phone_input_section.dart';
import '../widgets/login_submit_button.dart';

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
    return Scaffold(
      backgroundColor: AppColors.clrF4F6F8,
      body: Column(
        children: [
          AuthTopHeaderWidget(onBackTap: _handleBackTap),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.clrWhite,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(30.r),
                ),
              ),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final horizontalPadding = 30.w;
                  final topPadding = 22.h;
                  final bottomPadding = 20.h;
                  return SingleChildScrollView(
                    padding: EdgeInsets.fromLTRB(
                      horizontalPadding,
                      topPadding,
                      horizontalPadding,
                      bottomPadding,
                    ),
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight -
                            topPadding -
                            bottomPadding,
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            LoginPhoneInputSection(
                              controller: _phoneController,
                              onChanged: _handlePhoneChanged,
                            ),
                            LoginOtpSection(
                              controller: _otpController,
                              focusNode: _otpFocusNode,
                              onResendTap: _handleResendOtp,
                            ),
                            const Spacer(),
                            LoginSubmitButton(onPressed: _submit),
                            SizedBox(height: 20.h),
                            const LoginLegalText(),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
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

  Future<void> _handleResendOtp() async {
    final cubit = context.read<AuthCubit>();
    final success = await cubit.requestOtp(
      cubit.formatPhoneInput(_phoneController.text.trim()),
    );
    if (!mounted || !success) return;
    _clearOtpInputs();
  }

  void _handleBackTap() {
    if (!mounted) return;

    if (context.read<AuthCubit>().state.otpRequested) {
      context.read<AuthCubit>().hideOtpSection();
      return;
    }

    if (context.canPop()) {
      context.pop();
      return;
    }

    context.go(AppRoutes.path(AppRoutes.onboarding));
  }

  Future<void> _submit() async {
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
