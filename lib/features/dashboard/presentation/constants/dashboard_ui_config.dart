/// Figma-aligned layout tokens for the home dashboard.
abstract final class DashboardUiConfig {
  /// Home service grid (2×2).
  static const double serviceGridHorizontalPadding = 20;
  static const double serviceGridSpacing = 12;

  /// Service card frame (Figma reference width; height is content-driven).
  static const double serviceCardWidth = 195;

  /// Service card chrome.
  static const double serviceCardBorderRadius = 20;
  static const double serviceCardTopPadding = 8;
  static const double serviceCardBottomPadding = 8;
  static const double serviceCardTitleHorizontalPadding = 8;
  static const double serviceCardIconTitleGap = 4;
  static const double serviceCardTitleFontSize = 16;

  /// Approximate title block for shimmer placeholders (2 lines).
  static const double serviceCardTitleBlockHeight = 34;

  /// Minimum shimmer height while service cards load (badge slot + icon + title).
  static double get serviceCardShimmerHeight =>
      serviceCardTopPadding +
      serviceDiscountBadgeSlotHeight +
      serviceCardIconTitleGap +
      serviceIconHeight +
      serviceCardIconTitleGap +
      serviceCardTitleBlockHeight +
      serviceCardBottomPadding;

  /// Home service image size (larger than the original 63×72 CMS frame).
  static const double serviceIconWidth = 90;
  static const double serviceIconHeight = 95;

  static const double serviceDiscountBadgeTop = 8;
  static const double serviceDiscountBadgeRight = 8;
  static const double serviceDiscountBadgeHorizontalPadding = 8;
  static const double serviceDiscountBadgeVerticalPadding = 4;
  static const double serviceDiscountBadgeFontSize = 10;
  /// One-line chip height (padding + text). Always reserved so image/title do not jump.
  static const double serviceDiscountBadgeSlotHeight =
      serviceDiscountBadgeVerticalPadding * 2 +
      serviceDiscountBadgeFontSize * 1.2;
  /// Keeps long API discount copy inside the card (wraps when exceeded).
  static const double serviceDiscountBadgeMaxWidth = 160;

  /// Instant Doctor artwork (Figma).
  static const double instantDoctorArtworkWidth = 104.22074890136719;
  static const double instantDoctorArtworkHeight = 94.35057067871094;

  /// Instant Doctor home banner (Figma 398×98.35).
  static const double instantDoctorCardWidth = 398;
  static const double instantDoctorCardHeight = 98.35057067871094;
  static const double instantDoctorCardBorderRadius = 16;
  static const double instantDoctorCardPadding = 4;
  static const double instantDoctorCardPaddingLeft = 16;
  static const double instantDoctorTextImageGap = 4;
  static const double instantDoctorTitleArrowGap = 2;
  static const double instantDoctorTitleBodyGap = 2;

  /// Promo dialog image while the network banner loads (portrait CMS art).
  static const double promotionalBannerPlaceholderAspectRatio = 3 / 4;
  static const double promotionalBannerBorderRadius = 16;
  static const double promotionalBannerShimmerOpacity = 0.8;

  /// Teal home header (`HomeHeaderSection`).
  static const double homeHeaderBottomRadius = 30;
  static const double homeHeaderHorizontalPadding = 20;
  static const double homeHeaderGreetingTopGap = 4;
  static const double homeHeaderGreetingSearchGap = 14;
  static const double homeHeaderBottomPadding = 18;
  static const double homeHeaderSearchHeight = 48;
  static const double homeHeaderBelowSpacing = 12;
}
