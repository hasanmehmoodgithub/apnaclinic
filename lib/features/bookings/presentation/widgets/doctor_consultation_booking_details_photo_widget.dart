import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../generated/assets.dart';

/// Doctor photo on consultation booking details; placeholder if URL is empty or load fails.
class DoctorConsultationBookingDetailsPhotoWidget extends StatelessWidget {
  const DoctorConsultationBookingDetailsPhotoWidget({
    super.key,
    required this.imageUrl,
  });

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    final width = 188.w;
    final height = 160.h;
    final trimmed = imageUrl.trim();
    final Widget image;
    if (trimmed.isEmpty) {
      image = _placeholder(width, height);
    } else if (trimmed.startsWith('http://') ||
        trimmed.startsWith('https://')) {
      image = CachedNetworkImage(
        imageUrl: trimmed,
        width: width,
        height: height,
        fit: BoxFit.cover,
        placeholder: (_, _) => _placeholder(width, height),
        errorWidget: (_, _, _) => _placeholder(width, height),
      );
    } else {
      image = Image.asset(
        trimmed,
        width: width,
        height: height,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => _placeholder(width, height),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(14.r),
      child: image,
    );
  }

  Widget _placeholder(double width, double height) {
    return Image.asset(
      Assets.imgPlaceHolderPerson,
      width: width,
      height: height,
      fit: BoxFit.contain,
    );
  }
}
