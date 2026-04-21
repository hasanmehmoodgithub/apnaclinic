import 'package:apnaclinic/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../../../components/widgets/app_button.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/preference/app_pref.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/widgets/app_scaffold_gradient.dart';
import '../../data/account_local_store.dart';
import '../../domain/models/account_method.dart';

class AddAccountScreen extends StatefulWidget {
  const AddAccountScreen({super.key});

  @override
  State<AddAccountScreen> createState() => _AddAccountScreenState();
}

class _AddAccountScreenState extends State<AddAccountScreen> {
  final _formKey = GlobalKey<FormState>();
  final _accountNumberController = TextEditingController();
  final List<String> _accountMethods = const ['JazzCash'];
  static const String _accountMethodName = 'JazzCash';
  String _selectedAccountMethod = _accountMethodName;

  @override
  void dispose() {
    _accountNumberController.dispose();
    super.dispose();
  }

  Future<void> _saveAccount() async {
    if (!_formKey.currentState!.validate()) return;
    final pref = sl<AppPref>();
    final userLocal = pref.getUserLocalModel();
    final firstName = userLocal?.firstName.trim() ?? '';
    final lastName = userLocal?.lastName.trim() ?? '';
    final fullName = '$firstName $lastName'.trim();

    final store = AccountLocalStore(pref);
    final newIndex = await store.addAccount(
      AccountMethod(
        bankName: _selectedAccountMethod,
        accountHolderName: fullName.isEmpty ? 'Account Holder' : fullName,
        accountNumber: _accountNumberController.text.trim(),
      ),
    );
    if (!mounted) return;
    context.pushReplacement(
      AppRoutes.path(AppRoutes.accountDetails),
      extra: <String, dynamic>{
        'accountIndex': newIndex,
        'showSuccessDialog': true,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppScaffoldGradient(
      appBar: AppBar(
        backgroundColor: const Color(0xFFC7EFEB),
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back_rounded, color: Color(0xFF061E40)),
        ),
        title: Text(
          'Add Account',
          style: theme.textTheme.titleMedium?.copyWith(
            color: AppColors.clr060,
            fontSize:20.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
        ),
        child: Padding(
          padding: EdgeInsets.fromLTRB(18.w, 18.h, 18.w, 24.h),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Enter Account Details',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppColors.clr060,fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 18.h),
                Text(
                  'Account Method',
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w500,
                      color: AppColors.clr060,
                      fontSize: 16.sp

                  ),
                ),
                SizedBox(height: 4.h),
                DropdownButtonFormField<String>(
                  value: _selectedAccountMethod,
                  decoration: _fieldDecoration(),
                  items: _accountMethods
                      .map(
                        (method) => DropdownMenuItem<String>(
                          value: method,
                          child: Text(method),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value == null) return;
                    setState(() => _selectedAccountMethod = value);
                  },
                ),
                SizedBox(height: 18.h),
                Text(
                  'Account Number',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.clr060,
                    fontWeight: FontWeight.w500,
                    fontSize: 16.sp
                  ),
                ),
                SizedBox(height: 4.h),
                TextFormField(
                  controller: _accountNumberController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(11),
                  ],
                  decoration: _fieldDecoration(
                  ),
                  validator: _validatePakistanAccountNumber,
                ),
                const Spacer(),
                AppButton.primary(
                  text: 'Save',
                  onPressed: _saveAccount,
                  backgroundColor: const Color(0xFF45B7AC),
                  foregroundColor: Colors.white,
                  height: 56.h,
                  borderRadius: 10.r,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _fieldDecoration({Widget? suffixIcon}) {
    return InputDecoration(
      filled: true,
      fillColor: const Color(0xFFF8F8F8),
      contentPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
      counterText: '',
      suffixIcon: suffixIcon,
      border: OutlineInputBorder(

      ),
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

  String? _validatePakistanAccountNumber(String? value) {
    final input = (value ?? '').trim();
    if (input.isEmpty) {
      return 'Enter account number';
    }
    if (!RegExp(r'^\d+$').hasMatch(input)) {
      return 'Only digits are allowed';
    }
    if (input.length != 11) {
      return 'Enter 11 digit Pakistan number';
    }
    if (!input.startsWith('03')) {
      return 'Enter valid Pakistan mobile number';
    }
    return null;
  }
}
