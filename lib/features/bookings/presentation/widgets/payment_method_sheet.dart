import 'package:apnaclinic/features/bookings/presentation/widgets/payment_option.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../core/extensions/build_context_extensions.dart';
import '../../../../core/extensions/screen_util_extensions.dart';

class PaymentMethodSheet extends StatefulWidget {
  const PaymentMethodSheet();

  @override
  State<PaymentMethodSheet> createState() => PaymentMethodSheetState();
}

class PaymentMethodSheetState extends State<PaymentMethodSheet> {
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
            PaymentOption(
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
            PaymentOption(
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