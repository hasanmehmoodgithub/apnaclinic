import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../widgets/surgery_booking_details_header_widget.dart';
import '../widgets/surgery_booking_patient_details_card_widget.dart';
import '../widgets/surgery_booking_requirements_card_widget.dart';


enum SurgeryBookingStatus { inReview, paymentPending, confirmed }

class SurgeryBookingDetailsArgs {
  const SurgeryBookingDetailsArgs({
    required this.item,
    required this.initialStatus,
  });

  final SurgeryDetailsItem item;
  final SurgeryBookingStatus initialStatus;
}

class SurgeryDetailsItem {
  final String procedure;
  final String procedureSubtitle;
  final String hospital;
  final String doctor;
  final String specialty;
  final String qualification;
  final String dateCreated;
  final String patientName;
  final int age;
  final String contactNumber;
  final String emergencyContact;
  final int fee;
  final int discountPercent;
  final int discountAmount;
  final int total;
  // Appointment (only used for paymentPending / confirmed states)
  final String appointmentDay;
  final String appointmentMonth;
  final String appointmentWeekday;
  final String appointmentTime;
  final String appointmentDateFull; // e.g. "15th May,2025"

  const SurgeryDetailsItem({
    required this.procedure,
    required this.procedureSubtitle,
    required this.hospital,
    required this.doctor,
    required this.specialty,
    required this.qualification,
    required this.dateCreated,
    required this.patientName,
    required this.age,
    required this.contactNumber,
    required this.emergencyContact,
    required this.fee,
    required this.discountPercent,
    required this.discountAmount,
    required this.total,
    required this.appointmentDay,
    required this.appointmentMonth,
    required this.appointmentWeekday,
    required this.appointmentTime,
    required this.appointmentDateFull,
  });
}

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
      builder: (_) => const _PaymentMethodSheet(),
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
      builder: (_) => const _AlertDialogCard(
        kind: _AlertKind.error,
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
      builder: (_) => _AlertDialogCard(
        kind: _AlertKind.success,
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
    final textTheme = Theme.of(context).textTheme;
    final showCheckout = _status == SurgeryBookingStatus.paymentPending;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7F8),
      // ─── Gradient header (mint → white) ───
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFB8E8E5),
              Color(0xFFEAF6F5),
              Color(0xFFF4F7F8),
            ],
            stops: [0.0, 0.18, 0.28],
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: Column(
            children: [
              const SurgeryBookingDetailsHeaderWidget(),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.fromLTRB(
                    16.w,
                    8.h,
                    16.w,
                    showCheckout ? 110.h : 24.h,
                  ),
                  children: [
                    _buildSurgeryCard(textTheme),
                    SizedBox(height: 14.h),
                    const SurgeryBookingRequirementsCardWidget(),
                    if (_status == SurgeryBookingStatus.paymentPending ||
                        _status == SurgeryBookingStatus.confirmed) ...[
                      SizedBox(height: 14.h),
                      _buildAppointmentDetailsCard(textTheme),
                      SizedBox(height: 10.h),
                      _buildRepresentativeNote(textTheme),
                    ],
                    SizedBox(height: 14.h),
                    SurgeryBookingPatientDetailsCardWidget(item: widget.item),
                    SizedBox(height: 14.h),
                    _buildPaymentDetailsCard(textTheme),
                    if (_status == SurgeryBookingStatus.inReview) ...[
                      SizedBox(height: 14.h),
                      _buildEInvoiceCard(textTheme),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      // ─── Bottom CTA: Proceed Checkout (only when paymentPending) ───
      bottomNavigationBar: showCheckout
          ? SafeArea(
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
      )
          : null,
    );
  }

  // ─────────────── Surgery Booking Card (top) ───────────────
  Widget _buildSurgeryCard(TextTheme textTheme) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: const [
          BoxShadow(
            color: Color(0x33053453), // MATCHED
            blurRadius: 64.2,
            offset: Offset(0, 14),
            spreadRadius: -27,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.r),
        child: Stack(
          children: [
            Positioned(
              right: -100.w,
              top: -40.h,
              child: IgnorePointer(
                child: Container(
                  width: 280.w,
                  height: 280.h,
                  decoration: const BoxDecoration(
                    color: Color(0xFFDFF1F4),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.fromLTRB(10.w, 9.h, 10.w, 9.h), // MATCHED
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// TOP SECTION
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SvgPicture.asset(
                              'assets/icons/surgerybooking.svg',
                              width: 18.r,
                              height: 18.r,
                            ),
                            SizedBox(height: 8.h),

                            /// TITLE
                            Text(
                              widget.item.procedure,
                              style: textTheme.titleMedium?.copyWith(
                                color: const Color(0xFF061E40),
                                fontSize: 18.sp, // MATCHED
                                fontWeight: FontWeight.w500,
                                height: 1.2,
                              ),
                            ),

                            SizedBox(height: 2.h),

                            /// SUBTITLE (hospital instead of custom subtitle)
                            Text(
                              widget.item.hospital,
                              style: textTheme.bodyMedium?.copyWith(
                                color: const Color(0xFF061E40),
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(width: 6.w),

                      /// RIGHT SIDE
                      Column(
                        children: [
                          Container(
                            width: 38.w,
                            height: 38.h,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: const Color(0x36000000),
                                width: 0.4,
                              ),
                            ),
                            child: Center(
                              child: RichText(
                                text: TextSpan(
                                  style: TextStyle(
                                    fontSize: 9.sp,
                                    fontWeight: FontWeight.w700,
                                  ),
                                  children: const [
                                    TextSpan(
                                      text: 'ola',
                                      style: TextStyle(color: Color(0xFFF39A2E)),
                                    ),
                                    TextSpan(
                                      text: 'doc',
                                      style: TextStyle(color: Color(0xFF1F3A8A)),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 8.h),
                          SvgPicture.asset(
                            'assets/icons/surgerymessage.svg',
                            width: 25.r,
                            height: 25.r,
                          ),
                        ],
                      ),
                    ],
                  ),

                  SizedBox(height: 5.h),
                  Container(height: 0.5, color: const Color(0xFFCBD3D9)),
                  SizedBox(height: 5.h),

                  /// DOCTOR ROW (MATCHED STRUCTURE)
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          widget.item.doctor,
                          style: textTheme.bodyMedium?.copyWith(
                            color: const Color(0xFF061E40),
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        '${widget.item.specialty}  |  ${widget.item.qualification}',
                        style: textTheme.bodySmall?.copyWith(
                          color: const Color(0xFF667B99),
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 8.h),
                  Container(height: 0.5, color: const Color(0xFFCBD3D9)),
                  SizedBox(height: 8.h),

                  /// STATUS + DATE + BUTTON (MATCHED)
                  IntrinsicHeight(
                    child: Row(
                      children: [
                        /// STATUS
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Status:',
                              style: textTheme.bodySmall?.copyWith(
                                color: const Color(0xFF667B99),
                                fontSize: 12.sp,
                              ),
                            ),
                            SizedBox(height: 3.h),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 12.w,
                                vertical: 5.h,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFDEF8FB),
                                borderRadius: BorderRadius.circular(20.r),
                              ),
                              child: Text(
                                _statusLabel,
                                style: textTheme.bodyMedium?.copyWith(
                                  color: const Color(0xFF0590A0),
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),

                        Container(
                          width: 0.5,
                          margin: EdgeInsets.symmetric(horizontal: 14.w),
                          color: const Color(0xFF9BA6A7),
                        ),

                        /// DATE
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Date Created',
                              style: textTheme.bodySmall?.copyWith(
                                color: const Color(0xFF667B99),
                                fontSize: 12.sp,
                              ),
                            ),
                            SizedBox(height: 3.h),
                            Text(
                              widget.item.dateCreated,
                              style: textTheme.bodySmall?.copyWith(
                                color: const Color(0xFF667B99),
                                fontSize: 13.sp,
                              ),
                            ),
                          ],
                        ),

                        const Spacer(),

                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─────────────── Requirements Card ───────────────
  // ─────────────── Appointment Details Card ───────────────
  Widget _buildAppointmentDetailsCard(TextTheme textTheme) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: const Color(0xFFE7F6F7),
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Appointment Details',
                  style: textTheme.titleSmall?.copyWith(
                    color: const Color(0xFF061E40),
                    fontSize: 14.sp,
                  ),
                ),
                Text(
                  'Your appointment has been secluded.',
                  style: textTheme.bodySmall?.copyWith(
                    color: const Color(0xFF667B99),
                    fontSize: 9.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          // Day box
          Container(
            padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: Colors.transparent,
              border: Border.all(
                color:Color(0xFFB6D2D5),
              ),
              borderRadius: BorderRadius.circular(6.r),
            ),
            child: Text(
              widget.item.appointmentDay,
              style: textTheme.titleMedium?.copyWith(
                color: const Color(0xFF061E40),
                fontSize: 15.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          SizedBox(width: 6.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.item.appointmentMonth,
                style: textTheme.bodyMedium?.copyWith(
                  color: const Color(0xFF061E40),
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                widget.item.appointmentWeekday,
                style: textTheme.bodySmall?.copyWith(
                  color: const Color(0xFF667B99),
                  fontSize: 11.sp,
                ),
              ),
            ],
          ),
          SizedBox(width: 10.w),
          Container(
            width: 0.8,
            height: 30.h,
            color: const Color(0xFFB6D2D5),
          ),
          SizedBox(width: 8.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Icon(Icons.access_time,
                      size: 12.r, color: const Color(0xFF061E40)),
                  SizedBox(width: 3.w),
                  Text(
                    'Time',
                    style: textTheme.bodySmall?.copyWith(
                      color: const Color(0xFF061E40),
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 2.h),
              Text(
                widget.item.appointmentTime,
                style: textTheme.bodySmall?.copyWith(
                  color: const Color(0xFF061E40),
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRepresentativeNote(TextTheme textTheme) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: const Color(0xFFFCF1E2),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'Our representative will contact you in 24 hours.',
              style: textTheme.bodyMedium?.copyWith(
                color: const Color(0xFF061E40),
                fontSize: 13.sp,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          Icon(Icons.error_outline,
              size: 18.r, color: const Color(0xFF061E40)),
        ],
      ),
    );
  }

  Widget _buildPaymentDetailsCard(TextTheme textTheme) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0F053453),
            blurRadius: 16,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Title + Fee + Discount get horizontal padding ──
          Padding(
            padding: EdgeInsets.fromLTRB(10.w, 10.h, 10.w, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Payment Details',
                  style: textTheme.titleMedium?.copyWith(
                    color: const Color(0xFF061E40),
                    fontSize: 14.sp,
                  ),
                ),
                SizedBox(height: 12.h),
                _paymentRow('Fee', widget.item.fee, textTheme),
                Container(
                  height: 0.6,
                  margin: EdgeInsets.symmetric(vertical: 6.h),
                  color: const Color(0xFFE2E8EE),
                ),
                _paymentRow(
                  'Discount (${widget.item.discountPercent}%)',
                  widget.item.discountAmount,
                  textTheme,
                  trailingDecimal: '.0',
                ),
                SizedBox(height: 14.h),
              ],
            ),
          ),
          // ── Total bar: NO outer padding → spans full card width ──
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
            color: const Color(0xFFEEF1F3),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Total',
                    style: textTheme.titleSmall?.copyWith(
                      color: const Color(0xFF061E40),
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'Rs.',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: const Color(0xFF8593A8),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      TextSpan(
                        text: _formatNumber(widget.item.total),
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: const Color(0xFF061E40),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _paymentRow(
      String label,
      int amount,
      TextTheme textTheme, {
        String trailingDecimal = '',
      }) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: textTheme.bodyMedium?.copyWith(
              color: const Color(0xFF8593A8),
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: 'Rs.',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: const Color(0xFF8593A8),
                  fontWeight: FontWeight.w400,
                ),
              ),
              TextSpan(
                text: '${_formatNumber(amount)}$trailingDecimal',
                style: TextStyle(
                  fontSize: 13.sp,
                  color: const Color(0xFF061E40),
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ─────────────── E-Invoice Card (only inReview) ───────────────
  Widget _buildEInvoiceCard(TextTheme textTheme) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0F053453),
            blurRadius: 16,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 32.w,
            height: 36.h,
            decoration: BoxDecoration(
              color: const Color(0xFFF3F5F7),
              borderRadius: BorderRadius.circular(4.r),
            ),
            alignment: Alignment.bottomCenter,
            child: Container(
              width: 32.w,
              padding: EdgeInsets.symmetric(vertical: 2.h),
              decoration: BoxDecoration(
                color: const Color(0xFFD92D20),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(4.r),
                  bottomRight: Radius.circular(4.r),
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                'PDF',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 8.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              'E-Invoice.pdf',
              style: textTheme.bodyMedium?.copyWith(
                color: const Color(0xFF061E40),
                fontSize: 15.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Icon(Icons.file_download_outlined,
              color: const Color(0xFF061E40), size: 22.r),
        ],
      ),
    );
  }

  // ─────────────── Helpers ───────────────
  String _formatNumber(int n) {
    final s = n.toString();
    final buf = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      final reverseIndex = s.length - i;
      buf.write(s[i]);
      if (reverseIndex > 1 && reverseIndex % 3 == 1) buf.write(',');
    }
    return buf.toString();
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  Payment Method Bottom Sheet
// ─────────────────────────────────────────────────────────────────────────────
class _PaymentMethodSheet extends StatefulWidget {
  const _PaymentMethodSheet();

  @override
  State<_PaymentMethodSheet> createState() => _PaymentMethodSheetState();
}

class _PaymentMethodSheetState extends State<_PaymentMethodSheet> {
  String _selected = 'jazz_cash';

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.r),
          topRight: Radius.circular(20.r),
        ),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 10.h),
            // Drag handle
            Container(
              width: 38.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: const Color(0xFFCBD3D9),
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
            SizedBox(height: 18.h),
            // Title
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Row(
                children: [
                  Text(
                    'Payment Method',
                    style: textTheme.titleLarge?.copyWith(
                      color: const Color(0xFF061E40),
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.h),
            // JazzCash option
            _PaymentOption(
              value: 'jazz_cash',
              groupValue: _selected,
              onChanged: (v) => setState(() => _selected = v),
              label: 'Jazz Cash',
              iconBuilder: () => Container(
                width: 42.w,
                height: 42.w,
                decoration: const BoxDecoration(
                  color: Color(0xFFFEE9CC),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  'Jazz\nCash',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: const Color(0xFFB91C1C),
                    fontSize: 8.sp,
                    fontWeight: FontWeight.w800,
                    height: 1.0,
                  ),
                ),
              ),
            ),
            Container(
              height: 0.6,
              margin: EdgeInsets.symmetric(horizontal: 20.w),
              color: const Color(0xFFE2E8EE),
            ),
            // Debit/Credit option
            _PaymentOption(
              value: 'card',
              groupValue: _selected,
              onChanged: (v) => setState(() => _selected = v),
              label: 'Debit / Credit Card',
              iconBuilder: () => Container(
                width: 42.w,
                height: 42.w,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFFE2E8EE),
                    width: 0.6,
                  ),
                ),
                alignment: Alignment.center,
                child: Icon(
                  Icons.credit_card,
                  size: 22.r,
                  color: const Color(0xFF1F8AC7),
                ),
              ),
            ),
            SizedBox(height: 24.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: SizedBox(
                width: double.infinity,
                height: 54.h,
                child: ElevatedButton(
                  onPressed: () => context.pop(_selected),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1AB6A1),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14.r),
                    ),
                  ),
                  child: Text(
                    'Proceed',
                    style: textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 16.h),
          ],
        ),
      ),
    );
  }
}

class _PaymentOption extends StatelessWidget {
  final String value;
  final String groupValue;
  final ValueChanged<String> onChanged;
  final String label;
  final Widget Function() iconBuilder;

  const _PaymentOption({
    required this.value,
    required this.groupValue,
    required this.onChanged,
    required this.label,
    required this.iconBuilder,
  });

  @override
  Widget build(BuildContext context) {
    final selected = value == groupValue;
    return InkWell(
      onTap: () => onChanged(value),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 14.h),
        child: Row(
          children: [
            iconBuilder(),
            SizedBox(width: 14.w),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  color: const Color(0xFF061E40),
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            // Custom radio
            Container(
              width: 22.r,
              height: 22.r,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: selected
                      ? const Color(0xFF061E40)
                      : const Color(0xFFCBD3D9),
                  width: 1.4,
                ),
              ),
              alignment: Alignment.center,
              child: selected
                  ? Container(
                width: 12.r,
                height: 12.r,
                decoration: const BoxDecoration(
                  color: Color(0xFF061E40),
                  shape: BoxShape.circle,
                ),
              )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  Alert / Booking Confirmed dialog
// ─────────────────────────────────────────────────────────────────────────────
enum _AlertKind { error, success }

class _AlertDialogCard extends StatelessWidget {
  final _AlertKind kind;
  final String title;
  final String message;
  const _AlertDialogCard({
    required this.kind,
    required this.title,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    final isSuccess = kind == _AlertKind.success;
    final textTheme = Theme.of(context).textTheme;
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.fromLTRB(20.w, 28.h, 20.w, 20.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64.r,
              height: 64.r,
              decoration: BoxDecoration(
                color: isSuccess
                    ? const Color(0xFF1FB877)
                    : const Color(0xFFFFC233),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Icon(
                isSuccess ? Icons.check : Icons.priority_high_rounded,
                color: Colors.white,
                size: 38.r,
              ),
            ),
            SizedBox(height: 18.h),
            Text(
              title,
              textAlign: TextAlign.center,
              style: textTheme.titleLarge?.copyWith(
                color: const Color(0xFF061E40),
                fontSize: 20.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 10.h),
            Text(
              message,
              textAlign: TextAlign.center,
              style: textTheme.bodyMedium?.copyWith(
                color: const Color(0xFF667B99),
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                height: 1.4,
              ),
            ),
            SizedBox(height: 22.h),
            SizedBox(
              width: double.infinity,
              height: 52.h,
              child: ElevatedButton(
                onPressed: () => context.pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1AB6A1),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                ),
                child: Text(
                  'Close',
                  style: textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
