import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/router/app_routes.dart';
import '../cubit/pharmacy_cubit.dart';
import '../cubit/pharmacy_state.dart';
import '../pharmacy_navigation.dart';
import '../widgets/pharmacy_main_medicines_body_widget.dart';
import '../widgets/pharmacy_main_top_header_widget.dart';

/// Pharmacy hub: banner header, then medicines list / search in the white panel.
class PharmacyMainScreen extends StatelessWidget {
  const PharmacyMainScreen({super.key});

  static const double _topBannerFraction = 0.32;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final bannerHeight = MediaQuery.sizeOf(context).height * _topBannerFraction;
    return Scaffold(
      body: ColoredBox(
        color: AppColors.clrF4F6F8,
        child: Column(
          children: [
            SizedBox(
              height: bannerHeight,
              child: BlocSelector<PharmacyCubit, PharmacyState, int>(
                selector: (state) => state.cartCount,
                builder: (context, cartCount) {
                  return PharmacyMainTopHeaderWidget(
                    title: l10n.pharmacyScreenTitle,
                    cartCount: cartCount,
                    onBackTap: () => pharmacyPopOrGoHome(context),
                    onCartTap: () => context.pushNamed(AppRoutes.pharmacyCart),
                  );
                },
              ),
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.clrWhite,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(42.r),
                  ),
                ),
                child: const PharmacyMainMedicinesBodyWidget(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
