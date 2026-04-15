import 'package:apnaclinic/core/constants/app_colors.dart';
import 'package:apnaclinic/generated/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/extensions/screen_util_extensions.dart';

/// Service card: service image as the only background; text and offer on top.
class OurServiceCardWidget extends StatelessWidget {
  const OurServiceCardWidget({
    super.key,
    required this.title,
    required this.subtitle,
    required this.discountLabel,
    required this.imageAsset,
    this.onTap,
  });

  final String title;
  final String subtitle;
  final String discountLabel;
  final String imageAsset;
  final VoidCallback? onTap;

  static  final double _cardHeight = 100.h;


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ImageProvider serviceImageProvider = imageAsset.startsWith('http')
        ? NetworkImage(imageAsset)
        : AssetImage(imageAsset) as ImageProvider;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.r),
      child: Container(
        height: _cardHeight.h,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.r),
          image: DecorationImage(
            image: serviceImageProvider,
            fit: BoxFit.cover, // better than contain for background
            alignment: Alignment.centerRight, // tweak based on design
          ),
        ),
        child: Container(

          padding: EdgeInsets.fromLTRB(8.w, 8.h, 8.w, 8.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.clr09,
                  fontSize: 16.sp,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 5.h),
              Text(
                subtitle,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: AppColors.clr43,
                  fontWeight: FontWeight.w400,
                  fontSize: 12.sp,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 6.h),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 8.w,
                  vertical: 4.h,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFDB61),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SvgPicture.asset(
                      Assets.svgIcServiceOffer,
                      width: 14.r,
                      height: 14.r,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      discountLabel,
                      style: theme.textTheme.labelSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                        fontSize: 14.sp,
                        color:  Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}