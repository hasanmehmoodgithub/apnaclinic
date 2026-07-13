import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/dependency_injection.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/preference/app_pref.dart';
import '../../../../core/widgets/app_scaffold_gradient.dart';
import '../cubit/pharmacy_cubit.dart';
import '../widgets/pharmacy_checkout_body_widget.dart';
import '../widgets/pharmacy_flow_header_widget.dart';

class PharmacyCheckoutScreen extends StatefulWidget {
  const PharmacyCheckoutScreen({super.key});

  @override
  State<PharmacyCheckoutScreen> createState() => _PharmacyCheckoutScreenState();
}

class _PharmacyCheckoutScreenState extends State<PharmacyCheckoutScreen> {
  late final TextEditingController _addressController;
  late final TextEditingController _specialInstructionsController;
  final AppPref _appPref = sl<AppPref>();

  @override
  void initState() {
    super.initState();
    _addressController = TextEditingController();
    _specialInstructionsController = TextEditingController();
    _prefillAddressFromSavedProfile();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final cubit = context.read<PharmacyCubit>();
      cubit.loadCart();
      cubit.loadCheckoutCities();
    });
  }

  void _prefillAddressFromSavedProfile() {
    final user = _appPref.getUserLocalModel();
    final address = user?.address.trim() ?? '';
    if (address.isNotEmpty) {
      _addressController.text = address;
    }
  }

  @override
  void dispose() {
    _addressController.dispose();
    _specialInstructionsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return AppScaffoldGradient(
      child: Column(
        children: [
          PharmacyFlowHeaderWidget(
            title: l10n.pharmacyCheckoutTitle,
            trailingWidth: 40,
            onBackTap: () {
              if (context.canPop()) context.pop();
            },
          ),
          AppScaffoldGradientPanel(
            child: PharmacyCheckoutBodyWidget(
              addressController: _addressController,
              specialInstructionsController: _specialInstructionsController,
            ),
          ),
        ],
      ),
    );
  }
}
