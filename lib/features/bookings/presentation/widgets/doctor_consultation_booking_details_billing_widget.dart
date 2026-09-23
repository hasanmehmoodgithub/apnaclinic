import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../data/models/doctor_consultation_booking_details_model.dart';
import 'booking_invoice_tile_widget.dart';

class DoctorConsultationBookingDetailsBillingWidget extends StatelessWidget {
  const DoctorConsultationBookingDetailsBillingWidget({
    super.key,
    required this.data,
    this.onInvoiceDownload,
  });

  final DoctorConsultationBookingDetailsModel data;
  final VoidCallback? onInvoiceDownload;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.bookingsBillingTitle,
          style: textTheme.titleMedium?.copyWith(
            color: AppColors.clr061E40,
            fontWeight: FontWeight.w600,
          ),
        ),
        if (onInvoiceDownload != null) ...[
          SizedBox(height: 8.h),
          BookingInvoiceTileWidget(onDownload: onInvoiceDownload!),
        ],
        SizedBox(height: 8.h),
        Container(
          decoration: BoxDecoration(
            color: AppColors.clrWhite,
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(color: AppColors.clrE5E8EC),
          ),
          child: Column(
            children: [
              Container(
                color: AppColors.clrF7F7F7,
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                child: _BillRow(
                  label: l10n.bookingsTotalLabel,
                  value: data.totalText,
                  isTotal: true,
                  dense: true,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _BillRow extends StatelessWidget {
  const _BillRow({
    required this.label,
    required this.value,
    this.isTotal = false,
    this.dense = false,
  });

  final String label;
  final String value;
  final bool isTotal;
  final bool dense;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: dense
          ? EdgeInsets.zero
          : EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
      child: Row(
        children: [
          Text(
            label,
            style: textTheme.bodyMedium?.copyWith(
              color: isTotal ? AppColors.clr061E40 : AppColors.clr707D8F,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: textTheme.bodyMedium?.copyWith(
              color: AppColors.clr061E40,
              fontWeight: isTotal ? FontWeight.w700 : FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
