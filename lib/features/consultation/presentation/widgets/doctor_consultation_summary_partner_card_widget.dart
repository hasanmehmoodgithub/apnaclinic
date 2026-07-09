import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../generated/assets.dart';
import 'doctor_consultation_summary_card_shell_widget.dart';

class DoctorConsultationSummaryPartnerCardWidget extends StatelessWidget {
  const DoctorConsultationSummaryPartnerCardWidget({
    super.key,
    required this.partnerName,
    required this.partnerLogoUrl,
  });

  final String partnerName;
  final String partnerLogoUrl;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final displayName = partnerName.trim().isNotEmpty ? partnerName.trim() : 'MediQ';

    return DoctorConsultationSummaryCardShell(
      compact: true,
      child: Row(
        children: [
          _PartnerLogo(logoUrl: partnerLogoUrl),
          SizedBox(width: 10.w),
          Text(
            displayName,
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

class _PartnerLogo extends StatelessWidget {
  const _PartnerLogo({required this.logoUrl});

  final String logoUrl;

  @override
  Widget build(BuildContext context) {
    if (logoUrl.trim().isNotEmpty) {
      return SizedBox(
        width: 32.w,
        height: 32.w,
        child: CachedNetworkImage(
          imageUrl: logoUrl,
          fit: BoxFit.contain,
          placeholder: (_, _) => _fallbackLogo(),
          errorWidget: (_, _, _) => _fallbackLogo(),
        ),
      );
    }
    return _fallbackLogo();
  }

  Widget _fallbackLogo() {
    return SizedBox(
      width: 32.w,
      height: 32.w,
      child: SvgPicture.asset(
        Assets.labTestBookingMediqLogo,
        fit: BoxFit.contain,
      ),
    );
  }
}
