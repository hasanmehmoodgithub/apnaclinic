import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../domain/entities/pharmacy_cart_messages_entity.dart';
import 'pharmacy_checkout_widgets.dart';

/// Disclaimer / prescription / delivery cards from cart API `messages`.
class PharmacyCheckoutNoticesWidget extends StatelessWidget {
  const PharmacyCheckoutNoticesWidget({
    super.key,
    this.messages,
  });

  final PharmacyCartMessagesEntity? messages;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final disclaimerTitle =
        messages?.disclaimerTitle ?? l10n.pharmacyCheckoutDisclaimerTitle;
    final disclaimerBody =
        messages?.disclaimerBody ?? l10n.pharmacyCheckoutDisclaimerMessage;
    final prescriptionNotice =
        messages?.prescriptionNotice?.trim().isNotEmpty == true
        ? messages!.prescriptionNotice!.trim()
        : l10n.pharmacyCheckoutPrescriptionNotice;
    final deliveryNotice =
        messages?.deliveryNotice?.trim().isNotEmpty == true
        ? messages!.deliveryNotice!.trim()
        : l10n.pharmacyCheckoutDeliveryInfoMessage;
    final deliveryChargesNotice =
        messages?.deliveryChargesNotice?.trim().isNotEmpty == true
        ? messages!.deliveryChargesNotice!.trim()
        : l10n.pharmacyCheckoutDeliveryInfoFooter;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        PharmacyInfoCard(
          bgColor: AppColors.clrE9F4FC,
          title: disclaimerTitle,
          message: disclaimerBody,
        ),
        SizedBox(height: 12.h),
        PharmacyInfoCard(
          bgColor: AppColors.clrF7F7F7,
          message: prescriptionNotice,
        ),
        SizedBox(height: 12.h),
        PharmacyInfoCard(
          bgColor: AppColors.clrFCF5E9,
          message: deliveryNotice,
          footer: deliveryChargesNotice,
        ),
      ],
    );
  }
}
