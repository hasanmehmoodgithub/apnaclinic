import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../components/widgets/app_button.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/preference/app_pref.dart';
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
  final List<String> _banks = const ['Jazz Cash', 'EasyPaisa', 'Bank Transfer'];
  String _selectedBank = 'Jazz Cash';

  @override
  void dispose() {
    _accountNumberController.dispose();
    super.dispose();
  }

  Future<void> _saveAccount() async {
    if (!_formKey.currentState!.validate()) return;
    final pref = sl<AppPref>();
    final firstName = (pref.getString('profile_first_name') ?? '').trim();
    final lastName = (pref.getString('profile_last_name') ?? '').trim();
    final fullName = '$firstName $lastName'.trim();

    final store = AccountLocalStore(pref);
    await store.addAccount(
      AccountMethod(
        bankName: _selectedBank,
        accountHolderName: fullName.isEmpty ? 'Account Holder' : fullName,
        accountNumber: _accountNumberController.text.trim(),
      ),
    );
    if (!mounted) return;
    context.pop(true);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
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
            color: const Color(0xFF061E40),
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
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
                    color: const Color(0xFF061E40),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 18.h),
                Text(
                  'Bank',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: const Color(0xFF061E40),
                  ),
                ),
                DropdownButtonFormField<String>(
                  value: _selectedBank,
                  decoration: _fieldDecoration(),
                  items: _banks
                      .map(
                        (bank) => DropdownMenuItem<String>(
                          value: bank,
                          child: Text(bank),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value == null) return;
                    setState(() => _selectedBank = value);
                  },
                ),
                SizedBox(height: 18.h),
                Text(
                  'Account Number',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: const Color(0xFF061E40),
                  ),
                ),
                TextFormField(
                  controller: _accountNumberController,
                  keyboardType: TextInputType.number,
                  decoration: _fieldDecoration(
                    suffixIcon: Icon(
                      Icons.arrow_circle_right_outlined,
                      color: const Color(0xFFC0C5CC),
                      size: 20.r,
                    ),
                  ),
                  validator: (value) {
                    if ((value ?? '').trim().length < 8) {
                      return 'Enter a valid account number';
                    }
                    return null;
                  },
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
      suffixIcon: suffixIcon,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.r),
        borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.r),
        borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.r),
        borderSide: const BorderSide(color: Color(0xFF45B7AC)),
      ),
    );
  }
}
