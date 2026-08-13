import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../components/shimmer/app_shimmer.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../generated/assets.dart';
import '../../domain/entities/pharmacy_medicine_entity.dart';
import 'pharmacy_requires_prescription_badge.dart';

class PharmacyMedicineCard extends StatelessWidget {
  const PharmacyMedicineCard({
    super.key,
    required this.medicine,
    required this.onTap,
    required this.onAddToCart,
  });

  final PharmacyMedicineEntity medicine;
  final VoidCallback onTap;
  final VoidCallback onAddToCart;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final packageLabel = medicine.packageType.trim();

    return Material(
      color: AppColors.clrWhite,
      borderRadius: BorderRadius.circular(16.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16.r),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.clrWhite,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: AppColors.clrE3E8EE, width: 1),
          ),
          padding: EdgeInsets.all(10.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 5,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Positioned.fill(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: AppColors.clrF0F4F8,
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12.r),
                          child: CachedNetworkImage(
                            imageUrl: medicine.imageUrl,
                            fit: BoxFit.contain,
                            placeholder: (context, url) => AppShimmer(
                              width: double.infinity,
                              height: double.infinity,
                              borderRadius: 12.r,
                              shape: ShimmerShape.roundedRectangle,
                            ),
                            errorWidget: (context, url, error) {
                              return const ColoredBox(
                                color: AppColors.clrF0F4F8,
                                child: Center(
                                  child: Icon(
                                    Icons.medication_rounded,
                                    color: AppColors.clr8A9AAE,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                    if (medicine.prescriptionRequired)
                      const Positioned(
                        left: 0,
                        top: 0,
                        child: PharmacyRequiresPrescriptionBadge(compact: true),
                      ),
                  ],
                ),
              ),
              SizedBox(height: 10.h),
              CustomPaint(
                painter: const _PharmacyDashedLinePainter(
                  color: AppColors.clrD9DEE6,
                ),
                child: SizedBox(width: double.infinity, height: 1.h),
              ),
              SizedBox(height: 8.h),
              Text(
                medicine.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.titleSmall?.copyWith(
                  color: AppColors.clr060,
                  fontWeight: FontWeight.w700,
                  fontSize: 12.sp,
                  height: 1.25,
                ),
              ),
              const Spacer(),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: RichText(
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text:
                                '${l10n.pharmacyCurrencyPrefix}${medicine.price.toStringAsFixed(0)}',
                            style: theme.textTheme.titleSmall?.copyWith(
                              color: AppColors.clr15A9A0,
                              fontWeight: FontWeight.w700,
                              fontSize: 14.sp,
                            ),
                          ),
                          if (packageLabel.isNotEmpty)
                            TextSpan(
                              text: ' / $packageLabel',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: AppColors.clr8A9AAE,
                                fontWeight: FontWeight.w400,
                                fontSize: 11.sp,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 6.w),
                  InkWell(
                    onTap: onAddToCart,
                    customBorder: const CircleBorder(),
                    child: Image.asset(
                      Assets.iconsAddToCart,
                      width: 36.r,
                      height: 36.r,
                      fit: BoxFit.contain,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PharmacyDashedLinePainter extends CustomPainter {
  const _PharmacyDashedLinePainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    const dashWidth = 4.0;
    const dashSpace = 3.0;
    var startX = 0.0;
    final y = size.height / 2;
    while (startX < size.width) {
      canvas.drawLine(
        Offset(startX, y),
        Offset((startX + dashWidth).clamp(0, size.width), y),
        paint,
      );
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant _PharmacyDashedLinePainter oldDelegate) {
    return oldDelegate.color != color;
  }
}
