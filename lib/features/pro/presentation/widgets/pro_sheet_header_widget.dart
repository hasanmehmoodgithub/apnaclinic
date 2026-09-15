import 'package:apnaclinic/core/extensions/context_extensions.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/extensions/screen_util_extensions.dart';

class ProSheetHeaderWidget extends StatelessWidget {
  const ProSheetHeaderWidget({
    super.key,
    required this.logoUrl,
    required this.bannerUrl,
  });

  final String? logoUrl;
  final String? bannerUrl;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        bannerUrl == null
            ? Container(color: AppColors.clrE8F8F5,   height: context.screenHeight/3.5,)
            : CachedNetworkImage(
          width: context.screenWidth,
          height: context.screenHeight/3.5,
                imageUrl: bannerUrl!,
                fit: BoxFit.cover,
                placeholder: (_, _) => Container(
                  color: AppColors.clrE8F8F5,
                ),
                errorWidget: (_, _, _) => Container(
                  color: AppColors.clrE8F8F5,
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.image_outlined,
                    color: AppColors.clr1FAFA3,
                    size: 40.sp,
                  ),
                ),
              ),
      ],
    );
  }
}




