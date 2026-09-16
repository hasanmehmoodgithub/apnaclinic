import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/analytics/analytics_event_keys.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/session/auth_session_refresh.dart';
import '../../../../core/widgets/heart_loader_widget.dart';
import '../../../bookings/presentation/constants/bookings_tabs.dart';
import '../../../dashboard/presentation/constants/main_navigation_tabs.dart';
import '../../../payment/presentation/payment_navigation.dart';
import '../../../payment/presentation/widgets/payment_pending_dialog_widget.dart';
import '../consultation_analytics.dart';
import '../cubit/doctor_consultation_checkout_cubit.dart';
import '../cubit/doctor_consultation_checkout_state.dart';
import '../doctor_consultation_summary_args.dart';
import '../widgets/consultation_booking_confirmation_dialog_widget.dart';
import '../widgets/consultation_screen_header_widget.dart';
import '../widgets/doctor_consultation_summary_billing_section_widget.dart';
import '../widgets/doctor_consultation_summary_doctor_card_widget.dart';
import '../widgets/doctor_consultation_summary_partner_card_widget.dart';
import '../widgets/doctor_consultation_summary_payment_card_widget.dart';

class DoctorConsultationSummaryScreen extends StatelessWidget {
  const DoctorConsultationSummaryScreen({
    super.key,
    required this.args,
  });

  final DoctorConsultationSummaryArgs args;

