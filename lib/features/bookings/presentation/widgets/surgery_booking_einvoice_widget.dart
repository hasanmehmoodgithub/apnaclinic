import 'package:flutter/material.dart';

import '../../../../core/extensions/screen_util_extensions.dart';

class SurgeryBookingEInvoiceCardWidget extends StatelessWidget {
  const SurgeryBookingEInvoiceCardWidget({
    super.key,
    this.fileName = 'E-Invoice.pdf',
    this.onDownload,
  });

  final String fileName;
  final VoidCallback? onDownload;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

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
          // ── PDF icon (grey rect with red "PDF" tab at the bottom) ──
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
          // ── File name ──
          Expanded(
            child: Text(
              fileName,
              style: textTheme.bodyMedium?.copyWith(
                color: const Color(0xFF061E40),
                fontSize: 15.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          // ── Download icon ──
          GestureDetector(
            onTap: onDownload,
            behavior: HitTestBehavior.opaque,
            child: Icon(
              Icons.file_download_outlined,
              color: const Color(0xFF061E40),
              size: 22.r,
            ),
          ),
        ],
      ),
    );
  }
}