import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/di/dependency_injection.dart';
import '../../../../core/services/responsive_config_service.dart';
import '../../domain/entities/consultation_category_entity.dart';
import '../constants/consultation_ui_config.dart';
import 'consultation_category_icon_widget.dart';

class ConsultationCategoryCard extends StatelessWidget {
  final ConsultationCategoryEntity category;
  final ValueChanged<Offset> onInfoTap;
  final VoidCallback onTap;

  const ConsultationCategoryCard({
    super.key,
    required this.category,
    required this.onInfoTap,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final responsive = sl<ResponsiveConfigService>();
    final textTheme = Theme.of(context).textTheme;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(responsive.r(context, 10.7)),
        onTap: onTap,
        child: Container(
          height: responsive.h(context, 81.7),
          decoration: BoxDecoration(
            color: ConsultationUiConfig.cardBackground,
            borderRadius: BorderRadius.circular(responsive.r(context, 10.7)),
          ),
          child: Stack(
            children: [
              Positioned.fill(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(responsive.r(context, 10.7)),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: Opacity(
                      opacity: 0.32,
                      child: SvgPicture.asset(
                        ConsultationUiConfig.cardPatternAsset,
                        width: responsive.w(context, 112),
                        height: responsive.h(context, 68),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: responsive.w(context, 14),
                top: responsive.h(context, 16),
                right: responsive.w(context, 70),
                child: Text(
                  category.cardTitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.titleMedium?.copyWith(
                    fontSize: responsive.sp(context, 15.3),
                    height: 1.0,
                    fontWeight: FontWeight.w500,
                    color: ConsultationUiConfig.primaryText,
                  ),
                ),
              ),
              Positioned(
                right: responsive.w(context, 10),
                bottom: responsive.h(context, 8),
                child: ConsultationCategoryIconWidget(
                  iconUrl: category.iconUrl,
                  width: responsive.w(context, 50),
                  height: responsive.h(context, 50),
                ),
              ),
              Positioned(
                top: responsive.h(context, 3),
                right: responsive.w(context, 3),
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTapDown: (details) => onInfoTap(details.globalPosition),
                  child: SizedBox(
                    width: responsive.w(context, 22),
                    height: responsive.h(context, 22),
                    child: Center(
                      child: SizedBox(
                        width: responsive.w(context, 16),
                        height: responsive.h(context, 16),
                        child: _InfoIcon(responsive: responsive),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoIcon extends StatelessWidget {
  final ResponsiveConfigService responsive;

  const _InfoIcon({required this.responsive});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        SvgPicture.asset(
          ConsultationUiConfig.infoCircleAsset,
          fit: BoxFit.contain,
        ),
        Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: responsive.w(context, 1.4),
                height: responsive.h(context, 4.8),
                decoration: BoxDecoration(
                  color: const Color(0xFF374957),
                  borderRadius: BorderRadius.circular(responsive.r(context, 2)),
                ),
              ),
              SizedBox(height: responsive.h(context, 1.8)),
              Container(
                width: responsive.w(context, 1.5),
                height: responsive.h(context, 1.5),
                decoration: const BoxDecoration(
                  color: Color(0xFF374957),
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
