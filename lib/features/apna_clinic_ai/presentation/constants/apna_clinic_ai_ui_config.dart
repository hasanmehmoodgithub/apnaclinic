import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';

/// Care Companion layout with Apna Clinic teal tokens.
class ApnaClinicAiUiConfig {
  ApnaClinicAiUiConfig._();

  static const Color primaryText = AppColors.clr061E40;
  static const Color secondaryText = AppColors.clr6B7280;
  static const Color muted = AppColors.clr8A93A0;
  static const Color cta = AppColors.clr0FAA9A;
  static const Color ctaDeep = AppColors.clr00897B;
  static const Color ctaSoft = AppColors.clrE8F8F5;
  static const Color mint = AppColors.clrF5FBFA;
  static const Color border = AppColors.clrE3E8EE;
  static const Color borderStrong = AppColors.clrD9DEE6;
  static const Color card = AppColors.clrF8F8F8;
  static const Color panel = AppColors.clrWhite;
  static const Color sand = AppColors.clrFCF5E9;
  static const Color userBubble = AppColors.clr0FAA9A;
  static const Color botBubble = AppColors.clrWhite;
  static const Color systemBubble = AppColors.clrF7EFC7;
  static const Color emergencyBg = AppColors.clrFFF8F8;
  static const Color emergencyBorder = AppColors.clrFDE8E4;
  static const Color emergencyText = AppColors.clrE01F26;
  static const Color avatarWarm = AppColors.clrFFE9C3;
  static const Color online = Color(0xFF2BB673);

  static const List<Color> pageGradient = [
    AppColors.clrF0FAFB,
    AppColors.clrE2F5F7,
    AppColors.clrF4F6F8,
  ];

  static const List<Color> heroGradient = [
    Color(0xFF12B5A4),
    AppColors.clr0FAA9A,
    AppColors.clr00897B,
  ];

  static List<BoxShadow> get softShadow => const [
    BoxShadow(
      color: Color(0x0A061E40),
      blurRadius: 16,
      offset: Offset(0, 6),
    ),
  ];

  static List<BoxShadow> get cardShadow => const [
    BoxShadow(
      color: Color(0x08061E40),
      blurRadius: 10,
      offset: Offset(0, 3),
    ),
  ];
}
