import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/extensions/screen_util_extensions.dart';

class DoctorConsultationBookingDetailsPhotoWidget extends StatelessWidget {
  const DoctorConsultationBookingDetailsPhotoWidget({
    super.key,
    required this.imageUrl,
  });

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(14.r),
      child: SizedBox(
        width: 188.w,
        height: 160.h,
        child: imageUrl.trim().isEmpty
            ? ColoredBox(
                color: AppColors.clrF7F7F7,
                child: Icon(
                  Icons.person_rounded,
                  color: AppColors.clrBFC7CF,
                  size: 56.r,
                ),
              )
            : CachedNetworkImage(
                imageUrl: imageUrl,
                width: 188.w,
                height: 160.h,
                fit: BoxFit.cover,
                placeholder: (_, _) => ColoredBox(
                  color: AppColors.clrF7F7F7,
                  child: Center(
                    child: SizedBox(
                      width: 22.r,
                      height: 22.r,
                      child: const CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
                ),
                errorWidget: (_, _, _) => ColoredBox(
                  color: AppColors.clrF7F7F7,
                  child: Icon(
                    Icons.person_rounded,
                    color: AppColors.clrBFC7CF,
                    size: 56.r,
                  ),
                ),
              ),
      ),
    );
  }
}
