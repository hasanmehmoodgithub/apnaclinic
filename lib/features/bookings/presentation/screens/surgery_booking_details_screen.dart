import 'package:apnaclinic/core/constants/app_colors.dart';
import 'package:apnaclinic/features/bookings/presentation/widgets/payment_method_sheet.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/widgets/app_scaffold_gradient.dart';
import '../../data/models/surgery_details_item.dart';
import '../widgets/surgery_bokking_representative_note_widget.dart';
import '../widgets/surgery_booking_appointment_details_widget.dart';
import '../widgets/surgery_booking_card_widget.dart';
import '../widgets/surgery_booking_einvoice_widget.dart';
import '../widgets/surgery_booking_patient_details_card_widget.dart';
import '../widgets/surgery_booking_payment_details_card_widget.dart';
import '../widgets/surgery_booking_requirements_card_widget.dart';
import '../widgets/alert_dialog_card.dart';

class SurgeryDetailsScreen extends StatefulWidget {
  final SurgeryDetailsItem item;
  final SurgeryBookingStatus initialStatus;

  const SurgeryDetailsScreen({
    super.key,
    required this.item,
    this.initialStatus = SurgeryBookingStatus.inReview,
  });

  @override
  State<SurgeryDetailsScreen> createState() => _SurgeryDetailsScreenState();
}

class _SurgeryDetailsScreenState extends State<SurgeryDetailsScreen> {
  late SurgeryBookingStatus _status;

  @override
  void initState() {
    super.initState();
    _status = widget.initialStatus;
  }

  // ─── Status pill helpers ───
  String get _statusLabel {
    switch (_status) {
      case SurgeryBookingStatus.inReview:
        return 'In Review';
      case SurgeryBookingStatus.paymentPending:
        return 'Payment Pending';
      case SurgeryBookingStatus.confirmed:
        return 'Confirmed';
    }
  }

  // ─── Bottom sheet: Payment Method ───
  Future<void> _openPaymentMethodSheet() async {
    final selected = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => const PaymentMethodSheet(),
    );

    if (!mounted || selected == null) return;

    // Simulate payment outcome — in real app this comes from gateway
    // For demo: 'jazz_cash' → success, 'card' → failure (so both flows are demoed)
    final isSuccess = selected == 'jazz_cash';

    if (isSuccess) {
      await _showBookingConfirmedDialog();
      if (!mounted) return;
      setState(() => _status = SurgeryBookingStatus.confirmed);
    } else {
      await _showPaymentFailedDialog();
    }
  }

  Future<void> _showPaymentFailedDialog() async {
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => const AlertDialogCard(
        kind: AlertKind.error,
        title: 'Alert',
        message: 'Your payment attempt was unsuccessful. Please try again.',
      ),
    );
  }

  Future<void> _showBookingConfirmedDialog() async {
    final i = widget.item;
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialogCard(
        kind: AlertKind.success,
        title: 'Booking Confirmed',
        message:
        'Your surgery booking with Dr. ${i.doctor.replaceFirst('Dr. ', '').split(' ').first} '
            'for Photorefractive keratectomy (${i.procedure} ) Surgery is '
            'confirmed at ${i.appointmentDateFull} in ${i.hospital}.',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final showCheckout = _status == SurgeryBookingStatus.paymentPending;

    return AppScaffoldGradient(

      child: Column(
        children: [
          // ─── Header (same pattern as BookingsDashboardScreen) ───
          Row(
            children: [
              IconButton(
                onPressed: () {
                  if (context.canPop()) {
                    context.pop();
                  }
                },
                icon: const Icon(
                  Icons.arrow_back_rounded,
                  color: Color(0xFF061E40),
                ),
              ),
              Expanded(
                child: Text(
                  l10n.bookingsDashboardTitle, // or a dedicated key like l10n.surgeryDetailsTitle
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: const Color(0xFF061E40),
                    fontWeight: FontWeight.w700,
                    fontSize: 20.sp,
                  ),
                ),
              ),
              SizedBox(width: 44.w),
            ],
          ),
          // ─── Body content ───
          Expanded(
            child: Container(
              color: AppColors.clrWhite,
              child: ListView(
                padding: EdgeInsets.fromLTRB(
                  16.w, 8.h, 16.w, showCheckout ? 110.h : 24.h,
                ),
                children: [
                  SurgeryBookingCardWidget(
                    item: widget.item,
                    statusLabel: _statusLabel,
                  ),
                  SizedBox(height: 14.h),
                  const SurgeryBookingRequirementsCardWidget(),
                  if (_status == SurgeryBookingStatus.paymentPending ||
                      _status == SurgeryBookingStatus.confirmed) ...[
                    SizedBox(height: 14.h),
                    SurgeryBookingAppointmentDetailsCardWidget(item: widget.item),
                    SizedBox(height: 10.h),
                    const SurgeryBookingRepresentativeNoteWidget(),
                  ],
                  SizedBox(height: 14.h),
                  SurgeryBookingPatientDetailsCardWidget(item: widget.item),
                  SizedBox(height: 14.h),
                  SurgeryBookingPaymentDetailsCardWidget(item: widget.item),
                  if (_status == SurgeryBookingStatus.inReview) ...[
                    SizedBox(height: 14.h),
                    const SurgeryBookingEInvoiceCardWidget(),
                  ],
                ],
              ),
            ),
          ),
          // ─── Bottom CTA: Proceed Checkout (only when paymentPending) ───
          if (showCheckout)
            SafeArea(
              top: false,
              child: Padding(
                padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 12.h),
                child: SizedBox(
                  height: 56.h,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _openPaymentMethodSheet,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1AB6A1),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14.r),
                      ),
                    ),
                    child: Text(
                      l10n.bookingsProceedCheckoutCta,
                      style: textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

}




