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

  /// Approximate title block for shimmer placeholders (2 lines @ 12sp).
  static const double serviceCardTitleBlockHeight = 30;

  /// Minimum shimmer height while service cards load (icon + title + padding).
  static double get serviceCardShimmerHeight =>
      serviceCardTopPadding +
      serviceIconHeight +
      serviceCardIconTitleGap +
      serviceCardTitleBlockHeight +
      serviceCardBottomPadding;

  /// CMS / Figma icon frame (`viewBox="0 0 63 72"`).
  static const double serviceIconWidth = 63;
  static const double serviceIconHeight = 72;

  static const double serviceDiscountBadgeTop = 8;
  static const double serviceDiscountBadgeRight = 8;
  static const double serviceDiscountBadgeHorizontalPadding = 8;
  static const double serviceDiscountBadgeVerticalPadding = 4;
  static const double serviceDiscountBadgeFontSize = 10;
  /// Keeps long API discount copy inside the card (wraps when exceeded).
  static const double serviceDiscountBadgeMaxWidth = 160;

  /// `instant_doc.svg` viewBox (doctor + 24 badge artwork).
  static const double instantDoctorArtworkWidth = 112;
  static const double instantDoctorArtworkHeight = 101;

  /// Instant Doctor home banner card.
  static const double instantDoctorCardBorderRadius = 14;
  static const double instantDoctorCardPaddingLeft = 16;
  static const double instantDoctorCardPaddingVertical = 14;
  static const double instantDoctorTextImageGap = 4;
  static const double instantDoctorTitleArrowGap = 2;
  static const double instantDoctorTitleBodyGap = 8;

  /// Teal home header (`HomeHeaderSection`).
  static const double homeHeaderBottomRadius = 30;
  static const double homeHeaderHorizontalPadding = 20;
  static const double homeHeaderGreetingTopGap = 4;
  static const double homeHeaderGreetingSearchGap = 14;
  static const double homeHeaderBottomPadding = 18;
  static const double homeHeaderSearchHeight = 48;
  static const double homeHeaderBelowSpacing = 12;
}
