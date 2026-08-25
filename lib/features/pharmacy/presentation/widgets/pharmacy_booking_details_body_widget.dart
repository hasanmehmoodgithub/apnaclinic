import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../bookings/domain/entities/invoice_module_type.dart';
import '../../../bookings/presentation/invoice_download.dart';
import '../../../bookings/presentation/widgets/booking_invoice_tile_widget.dart';
import '../../domain/entities/pharmacy_booking_detail_entity.dart';
import 'pharmacy_booking_medicine_card_widget.dart';
import 'pharmacy_booking_order_status_widget.dart';
import 'pharmacy_booking_price_summary_widget.dart';
import 'pharmacy_booking_section_line_widget.dart';

/// Kept for route/list mapping compatibility.
enum PharmacyBookingTimelineStatus {
  confirmed,
  readyForDispatch,
  shipped,
  completed,
  cancelled,
}

class PharmacyBookingDetailsBodyWidget extends StatelessWidget {
  const PharmacyBookingDetailsBodyWidget({super.key, required this.detail});

  final PharmacyBookingDetailEntity detail;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return ListView(
      padding: EdgeInsets.fromLTRB(24.w, 18.h, 24.w, 24.h),
      children: [
        ...detail.items.map(
          (item) => Padding(
            padding: EdgeInsets.only(bottom: 12.h),
            child: PharmacyBookingMedicineCardWidget(item: item),
          ),
        ),
        const PharmacyBookingSectionLineWidget(top: 6, bottom: 14),
        PharmacyBookingPriceSummaryWidget(
          deliveryCharge: detail.deliveryChargeLabel,
          discount: detail.hasDiscount ? detail.discountLabel : null,
          total: detail.totalLabel,
        ),
        SizedBox(height: 22.h),
        BookingInvoiceTileWidget(
          onDownload: () => InvoiceDownload.downloadAndView(
            context,
            moduleType: InvoiceModuleType.pharmacy,
            orderId: detail.orderId,
          ),
        ),
        SizedBox(height: 18.h),
        _LabeledValueRow(
          title: l10n.pharmacyCheckoutAddressLabel,
          value: detail.city.isEmpty ? '—' : detail.city,
        ),
        SizedBox(height: 10.h),
        Text(
          detail.deliveryAddress.isEmpty ? '—' : detail.deliveryAddress,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppColors.clr6C7EA0,
            fontSize: 14.sp,
            height: 1.2,
          ),
        ),
        const PharmacyBookingSectionLineWidget(top: 16, bottom: 16),
        _LabeledValueColumn(
          title: l10n.pharmacyCheckoutPaymentMethodTitle,
          value: detail.paymentMethodLabel,
        ),
        const PharmacyBookingSectionLineWidget(top: 16, bottom: 16),
        PharmacyBookingOrderStatusWidget(
          isCancelled: detail.isCancelled,
          steps: detail.statusTimeline,
        ),
        SizedBox(height: 16.h),
        if (detail.hasMessageAlert)
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 11.h),
            decoration: BoxDecoration(
              color: AppColors.clrFCF5E9,
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    detail.messageAlert!,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.clr060,
                      fontWeight: FontWeight.w500,
                      fontSize: 14.sp,
                      height: 1.2,
                    ),
                  ),
                ),
                SizedBox(width: 8.w),
                Icon(
                  Icons.info_outline_rounded,
                  size: 16.r,
                  color: AppColors.clr4A555F,
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _LabeledValueRow extends StatelessWidget {
  const _LabeledValueRow({required this.title, required this.value});

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.clr060,
              fontSize: 14.sp,
            ),
          ),
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppColors.clr6C7EA0,
            fontSize: 14.sp,
          ),
        ),
      ],
    );
  }
}

class _LabeledValueColumn extends StatelessWidget {
  const _LabeledValueColumn({required this.title, required this.value});

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppColors.clr060,
            fontSize: 14.sp,
          ),
        ),
        SizedBox(height: 10.h),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppColors.clr6C7EA0,
            fontSize: 14.sp,
          ),
        ),
      ],
    );
  }
}