  Future<void> _submitBooking(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    final cubit = context.read<DoctorConsultationCheckoutCubit>();
    final initiation = await cubit.submitBooking(
      args: args.checkoutArgs,
      paymentMethodCode: args.paymentMethodCode,
      msisdn: args.msisdn,
      promoCode: args.promoCode,
    );
    if (!context.mounted) return;

    if (initiation == null) {
      final message = cubit.state.errorMessage;
      final displayMessage = switch (message) {
        'invalid_booking_context' => l10n.consultationBookingInvalidContextError,
        'missing_msisdn' => l10n.consultationBookingMissingMsisdnError,
        _ => (message != null && message.isNotEmpty)
            ? message
            : l10n.consultationBookingFailed,
      };
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(displayMessage)));
      return;
    }

    if (initiation.hasBlockingOrder) {
      final blocking = initiation.blockingOrder;
      final apiMessage = blocking?.message?.trim() ?? '';
      final abandonOrderId = initiation.abandonPublicId ?? '';
      final canAbandon =
          blocking?.canAbandon == true && abandonOrderId.isNotEmpty;
      await showPaymentPendingDialog(
        context,
        title: l10n.consultationBookingPaymentPendingTitle,
        message: apiMessage.isNotEmpty
            ? apiMessage
            : l10n.consultationBookingPaymentPendingMessage,
        onViewBookings: (dialogContext) =>
            _goToDoctorBookings(context, dialogContext),
        secondaryLabel:
            canAbandon ? l10n.consultationAbandonUnpaidOrderCta : null,
        onSecondary: canAbandon
            ? (dialogContext) => _abandonUnpaidBooking(
                  context,
                  dialogContext: dialogContext,
                  publicId: abandonOrderId,
                )
            : null,
      );
      return;
    }

    final paymentResult =
        await settleCardPaymentIfNeeded(
          context,
          initiation,
          allowClose: true,
        );
    if (!context.mounted) return;
    if (!paymentResult.isSuccess) {
      ConsultationAnalytics.logConsultationBooked(
        doctor: args.checkoutArgs.doctor,
        slot: args.checkoutArgs.selectedSlot,
        paymentMethodCode: args.paymentMethodCode,
        paymentMethodName: args.paymentMethodName,
        msisdn: args.msisdn,
        paymentStatus: AnalyticsConsultationPaymentStatusKeys.failed,
        discount: args.discount,
        promoCode: args.promoCode,
        initiation: initiation,
      );
      await showCardPaymentOutcomeDialog(
        context,
        paymentResult,
        onViewBookings: (dialogContext) =>
            _goToDoctorBookings(context, dialogContext),
      );
      return;
    }

    ConsultationAnalytics.logConsultationBooked(
      doctor: args.checkoutArgs.doctor,
      slot: args.checkoutArgs.selectedSlot,
      paymentMethodCode: args.paymentMethodCode,
      paymentMethodName: args.paymentMethodName,
      msisdn: args.msisdn,
      paymentStatus: AnalyticsConsultationPaymentStatusKeys.successful,
      discount: args.discount,
      promoCode: args.promoCode,
      initiation: initiation,
    );

    await _showBookedDialog(context);
  }

  void _goToDoctorBookings(BuildContext hostContext, BuildContext dialogContext) {
    if (dialogContext.canPop()) dialogContext.pop();
    if (!hostContext.mounted) return;
    sl<AuthSessionRefresh>().requestTabIndex(
      MainNavigationTabs.bookings,
      bookingsSubTabIndex: BookingsTabs.doctorConsultation,
    );
    hostContext.go(AppRoutes.path(AppRoutes.home));
  }

  Future<void> _abandonUnpaidBooking(
    BuildContext hostContext, {
    required BuildContext dialogContext,
    required String publicId,
  }) async {
    if (dialogContext.canPop()) dialogContext.pop();
    if (!hostContext.mounted) return;

    const loaderId = 'consultation_abandon_order_loader';
    final cubit = hostContext.read<DoctorConsultationCheckoutCubit>();
    final l10n = AppLocalizations.of(hostContext)!;
    showHeartLoaderDialog(hostContext, id: loaderId, size: 120);
    final result = await cubit.abandonBooking(publicId: publicId);
    HeartLoaderDialogController.close(loaderId);
    if (!hostContext.mounted) return;

    await result.fold(
      (error) async {
        final message = error.trim().isNotEmpty
            ? error.trim()
            : l10n.consultationAbandonUnpaidOrderFailed;
        ScaffoldMessenger.of(hostContext)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(message)));
      },
      (_) async {},
    );
  }

  Future<void> _showBookedDialog(BuildContext context) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      useRootNavigator: true,
      builder: (dialogContext) {
        return ConsultationBookingConfirmationDialogWidget(
          doctorName: args.checkoutArgs.doctorName,
          onViewBookings: () => _goToDoctorBookings(context, dialogContext),
        );
      },
    );
  }

  String _formatDateLabel(String rawDate) {
    final parsed = DateTime.tryParse(rawDate);
    if (parsed == null) return rawDate;
    return '${parsed.month}/${parsed.day}/${parsed.year.toString().substring(2)}';
  }

  String _formatTimeLabel() {
    final slot = args.checkoutArgs.selectedSlot;
    if (slot.label.trim().isNotEmpty) {
      final firstPart = slot.label.split('-').first.trim();
      return firstPart;
    }

    final startTime = slot.startTime.trim();
    if (startTime.toUpperCase().contains('AM') ||
        startTime.toUpperCase().contains('PM')) {
      return startTime;
    }

    final parts = startTime.split(':');
    if (parts.length < 2) return startTime;
    final hour = int.tryParse(parts[0]) ?? 0;
    final minute = parts[1].padLeft(2, '0');
    final period = hour >= 12 ? 'PM' : 'AM';
    final hour12 = hour % 12 == 0 ? 12 : hour % 12;
    return '$hour12:$minute $period';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final doctor = args.checkoutArgs.doctor;
    final dateLabel =
        '${l10n.bookingsDateLabel}: ${_formatDateLabel(args.checkoutArgs.selectedSlot.date)}';
    final timeLabel = '${l10n.consultationTimeLabel}: ${_formatTimeLabel()}';

    final topInset = MediaQuery.paddingOf(context).top;

    return Scaffold(
      backgroundColor: const Color(0xFFB8EBE8),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            height: kToolbarHeight + topInset,
            padding: EdgeInsets.only(top: topInset),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFFAEE3E3), Color(0xFFB8EBE8)],
              ),
            ),
            child: ConsultationScreenHeaderWidget(
              title: l10n.consultationSummaryTitle,
              onBackTap: () => context.pop(),
              compact: true,
            ),
          ),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
              ),
              child: ClipRRect(
                borderRadius:
                    BorderRadius.vertical(top: Radius.circular(24.r)),
                child: SafeArea(
                  top: false,
                  bottom: false,
                  child: Column(
                    children: [
                    Expanded(
                      child: SingleChildScrollView(
                        padding: EdgeInsets.fromLTRB(16.w, 18.h, 16.w, 8.h),
                        child: Column(
                          children: [
                            DoctorConsultationSummaryDoctorCardWidget(
                              doctorName: doctor.name,
                              specialty: doctor.specialty,
                              experience: doctor.experience,
                              qualification: doctor.qualification,
                              dateLabel: dateLabel,
                              timeLabel: timeLabel,
                              partnerLogoUrl: doctor.partnerLogoUrl,
                              partnerTenantId: doctor.tenantId,
                            ),
                            SizedBox(height: 10.h),
                            DoctorConsultationSummaryPartnerCardWidget(
                              partnerName: doctor.partner,
                              partnerLogoUrl: doctor.partnerLogoUrl,
                              partnerTenantId: doctor.tenantId,
                            ),
                            SizedBox(height: 10.h),
                            DoctorConsultationSummaryPaymentCardWidget(
                              paymentMethodCode: args.paymentMethodCode,
                              paymentMethodName: args.paymentMethodName,
                              paymentMethodIconUrl: args.paymentMethodIconUrl,
                              accountNumber: args.accountNumber,
                            ),
                            SizedBox(height: 10.h),
                            DoctorConsultationSummaryBillingSectionWidget(
                              consultationFee: args.consultationFee,
                              discount: args.discount,
                              total: args.total,
                              promoCode: args.promoCode,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 14.h),
                      child: BlocBuilder<DoctorConsultationCheckoutCubit,
                          DoctorConsultationCheckoutState>(
                        builder: (context, state) {
                          return Column(
                            children: [
                              SizedBox(
                                width: double.infinity,
                                height: 54.h,
                                child: FilledButton(
                                  onPressed: state.isSubmitting
                                      ? null
                                      : () => _submitBooking(context),
                                  style: FilledButton.styleFrom(
                                    backgroundColor: const Color(0xFF1FAFA3),
                                    foregroundColor: Colors.white,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(14.r),
                                    ),
                                  ),
                                  child: state.isSubmitting
                                      ? SizedBox(
                                          width: 22.r,
                                          height: 22.r,
                                          child: const CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: Colors.white,
                                          ),
                                        )
                                      : Text(
                                          l10n.commonProceed,
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium
                                              ?.copyWith(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 16.sp,
                                              ),
                                        ),
                                ),
                              ),
                              SizedBox(height: 10.h),
                              SizedBox(
                                width: double.infinity,
                                height: 54.h,
                                child: OutlinedButton(
                                  onPressed: state.isSubmitting
                                      ? null
                                      : () => context.pop(),
                                  style: OutlinedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    side: const BorderSide(
                                      color: Color(0xFFD1D6DD),
                                      width: 0.8,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(14.r),
                                    ),
                                  ),
                                  child: Text(
                                    l10n.profileCancelCta,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(
                                          color: const Color(0xFF667B99),
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16.sp,
                                        ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
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
