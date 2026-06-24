import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/widgets/app_scaffold_gradient.dart';
import '../widgets/pharmacy_cart_body_widget.dart';
import '../widgets/pharmacy_flow_header_widget.dart';

class PharmacyCartScreen extends StatelessWidget {
  const PharmacyCartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return AppScaffoldGradient(
      child: Column(
        children: [
          PharmacyFlowHeaderWidget(
            title: l10n.pharmacyCartTitle,
            trailingWidth: 44,
            onBackTap: () {
              if (context.canPop()) context.pop();
            },
          ),
          AppScaffoldGradientPanel(
            child: const PharmacyCartBodyWidget(),
          ),
        ],
      ),
    );
  }
}
