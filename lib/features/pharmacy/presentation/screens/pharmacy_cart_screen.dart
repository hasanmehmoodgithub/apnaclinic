import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/widgets/app_scaffold_gradient.dart';
import '../cubit/pharmacy_cubit.dart';
import '../widgets/pharmacy_cart_body_widget.dart';
import '../widgets/pharmacy_flow_header_widget.dart';

class PharmacyCartScreen extends StatefulWidget {
  const PharmacyCartScreen({super.key});

  @override
  State<PharmacyCartScreen> createState() => _PharmacyCartScreenState();
}

class _PharmacyCartScreenState extends State<PharmacyCartScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<PharmacyCubit>().logCartViewed();
    });
  }

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
