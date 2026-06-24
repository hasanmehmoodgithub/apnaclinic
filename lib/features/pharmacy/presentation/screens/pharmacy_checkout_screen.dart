import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/widgets/app_scaffold_gradient.dart';
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
  final List<String> _cities = const [
    'Islamabad',
    'Lahore',
    'Karachi',
    'Rawalpindi',
    'Peshawar',
  ];

  @override
  void initState() {
    super.initState();
    _addressController = TextEditingController();
    _specialInstructionsController = TextEditingController();
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
              cities: _cities,
            ),
          ),
        ],
      ),
    );
  }
}
