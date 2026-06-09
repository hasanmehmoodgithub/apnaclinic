import 'package:flutter/material.dart';

import '../../../../core/extensions/screen_util_extensions.dart';
import 'consultation_partner_logo_widget.dart';

class ResultsPartnerBadge extends StatelessWidget {
  const ResultsPartnerBadge({
    super.key,
    required this.partnerLogoUrl,
  });

  final String partnerLogoUrl;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topRight,
      padding: EdgeInsets.only(top: 1.h),
      child: ConsultationPartnerLogoWidget(
        logoUrl: partnerLogoUrl,
        width: 60.w,
        height: 30.h,
      ),
    );
  }
}
