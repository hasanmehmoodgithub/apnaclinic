import 'package:apnaclinic/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/dependency_injection.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/widgets/app_scaffold_gradient.dart';
import '../../domain/use_cases/add_user_phone_use_case.dart';
import '../../domain/use_cases/get_accounts_list_use_case.dart';
import '../add_account_launch_source.dart';
import '../widgets/account_app_bar_widget.dart';
import '../widgets/add_account_form_widget.dart';

class AddAccountScreen extends StatefulWidget {
  const AddAccountScreen({
    super.key,
    this.launchSource = AddAccountLaunchSource.accountDetails,
  });

  final AddAccountLaunchSource launchSource;

  @override
  State<AddAccountScreen> createState() => _AddAccountScreenState();
}

class _AddAccountScreenState extends State<AddAccountScreen> {
  final _formKey = GlobalKey<FormState>();
  final _accountNumberController = TextEditingController();
  late List<String> _accountMethods;
  late String _selectedAccountMethod;
  bool _didInitializeMethods = false;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    // Warm profile cache so numeric user id is available for POST /users/{id}/phone.
    sl<GetAccountsListUseCase>().call();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_didInitializeMethods) return;
    final l10n = AppLocalizations.of(context)!;
    _accountMethods = <String>[l10n.accountMethodJazzCash];
    _selectedAccountMethod = _accountMethods.first;
    _didInitializeMethods = true;
  }

  @override
  void dispose() {
    _accountNumberController.dispose();
    super.dispose();
  }

  Future<void> _saveAccount() async {
    if (!_formKey.currentState!.validate() || _isSaving) return;

    setState(() => _isSaving = true);
    final phone = _accountNumberController.text.trim();
    final result = await sl<AddUserPhoneUseCase>()(
      AddUserPhoneParams(phone: phone),
    );
    if (!mounted) return;
    setState(() => _isSaving = false);

    result.fold(
      (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error)),
        );
      },
      (_) async {
        if (!mounted) return;
        if (widget.launchSource == AddAccountLaunchSource.profile) {
          context.pop(true);
          return;
        }
        await _refreshProfileAndAccounts();
        if (!mounted) return;
        context.pushReplacement(
          AppRoutes.path(AppRoutes.accountDetails),
          extra: <String, dynamic>{
            'showSuccessDialog': true,
            'addedPhone': phone,
          },
        );
      },
    );
  }

  Future<void> _refreshProfileAndAccounts() async {
    await sl<GetAccountsListUseCase>().call();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AppScaffoldGradient(
      appBar: AccountAppBarWidget(title: l10n.accountAddTitle),
      child: SafeArea(
        top: false,
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.clrWhite,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
          ),
          child: Padding(
            padding: EdgeInsets.fromLTRB(18.w, 18.h, 18.w, 24.h),
            child: AddAccountFormWidget(
            formKey: _formKey,
            accountMethods: _accountMethods,
            selectedAccountMethod: _selectedAccountMethod,
            onAccountMethodChanged: (value) {
              setState(() => _selectedAccountMethod = value);
            },
            accountNumberController: _accountNumberController,
            accountNumberValidator: _validatePakistanAccountNumber,
            onSavePressed: _saveAccount,
            isLoading: _isSaving,
          ),
        ),
      ),
      ),
    );
  }

  String? _validatePakistanAccountNumber(String? value) {
    final input = (value ?? '').trim();
    if (input.isEmpty) {
      return AppLocalizations.of(context)!.accountValidationEnterNumber;
    }
    if (!RegExp(r'^\d+$').hasMatch(input)) {
      return AppLocalizations.of(context)!.accountValidationDigitsOnly;
    }
    if (input.length != 11) {
      return AppLocalizations.of(context)!.accountValidationElevenDigits;
    }
    if (!input.startsWith('03')) {
      return AppLocalizations.of(context)!.accountValidationValidPakistanMobile;
    }
    return null;
  }
}
