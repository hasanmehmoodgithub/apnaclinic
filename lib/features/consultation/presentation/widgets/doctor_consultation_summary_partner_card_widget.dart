import 'package:flutter/material.dart';

import '../../../../core/extensions/screen_util_extensions.dart';
import '../constants/consultation_partner_filter_defaults.dart';
import 'consultation_partner_logo_widget.dart';
import 'doctor_consultation_summary_card_shell_widget.dart';

class DoctorConsultationSummaryPartnerCardWidget extends StatelessWidget {
  const DoctorConsultationSummaryPartnerCardWidget({
    super.key,
    required this.partnerName,
    required this.partnerLogoUrl,
    this.partnerTenantId = '',
  });

  final String partnerName;
  final String partnerLogoUrl;

  /// `partner.tenantId` — used to resolve known Oladoc/MedIQ name/logo when API
  /// only returns the id.
  final String partnerTenantId;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final known =
        ConsultationPartnerFilterDefaults.knownById(partnerTenantId);
    final displayName = partnerName.trim().isNotEmpty
        ? partnerName.trim()
        : (known?.name ?? '');
    final logo = partnerLogoUrl.trim().isNotEmpty
        ? partnerLogoUrl.trim()
        : (known?.resolvedLogo ?? '');

    return DoctorConsultationSummaryCardShell(
      compact: true,
      child: Row(
        children: [
          ConsultationPartnerLogoWidget(
            logoUrl: logo,
            width: 32.w,
            height: 32.w,
            compact: true,
          ),
          SizedBox(width: 10.w),
          Text(
            displayName.isNotEmpty ? displayName : 'Partner',
            style: textTheme.titleMedium?.copyWith(
              color: const Color(0xFF061E40),
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
