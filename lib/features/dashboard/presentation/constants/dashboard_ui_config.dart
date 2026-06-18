/// Figma-aligned layout tokens for the home dashboard.
abstract final class DashboardUiConfig {
  /// Home service grid (2×2).
  static const double serviceGridHorizontalPadding = 20;
  static const double serviceGridSpacing = 12;
  static const double serviceCardAspectRatio = 163 / 130;

  /// Service card chrome.
  static const double serviceCardBorderRadius = 14;
  static const double serviceCardTopPadding = 14;
  static const double serviceCardBottomPadding = 10;
  static const double serviceCardTitleHorizontalPadding = 6;
  static const double serviceCardIconTitleGap = 10;

  /// CMS / Figma icon frame (`viewBox="0 0 63 72"`).
  static const double serviceIconWidth = 63;
  static const double serviceIconHeight = 72;

  static const double serviceDiscountBadgeTop = 6;
  static const double serviceDiscountBadgeRight = 6;

  /// `instant_doc.svg` viewBox (doctor + 24 badge artwork).
  static const double instantDoctorArtworkWidth = 112;
  static const double instantDoctorArtworkHeight = 101;

  /// Instant Doctor home banner card.
  static const double instantDoctorCardHeight = 104;
  static const double instantDoctorCardBorderRadius = 14;
  static const double instantDoctorCardPaddingLeft = 16;
  static const double instantDoctorCardPaddingVertical = 14;
  static const double instantDoctorTextImageGap = 4;
  static const double instantDoctorTitleArrowGap = 2;
  static const double instantDoctorTitleBodyGap = 8;
}
