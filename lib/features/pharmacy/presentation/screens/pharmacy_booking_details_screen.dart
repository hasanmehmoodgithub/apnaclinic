import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/widgets/app_scaffold_gradient.dart';
import '../pharmacy_navigation.dart';
import '../widgets/pharmacy_booking_details_body_widget.dart';
import '../widgets/pharmacy_flow_header_widget.dart';

class PharmacyBookingDetailsScreen extends StatelessWidget {
  const PharmacyBookingDetailsScreen({
    super.key,
    this.orderNo = '1223',
    this.status = PharmacyBookingTimelineStatus.confirmed,
  });

  final String orderNo;
  final PharmacyBookingTimelineStatus status;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return AppScaffoldGradient(
      child: Column(
        children: [
          PharmacyFlowHeaderWidget(
            title: '${l10n.pharmacyBookingOrderPrefix} $orderNo',
            trailingWidth: 40,
            onBackTap: () => pharmacyPopOrGoHome(context),
          ),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.clrWhite,
                borderRadius: BorderRadius.vertical(top: Radius.circular(42.r)),
              ),
              child: PharmacyBookingDetailsBodyWidget(status: status),
            ),
          ),
        ],
      ),
    );
  }
}
