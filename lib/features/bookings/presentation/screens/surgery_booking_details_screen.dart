import 'package:apnaclinic/features/bookings/presentation/widgets/payment_method_sheet.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/dependency_injection.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/preference/app_pref.dart';
import '../../../../core/utils/phone_format_utils.dart';
import '../../../../core/widgets/app_scaffold_gradient.dart';
import '../../../consultation/data/utils/consultation_booking_utils.dart';
import '../../../consultation/presentation/models/doctor_consultation_jazzcash_sheet_result.dart';
import '../../../consultation/presentation/widgets/doctor_consultation_jazzcash_accounts_sheet_widget.dart';
import '../../../surgery/domain/use_cases/book_surgery_use_case.dart';
import '../../data/models/surgery_details_item.dart';
import '../widgets/alert_dialog_card.dart';
import '../widgets/surgery_bokking_representative_note_widget.dart';
import '../widgets/surgery_booking_appointment_details_widget.dart';
import '../widgets/surgery_booking_card_widget.dart';
import '../widgets/surgery_booking_patient_details_card_widget.dart';
import '../widgets/surgery_booking_payment_details_card_widget.dart';

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
  late bool _paymentAllowed;
  bool _isBooking = false;

  @override
  void initState() {
    super.initState();
    _status = widget.initialStatus;
    _paymentAllowed = widget.item.paymentAllowed;
  }

  String get _statusLabel {
    switch (_status) {
      case SurgeryBookingStatus.inReview:
        return 'Pending';
      case SurgeryBookingStatus.paymentPending:
        return 'Pending';
      case SurgeryBookingStatus.confirmed:
        return 'Paid';
    }
  }

  bool get _showCheckoutBar => _status != SurgeryBookingStatus.confirmed;

  bool get _canProceedCheckout =>
      _paymentAllowed && !_isBooking && _status != SurgeryBookingStatus.confirmed;

  Future<void> _openPaymentMethodSheet() async {
    if (!_canProceedCheckout) return;

    final selected = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => const PaymentMethodSheet(),
    );

    if (!mounted || selected == null) return;

    final paymentMethod = _paymentMethodApiValue(selected);
    final String? msisdn;

    if (ConsultationBookingUtils.isJazzCashPayment(paymentMethod)) {
      msisdn = await _resolveJazzCashMsisdn();
    } else {
      msisdn = _resolveFallbackMsisdn();
    }

    if (!mounted || msisdn == null || msisdn.isEmpty) return;

    await _bookSurgery(
      paymentMethod: paymentMethod,
      msisdn: PhoneFormatUtils.toLocalDisplay(msisdn),
    );
  }

  Future<String?> _resolveJazzCashMsisdn() async {
    final result =
        await showModalBottomSheet<DoctorConsultationJazzCashSheetResult>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const DoctorConsultationJazzCashAccountsSheetWidget(),
    );
    return result?.msisdn.trim();
  }

  String _resolveFallbackMsisdn() {
    final fromPatient = widget.item.contactNumber.trim();
    if (fromPatient.isNotEmpty) return fromPatient;
    return sl<AppPref>().getUserLocalModel()?.phone.trim() ?? '';
  }

  String _paymentMethodApiValue(String sheetValue) {
    if (ConsultationBookingUtils.isJazzCashPayment(sheetValue)) {
      return 'JAZZCASH';
    }
    return sheetValue.trim().toUpperCase().replaceAll(RegExp(r'[\s_-]'), '_');
  }

  Future<void> _bookSurgery({
    required String paymentMethod,
    required String msisdn,
  }) async {
    final leadId = int.tryParse(widget.item.leadId.trim());
    if (leadId == null || leadId <= 0) {
      await _showPaymentFailedDialog(
        message: 'Missing surgery lead id. Please refresh bookings and retry.',
      );
      return;
    }

    setState(() => _isBooking = true);

    final result = await sl<BookSurgeryUseCase>()(
      BookSurgeryParams(
        leadId: leadId,
        paymentMethod: paymentMethod,
        msisdn: msisdn,
      ),
    );

    if (!mounted) return;
    setState(() => _isBooking = false);

    await result.fold(
      (error) async {
        await _showPaymentFailedDialog(message: error);
      },
      (_) async {
        setState(() {
          _status = SurgeryBookingStatus.confirmed;
          _paymentAllowed = false;
        });
        await _showBookingConfirmedDialog();
      },
    );
  }

  Future<void> _showPaymentFailedDialog({String? message}) async {
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialogCard(
        kind: AlertKind.error,
        title: 'Alert',
        message: (message != null && message.trim().isNotEmpty)
            ? message
            : 'Your payment attempt was unsuccessful. Please try again.',
      ),
    );
  }

  Future<void> _showBookingConfirmedDialog() async {
    final i = widget.item;
    final appointmentLabel = i.appointmentDateFull.isNotEmpty
        ? i.appointmentDateFull
        : i.dateCreated;
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialogCard(
        kind: AlertKind.success,
        title: 'Booking Confirmed',
        message:
            'Your surgery booking with ${i.doctor} for ${i.procedure} '
            'is confirmed${appointmentLabel.isNotEmpty ? ' at $appointmentLabel' : ''}'
            '${i.hospital.isNotEmpty ? ' via ${i.hospital}' : ''}.',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return AppScaffoldGradient(
      child: Column(
        children: [
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
                  l10n.bookingsSurgeryDetailsTitle,
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
          AppScaffoldGradientPanel(
            topBorderRadius: 24.r,
            child: Stack(
              children: [
                ListView(
                  padding: EdgeInsets.fromLTRB(
                    16.w,
                    16.h,
                    16.w,
                    _showCheckoutBar ? 110.h : 24.h,
                  ),
                  children: [
                    SurgeryBookingCardWidget(
                      item: widget.item,
                      statusLabel: _statusLabel,
                    ),
                    SizedBox(height: 14.h),
                    SurgeryBookingAppointmentDetailsCardWidget(
                      item: widget.item,
                    ),
                    SizedBox(height: 10.h),
                    const SurgeryBookingRepresentativeNoteWidget(),
                    SizedBox(height: 14.h),
                    SurgeryBookingPatientDetailsCardWidget(item: widget.item),
                    SizedBox(height: 14.h),
                    SurgeryBookingPaymentDetailsCardWidget(item: widget.item),
                  ],
                ),
                if (_showCheckoutBar)
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: SafeArea(
                      top: false,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 12.h),
                        child: SizedBox(
                          height: 56.h,
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _canProceedCheckout
                                ? _openPaymentMethodSheet
                                : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF1AB6A1),
                              foregroundColor: Colors.white,
                              disabledBackgroundColor: const Color(0xFFB0B8C1),
                              disabledForegroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14.r),
                              ),
                            ),
                            child: _isBooking
                                ? SizedBox(
                                    width: 22.r,
                                    height: 22.r,
                                    child: const CircularProgressIndicator(
                                      strokeWidth: 2.4,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white,
                                      ),
                                    ),
                                  )
                                : Text(
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
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
