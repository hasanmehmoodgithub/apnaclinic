import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/extensions/screen_util_extensions.dart';
import '../constants/consultation_ui_config.dart';

class ConsultationHeroBannerWidget extends StatelessWidget {
  const ConsultationHeroBannerWidget({
    super.key,
    required this.doctorImage,
  });

  final Widget doctorImage;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 178.h,
      child: Center(
        child: SizedBox(
          width: 240.w,
          height: 178.h,
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              Positioned(
                top: 2.h,
                child: SvgPicture.asset(
                  ConsultationUiConfig.heroVectorAsset,
                  width: 238.w,
                  height: 172.h,
                  fit: BoxFit.contain,
                ),
              ),
              Positioned(
                top: 0,
                child: doctorImage,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
