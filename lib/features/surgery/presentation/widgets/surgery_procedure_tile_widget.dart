import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../generated/assets.dart';

class SurgeryProcedureTileWidget extends StatelessWidget {
  const SurgeryProcedureTileWidget({
    super.key,
    required this.name,
    required this.index,
    required this.onTap,
    required this.onInfoTap,
  });

  final String name;
  final int index;
  final VoidCallback onTap;
  final ValueChanged<BuildContext> onInfoTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10.7.r),
        child: Builder(
          builder: (tileContext) {
            return Container(
              height: 81.689.h,
              decoration: BoxDecoration(
                color: _cardColor(index),
                borderRadius: BorderRadius.circular(10.7.r),
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: 0,
                    right: 0,
                    child: IgnorePointer(
                      child: Opacity(
                        opacity: 0.9,
                        child: SizedBox(
                          child:
                              index.isEven
                                  ? const _CardPatternD2()
                                  : const _CardPatternD1(),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 16.w,
                    top: 33.h,
                    right: 76.w,
                    child: Text(
                      name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: AppColors.clr060,
                        fontWeight: FontWeight.w500,
                        fontSize: 14.sp,
                        height: 1,
                      ),
                    ),
                  ),
                  Positioned(
                    right: 12.w,
                    top: 27.h,
                    child: Container(
                      width: 26.7.r,
                      height: 26.7.r,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.chevron_right_rounded,
                        size: 20.r,
                        color: const Color(0xFFD3D5D8),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 5.w,
                    top: 4.8.h,
                    child: InkWell(
                      onTap: () => onInfoTap(tileContext),
                      borderRadius: BorderRadius.circular(16.r),
                      child: Container(
                        width: 16.r,
                        height: 16.r,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.clr7A7A7A,
                            width: 1,
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          '!',
                          style: Theme.of(context).textTheme.labelSmall
                              ?.copyWith(
                                color: AppColors.clr7A7A7A,
                                fontWeight: FontWeight.w700,
                                fontSize: 10.sp,
                                height: 1,
                              ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Color _cardColor(int idx) {
    const colors = <Color>[
      AppColors.clrE9F9FC,
      AppColors.clrFCE9F0,
      AppColors.clrF5E8FF,
      AppColors.clrECE9FC,
      AppColors.clrE6FEF3,
      AppColors.clrF9F9F9,
    ];
    return colors[idx % colors.length];
  }
}

class _CardPatternD1 extends StatelessWidget {
  const _CardPatternD1();

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(Assets.iconsD1, fit: BoxFit.contain);
  }
}

class _CardPatternD2 extends StatelessWidget {
  const _CardPatternD2();

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(Assets.iconsD2, fit: BoxFit.contain);
  }
}
